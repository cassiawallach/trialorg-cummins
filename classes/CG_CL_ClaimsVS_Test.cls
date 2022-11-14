@isTest
public class CG_CL_ClaimsVS_Test{
    
    @isTest(seealldata = true)
    public static  void TestAllmethods(){
        
        System.runAs ( new User(Id = UserInfo.getUserId())){
            //Job record
            CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
            
            //Account record
            Account acc = new Account();
            acc.name='Rtest123';
            acc.CSS_DistributorCode__c='03742';
            //acc.IAM_Service_Provider_Code__c='03742';
            acc.Type='Dealer Account';
            acc.IAM_Service_Provider_Code__c = '03741';
            acc.CMI_Account_Status__c = 'Active';
            //acc.IAM_Service_Provider_Code__c = '03742';
            //acc.Type='Dealer Account';
            //acc.Region__c = 'US and Canada';
            //acc.Location__c = '12345-12345';
            insert acc;
            
            //User record    
            Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Data_ExChange_Admin'];
            Contact objContact = new Contact(LastName ='Setty',AccountId = acc.Id,CMI_Contact_Type__c = 'Secondary',
                                             IAM_Cummins_login_ID__c='Wenchin@truck.com',IAM_Contact_Status__c = 'Active',Email = 'Wenchin.setty@gmail.com',
                                             FirstName ='Wenchin',Phone='000-000-0000');
            insert objContact; 
            User u = new User(Alias = 'wenchin', Email='wenchinsetty@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='wenchinsetty@truck.com',User_Location__c = '03742-03741',ContactId=objContact.id);
            //insert u;
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03741');
            insert userLocation;
            id UserId = u.Id;
            system.debug('UserId:' +UserId);
            css_utility.getOrgType(UserId);
            
            Group Q = new Group();
            Q.Type = 'Queue';
            Q.Name = 'CQ'+'-'+'03520-04892';
            insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=Q.Id);
            insert q1;
            String Ins_JobId =ApexPages.currentPage().getParameters().get('id');
            
            //Claim record
            CSS_Claims__c claim = new CSS_Claims__c();
            claim.Contact_First_Name__c='TestUser';
            claim.Location_Code__c='03520-04893';
            claim.ESN__c='12345';
            claim.Catastrophic__c = true;
            claim.Shop_Work_Order__c='1234';
            claim.Account__c = acc.id;
            claim.TSR1__c='Test';
            claim.TSR2__c='Test';
            claim.TSR3__c='Test';
            claim.TSR4__c='Test';
            claim.TSR1__c='Test';
            claim.TSR5__c='Test';
            claim.TSR6__c='Test';
            claim.TSR7__c='Test';
            claim.TSR8__c='Test';
            claim.TSR9__c='Test';
            claim.TSR10__c='Test';
            claim.ODM_Penalty__c='100';
            claim.ownerId = UserInfo.getUserId();
            claim.Assigned_To__c =  UserInfo.getUserId();
            claim.Additional_Tech1__c= UserInfo.getUserId();
            claim.Additional_Tech2__c= UserInfo.getUserId();
            claim.Additional_Tech3__c= UserInfo.getUserId();
            claim.Additional_Tech4__c= UserInfo.getUserId();
            claim.Additional_Tech5__c= UserInfo.getUserId();
            claim.Additional_Tech6__c= UserInfo.getUserId();
            claim.Additional_Tech7__c= UserInfo.getUserId();
            claim.Additional_Tech8__c= UserInfo.getUserId();
            claim.Additional_Tech9__c= UserInfo.getUserId();
            upsert claim;
            
            
            //psn
            CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            testpsnNewRec.psn__c = '79464646';
            testpsnNewRec.Primary__C = true;
            testpsnNewRec.failure_Date__c = date.today() - 20;
            testpsnNewRec.css_claims__C = claim.id;
            insert testpsnNewRec;
            
            
            //Soltuion component
            List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
            solcomp.System_Code__c='TH';
            solcomp.Component_Code__c='AC';
            solcomp.System_Code__c='te';
            solcomp.AccountCode__c='SERVICE TOOL WARRANTY 52';
            solcomp.Fail_Code_Editable__c='THAC';
            solcomp.CSS_Claims__c=claim.id;
            solcomp.Type__c = 'Campaign';
            solcomp.Claim_Type__c='DBUCPP';
            solcomp.Selected_Claim_Type__c='DBUCPP';
            solcomp.Part_Warranty_Start_Date__c=system.today()-12;
            solcomp.Failure_Date__c=system.today();
            solcomp.Failure_Point__c=2.0;
            solcomp.Status__c='Approved';
            //solcomp.Selected_Component__c=true;
            lstsolcomp.add(solcomp);
            insert lstsolcomp;
            
            String solId = ApexPages.CurrentPage().getParameters().get('solid');
            String nSolId = ApexPages.CurrentPage().getParameters().get('Nsolid');
            
            list<css_solutions__c> solsList=new list<css_solutions__c>();
            css_solutions__c sol1=new css_solutions__c();
            sol1.CSS_Nested_Solutions__c=solId;
            sol1.Repair_Notes__c='testing';
            //sol1.FSL_Service_job__c = JO.Id;
            sol1.Service_Job__c = JO.Id;
            solsList.add(sol1);
            insert solsList;
            CSS_Solutions__c NSoln=new CSS_Solutions__c();
            NSoln.id=nSolId;
            NSoln.Repair_Notes__c='testing';
            Nsoln.name='prashanthi';
            Nsoln.Report_Comments__c='test123';
            //Nsoln.FSL_Service_job__c = JO.Id;
            Nsoln.Service_Job__c = JO.Id;
            upsert NSoln;
            
            list<CSS_Solution_Component__c> solcomplist=new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solcomp11=new CSS_Solution_Component__c();
            solcomp11.Solutions__c = NSoln.Id;
            //solcomp1.id=NSoln.id;
            solcomp11.Selected_Component__c=true;
            solcomp11.Status__c='Approved';
            solcomp11.Service_Job__c = Ins_JobId ;
            
            
            solcomplist.add(solcomp11);
            insert solcomplist;

            //Query
            RecordType rtbms = [SELECT id,Name 
                                FROM RecordType 
                                WHERE name='BMS Parts'];
            RecordType rtoc = [SELECT id,Name 
                               FROM RecordType 
                               WHERE name='OtherClaimables'];
            
            RecordType rtp = [SELECT id,Name 
                              FROM RecordType 
                              WHERE name='Parts'];
            
            //Part Option list
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
            parts.CSS_Claims__c = claim.id;
            parts.recordtypeid = rtbms.id;
            parts.Account_Code__c='SERVICE TOOL WARRANTY 52';
            parts.Fail_Code__c='THAC';
            parts.Covered__c = 100;
            lstparts.add(parts);
            system.debug('parts.Fail_Code__c'+parts.Fail_Code__c);
            
            
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
            parts1.selected_part__c = True;
            parts1.Service_partnumber__c = '540571401';
            parts1.OEM__c = 'OEMWRS';
            parts1.Part_Name__c = 'TestPartCamp';
            parts1.ReturnToFactory__c = 'Campaign-TRP-ATC';
            parts1.Replacement_Reason__c = 'Campaign-TRP-ATC';
            parts1.Quantity__c = 55;
            parts1.Notes__c = 'Test Notes';
            parts1.CSS_Claims__c = claim.id;
            parts1.recordtypeid=rtp.id;
            parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            parts1.Fail_Code__c='THAC';
            lstparts.add(parts1);
            insert lstparts;
            system.debug('parts1.Fail_Code__c'+parts1.Fail_Code__c);
            
            
            //SRT List                  
            List<CSS_srt__c> lstsrt = new List<CSS_srt__c>();
            CSS_srt__c srt = new CSS_srt__c();
            srt.SRT_AccessiblityCheck__c=TRUE;
            SRT.Component_Id__c = solcomp.id;
            srt.SRT_Details__c = 'test';
            srt.SRT_Title__c = 'MR';
            srt.CSS_Claims__c = claim.id;
            srt.Account_Code__c='SERVICE TOOL WARRANTY 52';
            srt.Fail_Code_Description__c='THAC';
            srt.Type__c ='Field Action';
            srt.FailCode__c = 'THAC';
            srt.SRT_Warrantable__c='100';
            lstsrt.add(srt);
            insert lstSrt;
            
            
            List<CSS_AccredUser__c> listAUserlist = new List<CSS_AccredUser__c>();
            CSS_AccredUser__c causer=new CSS_AccredUser__c();
            causer.Name='Test';
            causer.User__c=UserInfo.getUserId();
            //causer.Accreditation__c='Test';
            //insert causer;
            
            
            
            
            //TEST START
            PageReference pageRef = Page.CG_ClaimsVS;
            pageRef.getParameters().put('id', claim.id);
            Test.setCurrentPage(pageRef); 
            user u1=new user();
            
            CG_CL_ClaimsVS claims = new CG_CL_ClaimsVS();
            claims.exchangeRate=1.33;
            claims.userType = 'DLR';
            claims.totalUSD = 10.2;
            claims.partsUSD = 11.0;
            claims.claimsSCList = lstsolcomp;
            claims.claimsPOList = lstparts;
            claims.claimsSRTList = lstsrt;
            //claims.multiPSN_CampNum=null;
            //claims.accCodeSelected = 'acc70';
            claims.getTechPromotionId_TTML();
            claims.fetchClaimRecords();
            claims.updateClaimRecord();
            claims.updateSRTforPenalty();
            claims.displayEditfunctioanity();
            claims.pendingAuthrizationFlag();
            claims.failcodeEQErrorFlag();
            claims.checkaccountcodeCoverage();
              Test.startTest();
            claims.verifySubmitpgAction();
            
            claims.savePartsTotal();
            claims.assignWarrantyAuthFlag();
            claims.fetchAccountFailCodeCombo();
            claims.getMultiPSN();
            //claims.fetchClaimRelatedRecords();
            claims.fetchAccountFailCodeCombo();
            claims.nVclaimsIntake();
            claims.nvClaimsWC();
            claims.nvClaimsVH();
            claims.nvClaimsCC();
            claims.nvClaimsFC();
            claims.nvClaimsPSN();
            claims.nvClaimsSRTs();
            claims.nvClaimsPOC();
            claims.nvClaimsJobNotes();
            claims.nvClaimsVS();
            claims.getOverlapSRTMap();
            claims.getTechPromotionId();
            claims.dealerCustomer=true;
            claims.partsUSD=1.0;
            claims.partstotalUSd=2.0;
           
           
            
            List<CSS_Claim_Submission__c> claimlst = new List<CSS_Claim_Submission__c>();
            CSS_Claim_Submission__c obj = new CSS_Claim_Submission__c();
            obj.CSS_Claims__c = claim.id;
            obj.Status__c = 'Submitted';
            insert obj;
            claimlst.add(obj);
            
          
            claims.SubmitClaim();        
            claims.ReopenClaim();
            claims.redirectToCC();
            claims.nvClaimsIntake();
            claims.pgSave();
            
            test.stopTest();
            //Wrapper Values
            List<Cg_Cl_Claimsvs.fieldActionSRTsWrapperClass> lstfieldwrap = new List<Cg_Cl_Claimsvs.fieldActionSRTsWrapperClass>();
            Cg_Cl_Claimsvs.fieldActionSRTsWrapperClass fieldwrap = new Cg_Cl_Claimsvs.fieldActionSRTsWrapperClass('THAC','fan','00-201-00','Descr','accesscode','2.0','2','percentReq','claimedHours','validationmessage','Justification','OutOfChasis','OverlapHrs','Offiste','SRTType', 'odmstatus','SRTgroupnum', 'Procedureno','Stepnumber','SRTLaborRate','ExtendedAmount','ServiceModelName','AdjustmentReason','SRTAmount','ExcludeOvrlpFlg',true);
            lstfieldwrap.add(fieldwrap);
            
            Cg_Cl_Claimsvs.SRTsWrapperClass srtwrap = new Cg_Cl_Claimsvs.SRTsWrapperClass('failcode','srtcode','srtDesc','accesscode','srtTime','quantity','percentReq','claimedHours','validationmessage','Justification','OutOfChasis','OverlapHrs','Offiste','SRTType','odmstatus','SRTgroupnum','Procedureno','Stepnumber','SRTLaborRate','ExtendedAmount','ServiceModelName','AdjustmentReason','SRTAmount','ExcludeOvrlpFlg',true);
            List<Cg_Cl_Claimsvs.SRTsWrapperClass> lstsrtwrap = new List<Cg_Cl_Claimsvs.SRTsWrapperClass>();
            lstsrtwrap.add(srtwrap);
            
            List<Cg_Cl_Claimsvs.TTMLWrapperClass> lstttmlwrap = new List<Cg_Cl_Claimsvs.TTMLWrapperClass>();
            Cg_Cl_Claimsvs.TTMLWrapperClass ttmlwrap = new Cg_Cl_Claimsvs.TTMLWrapperClass('fail123','type cc','tech john','2222.00','88%','this is test','test','test','test','test','test','test','test','test','tech john','2222.00','88%','this is test','test','test','test','test','test','test','test','test');
            lstttmlwrap.add(ttmlwrap);
            
            List<Cg_Cl_Claimsvs.otherClaimWrapperClass> lstotherclaimwrap = new List<Cg_Cl_Claimsvs.otherClaimWrapperClass>();
            Cg_Cl_Claimsvs.otherClaimWrapperClass otherwrap = new Cg_Cl_Claimsvs.otherClaimWrapperClass ('failcode','item','quantity','amount','percentReq','validationmessage','OtherClaimableDetails','ClaimedReason','ClaimedAmount','odmstatus','OCCreditType','MiscName','MiscDescription','MiscQuantity','MiscAmount','ExpenseTtoal'); 
            lstotherclaimwrap.add(otherwrap);
            
            
            List<Cg_Cl_Claimsvs.failureWrapperClass> lstfailurewrap = new List<Cg_Cl_Claimsvs.failureWrapperClass>();
            Cg_Cl_Claimsvs.failureWrapperClass failwrap = new Cg_Cl_Claimsvs.failureWrapperClass('failcode','failureName','validationmessage','SystemCode','ComponentCode','FailMode','AccountCode','PayCode','CertificateNumber','CampaignNumber','FaultCode','WarrantyId','ApproverCode','CoverageType','CoveredLaborHours','CoveredMealsLodgingAmt','CoveredOCAmount','CoveredPartsQuantity','CoveredTowingMiles','CoveredTravelLabor','CoveredTravelMiles','DeductibleAmount','AuthorizationNum', 'CampaignLabourPrcnt','CampaignOCPrcnt','CampaignPartsPrcnt','CampaignTowingPrcnt','CampaignTravelPrcnt','odmstatus',12,'claimType',true);
            failwrap.FailureOrder='';
            failwrap.FailLocation = 'test';
            failwrap.CustomerPossession ='Yes';
            failwrap.PartsWarrantyStartDate = 'test';
            failwrap.FailureDate = 'test';
            failwrap.FailurePoint = '30';
            failwrap.FailureMeasure = 'Miles';
            failwrap.FailureOrder='';
            failwrap.PrimaryFailureFlag = true;
            lstfailurewrap.add(failwrap);
            claims.populateLeastFailureSequenceAsPrimary();
            
            List<Cg_Cl_Claimsvs.partsWrapperClass> lstpartswrap = new List<Cg_Cl_Claimsvs.partsWrapperClass>();
            Cg_Cl_Claimsvs.partsWrapperClass prtap = new Cg_Cl_Claimsvs.partsWrapperClass('failcode','SPN','partdescription','quantity','percentReq','sellprice','totalUSD','validationmessage','PartNumber','PricebookName','ReplacementReason','odmstatus','PartNumberService','ProductCodeOEM','UnitPrice','ExtendedPrice','PercentClaimed','partsType','SupersededPart','RIDNumber','TrackingNumber','PartsReturnFlag');
            lstpartswrap.add(prtap);
            
            List<Cg_Cl_Claimsvs.ComplaintCodes> lstccwrap=new List<Cg_Cl_Claimsvs.ComplaintCodes>();       
            Cg_Cl_Claimsvs.ComplaintCodes ccwrap=new Cg_Cl_Claimsvs.ComplaintCodes();
            ccwrap.ComplaintCode='';
            lstccwrap.add(ccwrap);
            
            List<Cg_Cl_Claimsvs.PromotionIds> lstpwrap=new List<Cg_Cl_Claimsvs.PromotionIds>();
            Cg_Cl_Claimsvs.PromotionIds pwrap=new Cg_Cl_Claimsvs.PromotionIds();
            pwrap.PromotionID='';
            lstpwrap.add(pwrap);
            
            List<Cg_Cl_Claimsvs.Notes> lstnoteswrap=new List<Cg_Cl_Claimsvs.Notes>();
            Cg_Cl_Claimsvs.Notes noteswrap=new Cg_Cl_Claimsvs.Notes();
            noteswrap.Note='';
            noteswrap.NoteType='';
            lstnoteswrap.add(noteswrap);      
            
            List<Cg_Cl_Claimsvs.ClaimNotes> lstclnwrap=new List<Cg_Cl_Claimsvs.ClaimNotes>();    
            Cg_Cl_Claimsvs.ClaimNotes clnwrap=new Cg_Cl_Claimsvs.ClaimNotes();   
            clnwrap.noteBody='';
            clnwrap.Notes=null;  
            clnwrap.lastSaveDate=''; 
            lstclnwrap.add(clnwrap);    
            
            
            List<CG_CL_ClaimsVS.AdditionalESNs> lstesnw=new List<CG_CL_ClaimsVS.AdditionalESNs>();
            CG_CL_ClaimsVS.AdditionalESNs esnw=new CG_CL_ClaimsVS.AdditionalESNs('EngineSerialNumber','WarrantyStartDate','BISFlag','FailureDate','FailurePoint','FailureMeasure','ProductHours','EngineVIN','ECMCalibAfter','ECMCalibBefore','RevisionBefore','ReviewAfter','ESNModel','ApplicationCode','DistanceType','Hours');
            lstesnw.add(esnw);
            
            /*Cg_Cl_Claimsvs.ClaimNotes cnwrap=new Cg_Cl_Claimsvs.ClaimNotes();
cnwrap.lastSaveDate='';*/
            list<Cg_Cl_Claimsvs.claimWrapperClass> clwrlist=new list<Cg_Cl_Claimsvs.claimWrapperClass>();
            Cg_Cl_Claimsvs.claimWrapperClass claimswrap1 = new Cg_Cl_Claimsvs.claimWrapperClass();
            claimswrap1.accountcode  = 'Test';
            claimswrap1.claimid  = 'Test';
            claimswrap1.ServiceProviderCode  = 'Test';
            claimswrap1.DistributorCode  = 'Test';
            claimswrap1.EngineSerialNumber  = 'Test';
            claimswrap1.RONumber  = 'Test';
            claimswrap1.WarrantyStartDate  = 'Test';
            claimswrap1.EngineApplicationCode  = 'Test';
            claimswrap1.Manufacturer  = 'Test';
            claimswrap1.ModelSeries  = 'Test';
            claimswrap1.FirstName  = 'Test';
            claimswrap1.LastName  = 'Test';
            claimswrap1.BISFlag  = 'Test';
            claimswrap1.MultiESNFlg  = 'Test';
            claimswrap1.CampaignNumber  = 'Test';
            claimswrap1.InfoOnlyFlag  = 'Test';
            claimswrap1.NewPartsWarrantyFlg  = 'Test';
            claimswrap1.ReConPartsWarrantyFlg  = 'Test';
            claimswrap1.RoadRelayWarrantyFlg  = 'Test';
            claimswrap1.FailureDate  = 'Test';
            claimswrap1.FailurePoint  = 'Test';
            claimswrap1.FailureMeasure  = 'Test';
            claimswrap1.MissionDisablingFlag  = 'Test';
            claimswrap1.CatastrophicFlag  = 'Test';
            claimswrap1.RepairDescription  = 'Test';
            claimswrap1.ReplacementPart  = 'Test';
            claimswrap1.SPCertifiedFlag  = 'Test';
            claimswrap1.WarrantyTrainedFlag  = 'Test';
            claimswrap1.CustomerPossession  = 'Test';
            claimswrap1.DISDNumber  = 'Test';
            claimswrap1.CustomerName  = 'Test';
            claimswrap1.ECMCalibAfter  = 'Test';
            claimswrap1.ReviewAfter  = 'Test';
            claimswrap1.ECMCalibBefore  = 'Test';
            claimswrap1.RevisionBefore  = 'Test';
            claimswrap1.Justification  = 'Test';
            claimswrap1.EngineVIN  = 'Test';
            claimswrap1.ESNCount  = 'Test';
            claimswrap1.TSRNumber  = 'Test';
            claimswrap1.UnitNumber  = 'Test';
            claimswrap1.PaccarFlag  = 'Test';
            claimswrap1.PenaltyFlag  = 'Test';
            claimswrap1.SRTPenaltyPercentage  = 'Test';
            claimswrap1.manualAdjudicationFlag  = 'Test';
            claimswrap1.DealerClaimNumber  = 'Test';
            claimswrap1.ClaimSource  = 'Test';
            claimswrap1.ClaimFiledDate  = 'Test';
            claimswrap1.SPInShopLaborRate  = 'Test';
            claimswrap1.SPLaborRate  = 'Test';
            claimswrap1.SPTravelRate  = 'Test';
            claimswrap1.Contact  = 'Test';
            claimswrap1.SRTTime = 'Test';
            claimswrap1.FASRTTime = 'Test';
            claimswrap1.status  = 'Test';
            claimswrap1.BranchCode  = 'Test';
            claimswrap1.ClaimType  = 'Test';
            claimswrap1.ClaimDate  = 'Test';
            claimswrap1.Owned  = 'Test';
            claimswrap1.SiebelClaimNumber  = 'Test';
            claimswrap1.GuidanzClaimNumber  = 'Test';
            claimswrap1.CSSJobID  = 'Test';
            claimswrap1.BMSReferenceNumber  = 'Test';
            claimswrap1.DealerCode  = 'Test';
            claimswrap1.CustomerCode  = 'Test';
            claimswrap1.PayCode  = 'Test';
            claimswrap1.AuthorizationNumber  = 'Test';
            claimswrap1.ApprovalCode  = 'Test';
            claimswrap1.PolicyRequestNumber  = 'Test';
            claimswrap1.FailureLocation  = 'Test';
            claimswrap1.CreateUser  = 'Test';
            claimswrap1.Severity  = 'Test';
            claimswrap1.SMN  = 'Test';
            claimswrap1.EngineFamily  = 'Test';
            claimswrap1.Make  = 'Test';
            claimswrap1.Model  = 'Test';
            claimswrap1.EquipmentConfiguration  = 'Test';
            claimswrap1.DistanceType  = 'Test';
            claimswrap1.Hours  = 'Test';
            claimswrap1.DealerApproval  = 'Test';
            claimswrap1.DistributorAuthorization  = 'Test';
            claimswrap1.MaterialDisposition  = 'Test';
            claimswrap1.TotalPartsAmount  = 'Test';
            claimswrap1.TotalLaborAmount  = 'Test';
            claimswrap1.TotalTravelAmount  = 'Test';
            claimswrap1.TotalOtherAmount  = 'Test';
            claimswrap1.PMU  = 'Test';
            claimswrap1.BFC  = 'Test';
            claimswrap1.Tax  = 'Test';
            claimswrap1.TotalClaimAmount  = 'Test';
            claimswrap1.Reference1  = 'Test';
            claimswrap1.Reference2  = 'Test';
            claimswrap1.showEditLink = true;
            claimswrap1.Reference3  = 'Test';
            claimswrap1.TechnicianQualifiedFlag  = 'Test';
            //claimswrap1.SRTsWrapper = lstsrtwrap; 
            claimswrap1.TTMLWrapper = lstttmlwrap;
            claimswrap1.otherClaimWrapper = lstotherclaimwrap;
            claimswrap1.partsWrapper = lstpartswrap; 
            claimswrap1.failureWrapper = lstfailurewrap;  
            claimswrap1.ListOfComplaintCodes = lstccwrap;
            claimswrap1.ListOfPromotionIds = lstpwrap;
            claimswrap1.ListOfNotes = lstnoteswrap;
            //claimswrap1.fieldActionSRTsWrapper = lstfieldwrap;  
            claimswrap1.ListOfAdditionalESNs = lstesnw;
            claimswrap1.claimSubNotes = lstclnwrap;      
            clwrlist.add(claimswrap1);
            
            //claims.prepareBMSRequest();
            //claims.verifySubmitpgAction();
            claims.prepareSiebelRequest();
            claims.generateClaimSubmissionRecords();
            claims.saveClaimsVS();
            //STOP TEST
        } 
    }
    
    public static testmethod void testforverifySubmitpgAction(){
        
        user u = css_testdata.createTestUser(false);
        u.Username='TestUser.ra@cummins.com';
        u.Email='TestUser.ra@cummins.com';
        u.User_Location__c='56354-53426';
        insert u;
        
        system.runAs(u)
        {
            Group Q = new Group();
            Q.Type = 'Queue';
            //Q.OwnerId=objUser1.id;
            Q.Name = 'CQ'+'-'+'56354-53426';
            insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=Q.Id);
            insert q1;
            
            Account acc = new Account();
            acc.name='Rtest123';
            acc.CSS_DistributorCode__c='03742';  
            acc.Type='Dealer Account';
            acc.IAM_Service_Provider_Code__c = '03741';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            css_job_order__c jo = new css_job_order__c();
            jo.Customer_Name__c='TestUser';
            jo.Customer_Code__c='123';
            jo.ESN__c='53467987';
            insert jo;
            
            css_claims__c claims1= new css_claims__C();
            claims1.Customer_Code__c='123';
            claims1.Customer_Name__c='TestUser';
            claims1.Account__c = acc.id;
            claims1.CSS_Job__c=jo.Id;
            claims1.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "100000", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "EMS-Emissions Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
            claims1.Status__c='Draft';
            claims1.Location_Code__c='56354-53426';
            claims1.ownerId=u.id;
            insert claims1; 
            
            date d1 = date.parse('10/10/17');
            css_claims__c claims2=[select id,Status__c,createddate from css_claims__c limit 1];
            test.setCreatedDate(claims2.Id, d1);
            system.debug('Created Date'+claims2.createddate);
            
            css_claims__c claims3=[select id,Status__c,createddate from css_claims__c limit 1];
            system.debug('Created Date'+claims3.createddate);   
            
            css_psn__c psn1 = new css_psn__c();
            psn1.CSS_Claims__c=claims1.Id;
            psn1.PSN__c='53467987';
            psn1.Primary__c=true;
            insert psn1;
            
            css_solutions__c sol = new css_solutions__c();
            sol.Service_Job__c=jo.Id;
            //sol.FSL_Service_Job__c=jo.id;
            insert sol;
            
            css_solution_Component__c solcomp = new css_solution_component__c();
            solcomp.Name='Testing';
            solcomp.AccountCodeEdit__c='SERVICE TOOL WARRANTY 52';
            solcomp.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp.Selected_Component__c=true;
            solcomp.System_Code__c='WE';
            solcomp.Component_Code__c='QP';
            solcomp.Failure_Mode__c='EZ';
            solcomp.CSS_Claims__c=claims1.id;
            solcomp.Part_Warranty_Start_Date__c = system.today();
            solcomp.Solutions__c=sol.Id;
            solcomp.Service_Job__c=jo.Id;
            solcomp.Type__c='Campaign';
            solcomp.Claim_Type__c = 'Select One';
            solcomp.Selected_Claim_Type__c = 'Ridhima';
            solcomp.Status__c='Approved';
            solcomp.Complete_Indicator__c=true;
            solcomp.Multiple_Times__c=true;
            insert solcomp;
            
            css_solution_Component__c solcomp1 = new css_solution_component__c();
            solcomp1.Name='Testing';
            solcomp1.AccountCodeEdit__c='SERVICE TOOL WARRANTY 52';
            solcomp1.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp1.Selected_Component__c=true;
            solcomp1.System_Code__c='WE';
            solcomp1.Component_Code__c='QP';
            solcomp1.Failure_Mode__c='EZ';
            solcomp1.CSS_Claims__c=claims1.id;
            solcomp1.Solutions__c=sol.Id;
            solcomp1.Service_Job__c=jo.Id;
            solcomp1.Type__c='TRP';
            solcomp1.Status__c='Approved';
            solcomp1.Complete_Indicator__c=true;
            solcomp1.Multiple_Times__c=true;
            insert solcomp1;
            
            css_solution_Component__c solcomp2 = new css_solution_component__c();
            solcomp2.Name='Testing';
            solcomp2.AccountCodeEdit__c='SERVICE TOOL WARRANTY 52';
            solcomp2.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp2.Selected_Component__c=true;
            solcomp2.System_Code__c='WE';
            solcomp2.Component_Code__c='QP';
            solcomp2.Failure_Mode__c='EZ';
            solcomp2.CSS_Claims__c=claims1.id;
            solcomp2.Solutions__c=sol.Id;
            solcomp2.Service_Job__c=jo.Id;
            solcomp2.Type__c='ATC';
            solcomp2.Status__c='Approved';
            solcomp2.Complete_Indicator__c=true;
            solcomp2.Multiple_Times__c=true;
            insert solcomp2;
            
            CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
            solcomp3.Name = 'solcomp3';
            solcomp3.CSS_Claims__c=claims1.id;
            solcomp3.Solutions__c=sol.Id;
            solcomp3.Service_Job__c=jo.Id;
            solcomp3.System_Code__c='FH';
            solcomp3.Component_Code__c='AS';
            solcomp3.Failure_Mode__c='BT';
            solcomp3.AccountCode__c = 'SERVICE TOOL WARRANTY 52';
            solcomp3.Type__c = 'Campaign';
            solcomp3.Selected_Component__c = true;
            solcomp3.Status__c='Approved';
            solcomp3.CoverageLimitExceedMsg_Status__c = 'ERROR';
            solcomp3.CoverageTravelBaseFareMsgTstatus__c = 'ERROR';
            solcomp3.AccountCode_Call_Status__c = 'Failure';
            solcomp3.CoverageLimitExceedMsgSRT_Status__c ='ERROR';
            insert solcomp3;    
            
            RecordType rtbms = [SELECT id,Name 
                                FROM RecordType 
                                WHERE name='BMS Parts'];
            
            RecordType rtp = [SELECT id,Name 
                              FROM RecordType 
                              WHERE name='Parts']; 
            
            RecordType rtOC = [SELECT id,Name 
                               FROM RecordType 
                               WHERE name='OtherClaimables'];                    
            
            RecordType rtTTML = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE name='TTML'];
            
            CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
            partop.CSS_Claims__c=claims1.id;
            partop.FailurepartId__c=solcomp.Id;
            partop.selected_part__c=true;
            partop.Fail_Code__c='WEQPEZ';
            partop.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop.Quantity__c= 0;
            partop.Unit_Price__c = '10';
            partop.recordtypeid = rtbms.id;
            partop.Covered__c = 100;
            insert partop;
            
            CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
            partop1.CSS_Claims__c=claims1.id;
            partop1.FailurepartId__c=solcomp1.Id;
            partop1.selected_part__c=true;
            partop1.Fail_Code__c='WEQPEZ';
            partop1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop1.Quantity__c=null;
            partop1.BMS_Quantity__c=1.0;
            partop1.Covered__c=10.87;
            partop1.recordtypeid = rtp.id;
            insert partop1;
            
            CSS_Parts_Options__c partop2 = new CSS_Parts_Options__c();
            partop2.CSS_Claims__c=claims1.id;
            partop2.FailurepartId__c=solcomp2.Id;
            partop2.selected_part__c=true;
            partop2.Fail_Code__c='WEQPEZ';
            partop2.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop2.recordtypeid = rtOC.id;
            partop2.Quantity__c=2.0;
            partop2.BMS_Quantity__c=1.0;
            insert partop2;
            
            CSS_Parts_Options__c partop3 = new CSS_Parts_Options__c();
            partop3.CSS_Claims__c=claims1.id;
            partop3.FailurepartId__c=solcomp2.Id;
            partop3.selected_part__c=true;
            partop3.Fail_Code__c='WEQPEZ';
            partop3.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop3.recordtypeid = rtTTML.id;
            partop3.Quantity__c=2.0;
            partop3.BMS_Quantity__c=1.0;
            insert partop3;        
            
            list<CSS_SRT__c> lstSRT = new  list<CSS_SRT__c>();
            CSS_SRT__c srt1 = new CSS_SRT__c();
            srt1.FailCode__c='WEQPEZ';
            srt1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            srt1.SRT_AccessiblityCheck__c=TRUE;
            srt1.CSS_Claims__c=claims1.Id;
            srt1.Type__c='Field Action';
            insert srt1;
            lstSRT.add(srt1);
            CSS_SRT__c srt11 = new CSS_SRT__c();
            srt11.FailCode__c='WEQPEZ';
            srt11.Account_Code__c='SERVICE TOOL WARRANTY 52';
            srt11.SRT_AccessiblityCheck__c=TRUE;
            srt11.CSS_Claims__c=claims1.Id;
            srt11.Type__c='99Time';
            insert srt11;
            lstSRT.add(srt11);
            
            PageReference pageRef = Page.CG_ClaimsVS;
            pageRef.getParameters().put('id', claims1.id);
            Test.setCurrentPage(pageRef); 
            user u1=new user();
            
            list<Note> ClaimNotesList=new list<Note>();  
            note not1 = new note();
            not1.Body='Testing';
            not1.ParentId=claims1.Id;
            not1.Title='Claims';
            insert not1;
            ClaimNotesList.add(not1);
            
            CSS_JobEventTemporary__c  jobevt = new CSS_JobEventTemporary__c ();
            jobevt.Reason__c='{"DataArea":{"Details":[{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LOSS - OVERFLOW","BusinessUnit":"EBU","ComplaintCode":"106","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"117","ActiveFlag":"Y"},{"Category":"Leak","Description":"EXHAUST LEAK","BusinessUnit":"EBU","ComplaintCode":"118","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SHUTS DOWN OR STALLS","BusinessUnit":"EBU","ComplaintCode":"205","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SURGES","BusinessUnit":"EBU","ComplaintCode":"212","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"LOW POWER","BusinessUnit":"EBU","ComplaintCode":"213","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"VIBRATION","BusinessUnit":"EBU","ComplaintCode":"401","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"INOPERATIVE COMPONENT","BusinessUnit":"EBU","ComplaintCode":"404","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE RUNS ROUGH","BusinessUnit":"EBU","ComplaintCode":"215","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"115","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"116","ActiveFlag":"Y"},{"Category":"Leak","Description":"COMPRESSION LEAK","BusinessUnit":"EBU","ComplaintCode":"120","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - RED","BusinessUnit":"EBU","ComplaintCode":"202","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE WILL NOT SHUT DOWN","BusinessUnit":"EBU","ComplaintCode":"211","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"CRUISE CONTROL","BusinessUnit":"EBU","ComplaintCode":"503","ActiveFlag":"Y"},{"Category":"Other","Description":"INSPECTION","BusinessUnit":"EBU","ComplaintCode":"603","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN AIR SYSTEM","BusinessUnit":"EBU","ComplaintCode":"121","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO NOISE","BusinessUnit":"EBU","ComplaintCode":"123","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL OUT EXHAUST","BusinessUnit":"EBU","ComplaintCode":"124","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL IN INTAKE","BusinessUnit":"EBU","ComplaintCode":"125","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - YELLOW","BusinessUnit":"EBU","ComplaintCode":"201","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT REACH RPM","BusinessUnit":"EBU","ComplaintCode":"206","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED HIGH","BusinessUnit":"EBU","ComplaintCode":"208","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"POOR THROTTLE RESPONSE","BusinessUnit":"EBU","ComplaintCode":"214","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HIGH BLOW-BY","BusinessUnit":"EBU","ComplaintCode":"408","ActiveFlag":"Y"},{"Category":"Other","Description":"REBUILD","BusinessUnit":"EBU","ComplaintCode":"602","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT COMPLETE","BusinessUnit":"EBU","ComplaintCode":"606","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"101","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT BUILD AIR OR BUILDS SLOWLY","BusinessUnit":"EBU","ComplaintCode":"122","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ROUGH IDLE","BusinessUnit":"EBU","ComplaintCode":"209","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLACK SMOKE","BusinessUnit":"EBU","ComplaintCode":"302","ActiveFlag":"Y"},{"Category":"Other","Description":"VOLTAGE (GENSET)","BusinessUnit":"EBU","ComplaintCode":"505","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"STARTER MOTOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"508","ActiveFlag":"Y"},{"Category":"Other","Description":"CAMPAIGN / TRP","BusinessUnit":"EBU","ComplaintCode":"601","ActiveFlag":"Y"},{"Category":"Other","Description":"FAILED EMISSION TEST","BusinessUnit":"EBU","ComplaintCode":"604","ActiveFlag":"Y"},{"Category":"Other","Description":"MAINTENANCE","BusinessUnit":"EBU","ComplaintCode":"605","ActiveFlag":"Y"},{"Category":"Other","Description":"TELEMATICS","BusinessUnit":"EBU","ComplaintCode":"990","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HARD START","BusinessUnit":"EBU","ComplaintCode":"203","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"204","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE MISFIRE","BusinessUnit":"EBU","ComplaintCode":"210","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ENGINE BRAKE MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"406","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BLOWING DIPSTCK OUT","BusinessUnit":"EBU","ComplaintCode":"407","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - NOT IN OIL","BusinessUnit":"EBU","ComplaintCode":"102","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"107","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"109","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE HIGH","BusinessUnit":"EBU","ComplaintCode":"112","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"113","ActiveFlag":"Y"},{"Category":"Leak","Description":"DEF LEAK","BusinessUnit":"EBU","ComplaintCode":"609","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED LOW","BusinessUnit":"EBU","ComplaintCode":"207","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WHITE SMOKE","BusinessUnit":"EBU","ComplaintCode":"301","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"NOISE IN ENGINE","BusinessUnit":"EBU","ComplaintCode":"402","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT CARRY LOAD (GENSET)","BusinessUnit":"EBU","ComplaintCode":"504","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN TOO FREQUENT","BusinessUnit":"EBU","ComplaintCode":"608","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"103","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"108","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"114","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLUE SMOKE","BusinessUnit":"EBU","ComplaintCode":"303","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE OVERSPEED","BusinessUnit":"EBU","ComplaintCode":"409","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BELT PROBLEM","BusinessUnit":"EBU","ComplaintCode":"410","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ALTERNATOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"507","ActiveFlag":"Y"},{"Category":"Other","Description":"OTHER - SEE TEXT FOR DESCRIPTION","BusinessUnit":"EBU","ComplaintCode":"999","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"607","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"104","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"105","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"110","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE LOW","BusinessUnit":"EBU","ComplaintCode":"111","ActiveFlag":"Y"},{"Category":"Leak","Description":"AIR LEAK","BusinessUnit":"EBU","ComplaintCode":"119","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"NOISY COMPONENT","BusinessUnit":"EBU","ComplaintCode":"403","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"LOOSE OR BROKEN MOUNTING HARDWARE","BusinessUnit":"EBU","ComplaintCode":"405","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BREAKER TRIPPING","BusinessUnit":"EBU","ComplaintCode":"506","ActiveFlag":"Y"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
            jobevt.Attribute1__c='CategoryComplaintCodes';
            insert jobevt;
            Map<String,List<CSS_SRT__c>> overlapSRTListMap = new Map<String,List<CSS_SRT__c>>();
            overlapSRTListMap.put(srt11.id,lstSRT);
            
            apexpages.currentPage().getparameters().put('id',claims1.Id);
            
            
            
            
            CG_CL_ClaimsVS vs = new CG_CL_ClaimsVS();
            vs.exchangeRate=1.33;
            //vs.userType  = 'DLR';
            vs.overlapSRTListMap=overlapSRTListMap;
            vs.verifySubmitpgAction();
            vs.prepareSiebelRequest();
            vs.prepareBMSRequest();
            vs.checkQuantity();
            
            List<Cg_Cl_Claimsvs.SRTsWrapperClass> lstsrtwrap = new List<Cg_Cl_Claimsvs.SRTsWrapperClass>();
            Cg_Cl_Claimsvs.SRTsWrapperClass srtwrap = new Cg_Cl_Claimsvs.SRTsWrapperClass('failcode','srtcode','srtDesc','accesscode','srtTime','quantity','percentReq','claimedHours','validationmessage','Justification','OutOfChasis','OverlapHrs','Offiste','SRTType','odmstatus','SRTgroupnum','Procedureno','Stepnumber','SRTLaborRate','ExtendedAmount','ServiceModelName','AdjustmentReason','SRTAmount','ExcludeOvrlpFlg',true);
            srtwrap.srtcode = '99-999';
            lstsrtwrap.add(srtwrap);
            
            
        }
    }
    public static testmethod void testforverifySubmitpgAction1(){
        
        user u = css_testdata.createTestUser(false);
        u.Username='TestUser.ra@cummins.com';
        u.Email='TestUser.ra@cummins.com';
        u.User_Location__c='56354-53426';
        insert u;
        
        system.runAs(u)
        {
            Group Q = new Group();
            Q.Type = 'Queue';
            //Q.OwnerId=objUser1.id;
            Q.Name = 'CQ'+'-'+'56354-53426';
            insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=Q.Id);
            insert q1;
            
            Account acc = new Account();
            acc.name='Rtest123';
            acc.CSS_DistributorCode__c='03742';  
            acc.Type='Dealer Account';
            acc.IAM_Service_Provider_Code__c = '03741';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            
            css_job_order__c jo = new css_job_order__c();
            jo.Customer_Name__c='TestUser';
            jo.Customer_Code__c='123';
            jo.ESN__c='53467987';
            insert jo;
            
            css_claims__c claims1= new css_claims__C();
            claims1.Customer_Code__c='123';
            claims1.Customer_Name__c='TestUser';
            claims1.Account__c = acc.id;
            //claims1.CSS_Job__c=jo.Id;
            claims1.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "100000", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "EMS-Emissions Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
            claims1.Status__c='Submitted';
            claims1.Location_Code__c='56354-53426';
            claims1.ownerId=u.id;
            insert claims1; 
            
            date d1 = date.parse('10/10/17');
            css_claims__c claims2=[select id,Status__c,createddate from css_claims__c limit 1];
            test.setCreatedDate(claims2.Id, d1);
            system.debug('Created Date'+claims2.createddate);
            
            css_claims__c claims3=[select id,Status__c,createddate from css_claims__c limit 1];
            system.debug('Created Date'+claims3.createddate);   
            
            css_psn__c psn1 = new css_psn__c();
            psn1.CSS_Claims__c=claims1.Id;
            psn1.PSN__c='53467987';
            psn1.License_Plate_State__c = 'AB-Alberta';
            psn1.Before_In_Service__c = true;
            psn1.Primary__c=true;
            insert psn1;
            css_solutions__c sol = new css_solutions__c();
            sol.Service_Job__c=jo.Id;
            //sol.FSL_Service_Job__c=jo.id;
            //sol.FaultCode__c = solcomp.id;
            insert sol;
            
            
            
            css_solution_Component__c solcomp = new css_solution_component__c();
            solcomp.Name='Testing';
            solcomp.AccountCodeEdit__c='SERVICE TOOL WARRANTY 52';
            solcomp.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp.Selected_Component__c=true;
            solcomp.System_Code__c='WE';
            solcomp.Component_Code__c='QP';
            solcomp.Failure_Mode__c='EZ';
            solcomp.CSS_Claims__c=claims1.id;
            // 7solcomp.Solutions__c=sol.Id;
            solcomp.Service_Job__c=jo.Id;
            solcomp.Type__c='Campaign';
            solcomp.Status__c='Approved';
            solcomp.Complete_Indicator__c=true;
            solcomp.Multiple_Times__c=true;
            insert solcomp;
            
            
            
            css_solution_Component__c solcomp1 = new css_solution_component__c();
            solcomp1.Name='Testing';
            solcomp1.AccountCodeEdit__c='SERVICE TOOL WARRANTY 52';
            solcomp1.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp1.Selected_Component__c=true;
            solcomp1.System_Code__c='WE';
            solcomp1.Component_Code__c='QP';
            solcomp1.Failure_Mode__c='EZ';
            solcomp1.CSS_Claims__c=claims1.id;
            solcomp1.Solutions__c=sol.Id;
            solcomp1.Service_Job__c=jo.Id;
            solcomp1.Type__c='TRP';
            solcomp1.Status__c='Approved';
            solcomp1.Complete_Indicator__c=true;
            solcomp1.Multiple_Times__c=true;
            insert solcomp1;
            
            css_solution_Component__c solcomp2 = new css_solution_component__c();
            solcomp2.Name='Testing';
            solcomp2.AccountCodeEdit__c='SERVICE TOOL WARRANTY 52';
            solcomp2.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp2.Selected_Component__c=true;
            solcomp2.System_Code__c='WE';
            solcomp2.Component_Code__c='QP';
            solcomp2.Failure_Mode__c='EZ';
            solcomp2.CSS_Claims__c=claims1.id;
            solcomp2.Solutions__c=sol.Id;
            solcomp2.Service_Job__c=jo.Id;
            solcomp2.Type__c='ATC';
            solcomp2.Status__c='Approved';
            solcomp2.Complete_Indicator__c=true;
            solcomp2.Multiple_Times__c=true;
            insert solcomp2;
            
            CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
            solcomp3.Name = 'solcomp3';
            solcomp3.CSS_Claims__c=claims1.id;
            solcomp3.Solutions__c=sol.Id;
            solcomp3.Service_Job__c=jo.Id;
            solcomp3.System_Code__c='FH';
            solcomp3.Component_Code__c='AS';
            solcomp3.Failure_Mode__c='BT';
            solcomp3.AccountCode__c = 'SERVICE TOOL WARRANTY 52';
            solcomp3.Type__c = 'Campaign';
            solcomp3.Selected_Component__c = true;
            solcomp3.Status__c='Approved';
            solcomp3.CoverageLimitExceedMsg_Status__c = 'ERROR';
            solcomp3.CoverageTravelBaseFareMsgTstatus__c = 'ERROR';
            solcomp3.AccountCode_Call_Status__c = 'Failure';
            solcomp3.CoverageLimitExceedMsgSRT_Status__c ='ERROR';
            insert solcomp3;    
            
            RecordType rtbms = [SELECT id,Name 
                                FROM RecordType 
                                WHERE name='BMS Parts'];
            
            RecordType rtp = [SELECT id,Name 
                              FROM RecordType 
                              WHERE name='Parts']; 
            
            RecordType rtOC = [SELECT id,Name 
                               FROM RecordType 
                               WHERE name='OtherClaimables'];                    
            
            RecordType rtTTML = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE name='TTML'];
            
            CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
            partop.CSS_Claims__c=claims1.id;
            partop.FailurepartId__c=solcomp.Id;
            partop.selected_part__c=true;
            partop.Fail_Code__c='WEQ-PEZ';
            partop.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop.Quantity__c= 0;
            partop.Unit_Price__c = '10';
            partop.recordtypeid = rtbms.id;
            partop.Covered__c = 100;
            insert partop;
            
            CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
            partop1.CSS_Claims__c=claims1.id;
            partop1.FailurepartId__c=solcomp1.Id;
            partop1.selected_part__c=true;
            partop1.Fail_Code__c='WEQPEZ';
            partop1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop1.Quantity__c=null;
            partop1.BMS_Quantity__c=1.0;
            partop1.Covered__c=10.87;
            partop1.recordtypeid = rtp.id;
            insert partop1;
            
            CSS_Parts_Options__c partop2 = new CSS_Parts_Options__c();
            partop2.CSS_Claims__c=claims1.id;
            partop2.FailurepartId__c=solcomp2.Id;
            partop2.selected_part__c=true;
            partop2.Fail_Code__c='WEQPEZ';
            partop2.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop2.recordtypeid = rtOC.id;
            partop2.Quantity__c=2.0;
            partop2.BMS_Quantity__c=1.0;
            insert partop2;
            
            CSS_Parts_Options__c partop3 = new CSS_Parts_Options__c();
            partop3.CSS_Claims__c=claims1.id;
            partop3.FailurepartId__c=solcomp2.Id;
            partop3.selected_part__c=true;
            partop3.Fail_Code__c='WEQPEZ';
            partop3.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop3.recordtypeid = rtTTML.id;
            partop3.Quantity__c=2.0;
            partop3.BMS_Quantity__c=1.0;
            insert partop3;        
            
            list<CSS_SRT__c> lstSRT = new  list<CSS_SRT__c>();
            
            CSS_SRT__c srt11 = new CSS_SRT__c();
            srt11.FailCode__c='WEQPEZ';
            srt11.Account_Code__c='SERVICE TOOL WARRANTY 52';
            srt11.SRT_AccessiblityCheck__c=TRUE;
            srt11.CSS_Claims__c=claims1.Id;
            //  srt11.SRT_ID__c = 'abcd';
            srt11.Type__c='Diagnosis';
            lstSRT.add(srt11);
            CSS_SRT__c srt12 = new CSS_SRT__c();
            srt12.FailCode__c='WEQPEZ';
            srt12.Account_Code__c='SERVICE TOOL WARRANTY 52';
            srt12.SRT_AccessiblityCheck__c=TRUE;
            srt12.CSS_Claims__c=claims1.Id;
            //  srt11.SRT_ID__c = 'abcd';
            srt12.Type__c='Repair';
            lstSRT.add(srt12);
            CSS_SRT__c srt13 = new CSS_SRT__c();
            srt13.FailCode__c='WEQPEZ';
            srt13.Account_Code__c='SERVICE TOOL WARRANTY 52';
            srt13.SRT_AccessiblityCheck__c=TRUE;
            srt13.CSS_Claims__c=claims1.Id;
            //  srt11.SRT_ID__c = 'abcd';
            srt13.Type__c='Diag Access';
            lstSRT.add(srt13);
            CSS_SRT__c srt14 = new CSS_SRT__c();
            srt14.FailCode__c='WEQPEZ';
            srt14.Account_Code__c='SERVICE TOOL WARRANTY 52';
            srt14.SRT_AccessiblityCheck__c=TRUE;
            srt14.CSS_Claims__c=claims1.Id;
            //  srt11.SRT_ID__c = 'abcd';
            srt14.Type__c='Admin';
            lstSRT.add(srt14);
            insert lstSRT;
            //Map<String,List<CSS_SRT__C>> m = new Map<String,List<CSS_SRT__C>>();
            //m.put('abcd', lstSRT);
            //Map<String,List<CSS_SRT__C>> m1 = new Map<String,List<CSS_SRT__C>>();
            //m.put('SERVICE TOOL WARRANTY 52-WEQPEZ', lstSRT);
            PageReference pageRef = Page.CG_ClaimsVS;
            pageRef.getParameters().put('id', claims1.id);
            Test.setCurrentPage(pageRef); 
            user u1=new user();
            
            list<Note> ClaimNotesList=new list<Note>();  
            note not1 = new note();
            not1.Body='Testing';
            not1.ParentId=claims1.Id;
            not1.Title='Claims';
            insert not1;
            ClaimNotesList.add(not1);
            
            CSS_JobEventTemporary__c  jobevt = new CSS_JobEventTemporary__c ();
            jobevt.Reason__c='{"DataArea":{"Details":[{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LOSS - OVERFLOW","BusinessUnit":"EBU","ComplaintCode":"106","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"117","ActiveFlag":"Y"},{"Category":"Leak","Description":"EXHAUST LEAK","BusinessUnit":"EBU","ComplaintCode":"118","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SHUTS DOWN OR STALLS","BusinessUnit":"EBU","ComplaintCode":"205","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SURGES","BusinessUnit":"EBU","ComplaintCode":"212","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"LOW POWER","BusinessUnit":"EBU","ComplaintCode":"213","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"VIBRATION","BusinessUnit":"EBU","ComplaintCode":"401","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"INOPERATIVE COMPONENT","BusinessUnit":"EBU","ComplaintCode":"404","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE RUNS ROUGH","BusinessUnit":"EBU","ComplaintCode":"215","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"115","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"116","ActiveFlag":"Y"},{"Category":"Leak","Description":"COMPRESSION LEAK","BusinessUnit":"EBU","ComplaintCode":"120","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - RED","BusinessUnit":"EBU","ComplaintCode":"202","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE WILL NOT SHUT DOWN","BusinessUnit":"EBU","ComplaintCode":"211","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"CRUISE CONTROL","BusinessUnit":"EBU","ComplaintCode":"503","ActiveFlag":"Y"},{"Category":"Other","Description":"INSPECTION","BusinessUnit":"EBU","ComplaintCode":"603","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN AIR SYSTEM","BusinessUnit":"EBU","ComplaintCode":"121","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO NOISE","BusinessUnit":"EBU","ComplaintCode":"123","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL OUT EXHAUST","BusinessUnit":"EBU","ComplaintCode":"124","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL IN INTAKE","BusinessUnit":"EBU","ComplaintCode":"125","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - YELLOW","BusinessUnit":"EBU","ComplaintCode":"201","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT REACH RPM","BusinessUnit":"EBU","ComplaintCode":"206","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED HIGH","BusinessUnit":"EBU","ComplaintCode":"208","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"POOR THROTTLE RESPONSE","BusinessUnit":"EBU","ComplaintCode":"214","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HIGH BLOW-BY","BusinessUnit":"EBU","ComplaintCode":"408","ActiveFlag":"Y"},{"Category":"Other","Description":"REBUILD","BusinessUnit":"EBU","ComplaintCode":"602","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT COMPLETE","BusinessUnit":"EBU","ComplaintCode":"606","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"101","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT BUILD AIR OR BUILDS SLOWLY","BusinessUnit":"EBU","ComplaintCode":"122","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ROUGH IDLE","BusinessUnit":"EBU","ComplaintCode":"209","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLACK SMOKE","BusinessUnit":"EBU","ComplaintCode":"302","ActiveFlag":"Y"},{"Category":"Other","Description":"VOLTAGE (GENSET)","BusinessUnit":"EBU","ComplaintCode":"505","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"STARTER MOTOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"508","ActiveFlag":"Y"},{"Category":"Other","Description":"CAMPAIGN / TRP","BusinessUnit":"EBU","ComplaintCode":"601","ActiveFlag":"Y"},{"Category":"Other","Description":"FAILED EMISSION TEST","BusinessUnit":"EBU","ComplaintCode":"604","ActiveFlag":"Y"},{"Category":"Other","Description":"MAINTENANCE","BusinessUnit":"EBU","ComplaintCode":"605","ActiveFlag":"Y"},{"Category":"Other","Description":"TELEMATICS","BusinessUnit":"EBU","ComplaintCode":"990","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HARD START","BusinessUnit":"EBU","ComplaintCode":"203","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"204","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE MISFIRE","BusinessUnit":"EBU","ComplaintCode":"210","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ENGINE BRAKE MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"406","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BLOWING DIPSTCK OUT","BusinessUnit":"EBU","ComplaintCode":"407","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - NOT IN OIL","BusinessUnit":"EBU","ComplaintCode":"102","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"107","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"109","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE HIGH","BusinessUnit":"EBU","ComplaintCode":"112","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"113","ActiveFlag":"Y"},{"Category":"Leak","Description":"DEF LEAK","BusinessUnit":"EBU","ComplaintCode":"609","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED LOW","BusinessUnit":"EBU","ComplaintCode":"207","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WHITE SMOKE","BusinessUnit":"EBU","ComplaintCode":"301","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"NOISE IN ENGINE","BusinessUnit":"EBU","ComplaintCode":"402","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT CARRY LOAD (GENSET)","BusinessUnit":"EBU","ComplaintCode":"504","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN TOO FREQUENT","BusinessUnit":"EBU","ComplaintCode":"608","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"103","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"108","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"114","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLUE SMOKE","BusinessUnit":"EBU","ComplaintCode":"303","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE OVERSPEED","BusinessUnit":"EBU","ComplaintCode":"409","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BELT PROBLEM","BusinessUnit":"EBU","ComplaintCode":"410","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ALTERNATOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"507","ActiveFlag":"Y"},{"Category":"Other","Description":"OTHER - SEE TEXT FOR DESCRIPTION","BusinessUnit":"EBU","ComplaintCode":"999","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"607","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"104","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"105","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"110","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE LOW","BusinessUnit":"EBU","ComplaintCode":"111","ActiveFlag":"Y"},{"Category":"Leak","Description":"AIR LEAK","BusinessUnit":"EBU","ComplaintCode":"119","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"NOISY COMPONENT","BusinessUnit":"EBU","ComplaintCode":"403","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"LOOSE OR BROKEN MOUNTING HARDWARE","BusinessUnit":"EBU","ComplaintCode":"405","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BREAKER TRIPPING","BusinessUnit":"EBU","ComplaintCode":"506","ActiveFlag":"Y"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
            jobevt.Attribute1__c='CategoryComplaintCodes';
            insert jobevt;
            
            apexpages.currentPage().getparameters().put('id',claims1.Id);
            
            
            CG_CL_ClaimsVS vs = new CG_CL_ClaimsVS();
            vs.exchangeRate=1.33;
            vs.verifySubmitpgAction();
            List<Cg_Cl_Claimsvs.fieldActionSRTsWrapperClass> lstfieldwrap = new List<Cg_Cl_Claimsvs.fieldActionSRTsWrapperClass>();
            Cg_Cl_Claimsvs.fieldActionSRTsWrapperClass fieldwrap = new Cg_Cl_Claimsvs.fieldActionSRTsWrapperClass('THAC','fan','00-201-00','Descr','accesscode','2.0','2','percentReq','claimedHours','validationmessage','Justification','OutOfChasis','OverlapHrs','Offiste','SRTType', 'odmstatus','SRTgroupnum', 'Procedureno','Stepnumber','SRTLaborRate','ExtendedAmount','ServiceModelName','AdjustmentReason','SRTAmount','ExcludeOvrlpFlg',true);
            lstfieldwrap.add(fieldwrap);
            
            Cg_Cl_Claimsvs.SRTsWrapperClass srtwrap = new Cg_Cl_Claimsvs.SRTsWrapperClass('failcode','srtcode','srtDesc','accesscode','srtTime','quantity','percentReq','claimedHours','validationmessage','Justification','OutOfChasis','OverlapHrs','Offiste','SRTType','odmstatus','SRTgroupnum','Procedureno','Stepnumber','SRTLaborRate','ExtendedAmount','ServiceModelName','AdjustmentReason','SRTAmount','ExcludeOvrlpFlg',false);
            List<Cg_Cl_Claimsvs.SRTsWrapperClass> lstsrtwrap = new List<Cg_Cl_Claimsvs.SRTsWrapperClass>();
            lstsrtwrap.add(srtwrap);
            
            List<Cg_Cl_Claimsvs.TTMLWrapperClass> lstttmlwrap = new List<Cg_Cl_Claimsvs.TTMLWrapperClass>();
            Cg_Cl_Claimsvs.TTMLWrapperClass ttmlwrap = new Cg_Cl_Claimsvs.TTMLWrapperClass('fail123','type cc','tech john','2222.00','88%','this is test','test','test','test','test','test','test','test','test','tech john','2222.00','88%','this is test','test','test','test','test','test','test','test','test');
            lstttmlwrap.add(ttmlwrap);
            
            List<Cg_Cl_Claimsvs.otherClaimWrapperClass> lstotherclaimwrap = new List<Cg_Cl_Claimsvs.otherClaimWrapperClass>();
            Cg_Cl_Claimsvs.otherClaimWrapperClass otherwrap = new Cg_Cl_Claimsvs.otherClaimWrapperClass ('failcode','item','quantity','amount','percentReq','validationmessage','OtherClaimableDetails','ClaimedReason','ClaimedAmount','odmstatus','OCCreditType','MiscName','MiscDescription','MiscQuantity','MiscAmount','ExpenseTtoal'); 
            lstotherclaimwrap.add(otherwrap);
            
            
            List<Cg_Cl_Claimsvs.failureWrapperClass> lstfailurewrap = new List<Cg_Cl_Claimsvs.failureWrapperClass>();
            Cg_Cl_Claimsvs.failureWrapperClass failwrap = new Cg_Cl_Claimsvs.failureWrapperClass('','','','','','','','','','','','','','','','','','','','','','','','','','','','','',null,'',null);
            failwrap.FailureOrder='';
            failwrap.FailLocation = 'test';
            failwrap.CustomerPossession ='Yes';
            failwrap.PartsWarrantyStartDate = 'test';
            failwrap.FailureDate = 'test';
            failwrap.FailurePoint = '30';
            failwrap.FailureMeasure = 'Miles';
            failwrap.FailureOrder='';
            failwrap.PrimaryFailureFlag = true;
            failwrap.validationmessage = 'Validation';
            lstfailurewrap.add(failwrap);
            vs.populateLeastFailureSequenceAsPrimary();
            vs.saveClaimsVS();
            
            List<Cg_Cl_Claimsvs.partsWrapperClass> lstpartswrap = new List<Cg_Cl_Claimsvs.partsWrapperClass>();
            Cg_Cl_Claimsvs.partsWrapperClass prtap = new Cg_Cl_Claimsvs.partsWrapperClass('failcode','SPN','partdescription','quantity','percentReq','sellprice','totalUSD','validationmessage','PartNumber','PricebookName','ReplacementReason','odmstatus','PartNumberService','ProductCodeOEM','UnitPrice','ExtendedPrice','PercentClaimed','partsType','SupersededPart','RIDNumber','TrackingNumber','PartsReturnFlag');
            lstpartswrap.add(prtap);
            
            List<Cg_Cl_Claimsvs.ComplaintCodes> lstccwrap=new List<Cg_Cl_Claimsvs.ComplaintCodes>();       
            Cg_Cl_Claimsvs.ComplaintCodes ccwrap=new Cg_Cl_Claimsvs.ComplaintCodes();
            ccwrap.ComplaintCode='test';
            lstccwrap.add(ccwrap);
            
            List<Cg_Cl_Claimsvs.PromotionIds> lstpwrap=new List<Cg_Cl_Claimsvs.PromotionIds>();
            Cg_Cl_Claimsvs.PromotionIds pwrap=new Cg_Cl_Claimsvs.PromotionIds();
            pwrap.PromotionID='';
            lstpwrap.add(pwrap);
            
            List<Cg_Cl_Claimsvs.Notes> lstnoteswrap=new List<Cg_Cl_Claimsvs.Notes>();
            Cg_Cl_Claimsvs.Notes noteswrap=new Cg_Cl_Claimsvs.Notes();
            noteswrap.Note='test';
            noteswrap.NoteType='test';
            lstnoteswrap.add(noteswrap);      
            
            List<Cg_Cl_Claimsvs.ClaimNotes> lstclnwrap=new List<Cg_Cl_Claimsvs.ClaimNotes>();    
            Cg_Cl_Claimsvs.ClaimNotes clnwrap=new Cg_Cl_Claimsvs.ClaimNotes();   
            clnwrap.noteBody='';
            clnwrap.Notes=null;  
            clnwrap.lastSaveDate=''; 
            lstclnwrap.add(clnwrap);    
            
            
            List<CG_CL_ClaimsVS.AdditionalESNs> lstesnw=new List<CG_CL_ClaimsVS.AdditionalESNs>();
            CG_CL_ClaimsVS.AdditionalESNs esnw=new CG_CL_ClaimsVS.AdditionalESNs('EngineSerialNumber','WarrantyStartDate','BISFlag','FailureDate','FailurePoint','FailureMeasure','ProductHours','EngineVIN','ECMCalibAfter','ECMCalibBefore','RevisionBefore','ReviewAfter','ESNModel','ApplicationCode','DistanceType','Hours');
            lstesnw.add(esnw);
            
            /*Cg_Cl_Claimsvs.ClaimNotes cnwrap=new Cg_Cl_Claimsvs.ClaimNotes();
cnwrap.lastSaveDate='';*/
            list<Cg_Cl_Claimsvs.claimWrapperClass> clwrlist=new list<Cg_Cl_Claimsvs.claimWrapperClass>();
            Cg_Cl_Claimsvs.claimWrapperClass claimswrap1 = new Cg_Cl_Claimsvs.claimWrapperClass();
            claimswrap1.accountcode  = 'Test';
            claimswrap1.claimid  = 'Test';
            claimswrap1.ServiceProviderCode  = 'Test';
            claimswrap1.DistributorCode  = 'Test';
            claimswrap1.EngineSerialNumber  = 'Test';
            claimswrap1.RONumber  = 'Test';
            claimswrap1.WarrantyStartDate  = 'Test';
            claimswrap1.EngineApplicationCode  = 'Test';
            claimswrap1.Manufacturer  = 'Test';
            claimswrap1.ModelSeries  = 'Test';
            claimswrap1.FirstName  = 'Test';
            claimswrap1.LastName  = 'Test';
            claimswrap1.BISFlag  = 'Test';
            claimswrap1.MultiESNFlg  = 'Test';
            claimswrap1.CampaignNumber  = 'Test';
            claimswrap1.InfoOnlyFlag  = 'Test';
            claimswrap1.NewPartsWarrantyFlg  = 'Test';
            claimswrap1.ReConPartsWarrantyFlg  = 'Test';
            claimswrap1.RoadRelayWarrantyFlg  = 'Test';
            claimswrap1.FailureDate  = 'Test';
            claimswrap1.FailurePoint  = 'Test';
            claimswrap1.FailureMeasure  = 'Test';
            claimswrap1.MissionDisablingFlag  = 'Test';
            claimswrap1.CatastrophicFlag  = 'Test';
            claimswrap1.RepairDescription  = 'Test';
            claimswrap1.ReplacementPart  = 'Test';
            claimswrap1.SPCertifiedFlag  = 'Test';
            claimswrap1.WarrantyTrainedFlag  = 'Test';
            claimswrap1.CustomerPossession  = 'Test';
            claimswrap1.DISDNumber  = 'Test';
            claimswrap1.CustomerName  = 'Test';
            claimswrap1.ECMCalibAfter  = 'Test';
            claimswrap1.ReviewAfter  = 'Test';
            claimswrap1.ECMCalibBefore  = 'Test';
            claimswrap1.RevisionBefore  = 'Test';
            claimswrap1.Justification  = 'Test';
            claimswrap1.EngineVIN  = 'Test';
            claimswrap1.ESNCount  = 'Test';
            claimswrap1.TSRNumber  = 'Test';
            claimswrap1.UnitNumber  = 'Test';
            claimswrap1.PaccarFlag  = 'Test';
            claimswrap1.PenaltyFlag  = 'Test';
            claimswrap1.SRTPenaltyPercentage  = 'Test';
            claimswrap1.manualAdjudicationFlag  = 'Test';
            claimswrap1.DealerClaimNumber  = 'Test';
            claimswrap1.ClaimSource  = 'Test';
            claimswrap1.ClaimFiledDate  = 'Test';
            claimswrap1.SPInShopLaborRate  = 'Test';
            claimswrap1.SPLaborRate  = 'Test';
            claimswrap1.SPTravelRate  = 'Test';
            claimswrap1.Contact  = 'Test';
            claimswrap1.SRTTime = 'Test';
            claimswrap1.FASRTTime = 'Test';
            claimswrap1.status  = 'Test';
            claimswrap1.BranchCode  = 'Test';
            claimswrap1.ClaimType  = 'Test';
            claimswrap1.ClaimDate  = 'Test';
            claimswrap1.Owned  = 'Test';
            claimswrap1.SiebelClaimNumber  = 'Test';
            claimswrap1.GuidanzClaimNumber  = 'Test';
            claimswrap1.CSSJobID  = 'Test';
            claimswrap1.BMSReferenceNumber  = 'Test';
            claimswrap1.DealerCode  = 'Test';
            claimswrap1.CustomerCode  = 'Test';
            claimswrap1.PayCode  = 'Test';
            claimswrap1.AuthorizationNumber  = 'Test';
            claimswrap1.ApprovalCode  = 'Test';
            claimswrap1.PolicyRequestNumber  = 'Test';
            claimswrap1.FailureLocation  = 'Test';
            claimswrap1.CreateUser  = 'Test';
            claimswrap1.Severity  = 'Test';
            claimswrap1.SMN  = 'Test';
            claimswrap1.EngineFamily  = 'Test';
            claimswrap1.Make  = 'Test';
            claimswrap1.Model  = 'Test';
            claimswrap1.EquipmentConfiguration  = 'Test';
            claimswrap1.DistanceType  = 'Test';
            claimswrap1.Hours  = 'Test';
            claimswrap1.DealerApproval  = 'Test';
            claimswrap1.DistributorAuthorization  = 'Test';
            claimswrap1.MaterialDisposition  = 'Test';
            claimswrap1.TotalPartsAmount  = 'Test';
            claimswrap1.TotalLaborAmount  = 'Test';
            claimswrap1.TotalTravelAmount  = 'Test';
            claimswrap1.TotalOtherAmount  = 'Test';
            claimswrap1.PMU  = 'Test';
            claimswrap1.BFC  = 'Test';
            claimswrap1.Tax  = 'Test';
            claimswrap1.TotalClaimAmount  = 'Test';
            claimswrap1.Reference1  = 'Test';
            claimswrap1.Reference2  = 'Test';
            claimswrap1.showEditLink = true;
            claimswrap1.Reference3  = 'Test';
            claimswrap1.TechnicianQualifiedFlag  = 'Test';
            //claimswrap1.SRTsWrapper = lstsrtwrap; 
            claimswrap1.TTMLWrapper = lstttmlwrap;
            claimswrap1.otherClaimWrapper = lstotherclaimwrap;
            claimswrap1.partsWrapper = lstpartswrap; 
            claimswrap1.failureWrapper = lstfailurewrap;  
            claimswrap1.ListOfComplaintCodes = lstccwrap;
            claimswrap1.ListOfPromotionIds = lstpwrap;
            claimswrap1.ListOfNotes = lstnoteswrap;
            //claimswrap1.fieldActionSRTsWrapper = lstfieldwrap;  
            claimswrap1.ListOfAdditionalESNs = lstesnw;
            claimswrap1.claimSubNotes = lstclnwrap;      
            clwrlist.add(claimswrap1);
            
            Map<String,List<CSS_SRT__C>> m = new Map<String,List<CSS_SRT__C>>();
            m.put('abcd', lstSRT);
            
            vs.prepareSiebelRequest();
            vs.prepareBMSRequest();
            vs.checkQuantity();
            vs.overlapSRTListMap=m;
            /* vs.SRTAccountCodeMap=m1;
vs.userType  = 'DLR';
vs.generateClaimSubmissionRecords();*/
            
            
            //claims.prepareBMSRequest();
            //claims.verifySubmitpgAction();
            //vs.prepareSiebelRequest();
        }
    }
    
    public static testmethod void testfetchClaimRecordsmethodAutoClaim(){
        
        user u = css_testdata.createTestUser(false);
        u.Username='TestUser.ra@cummins.com';
        u.Email='TestUser.ra@cummins.com';
        insert u;
        system.runAs(u)
        {
            Account acc = new Account();
            acc.name='Rtest123';
            acc.CSS_DistributorCode__c='03742';  
            acc.Type='Dealer Account';
            acc.IAM_Service_Provider_Code__c = '03741';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            
            css_job_order__c jo = new css_job_order__c();
            jo.Customer_Name__c='';
            jo.Customer_Code__c='123';
            jo.ESN__c='53467987';
            insert jo;
            
            css_solutions__c sol = new css_solutions__c();
            sol.Service_Job__c=jo.Id;
           // sol.FSL_Service_Job__c=jo.id;
            insert sol;
            
            css_claims__c claims1= new css_claims__C();
            claims1.Customer_Code__c='123';
            claims1.Customer_Name__c='TestUser';
            claims1.Multi_PSN_Claim__c=true;
            claims1.Account__c = acc.id;
            claims1.CSS_Job__c=jo.Id;
            claims1.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "100000", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "EMS-Emissions Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
            claims1.Status__c='';
            claims1.Complaint_Type_Desc__c = 'nkm';
            claims1.Complaint_Type2_Desc__c = 'nkm';
            claims1.Complaint_Type3_Desc__c = 'nkm';
            claims1.Complaint_Type4_Desc__c = 'nkm';
            claims1.Complaint_Type5_Desc__c = 'nkm';
            claims1.EditCause__c = 'sfsdf';
            claims1.EditCorrection__c = 'dsfsdf';
            claims1.EditComplaint__c = 'sfasr';
            insert claims1;
            
            Attachment a1 = new attachment();
            a1.ParentId = claims1.Id;
            a1.body = blob.valueOf('sfdsf');
            a1.Name = 'kris';
            insert a1;
            
            css_solution_Component__c solcomp = new css_solution_component__c();
            solcomp.Name='Testing';
            solcomp.AccountCodeEdit__c='Testing AccountCode';
            solcomp.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp.Selected_Component__c=true;
            solcomp.System_Code__c='WE';
            solcomp.Component_Code__c='QP';
            solcomp.Failure_Mode__c='EZ';
            solcomp.CSS_Claims__c=claims1.id;
            solcomp.Solutions__c=sol.Id;
            solcomp.Service_Job__c=jo.Id;
            insert solcomp;
            
            css_solution_Component__c solcomp1 = new css_solution_component__c();
            solcomp1.Name='Testing';
            solcomp1.AccountCodeEdit__c='Testing AccountCode';
            solcomp1.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp1.Selected_Component__c=true;
            solcomp1.System_Code__c='WE';
            solcomp1.Component_Code__c='QP';
            solcomp1.Failure_Mode__c='EZ';
            solcomp1.CSS_Claims__c=claims1.id;
            solcomp1.Solutions__c=sol.Id;
            solcomp1.Service_Job__c=jo.Id;
            solcomp1.Type__c='TRP';
            solcomp1.pay_code__c='A';
            insert solcomp1;
            
            css_solution_Component__c solcomp2 = new css_solution_component__c();
            solcomp2.Name='Testing';
            solcomp2.AccountCodeEdit__c='Testing AccountCode';
            solcomp2.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp2.Selected_Component__c=true;
            solcomp2.System_Code__c='WE';
            solcomp2.Component_Code__c='QP';
            solcomp2.Failure_Mode__c='EZ';
            solcomp2.CSS_Claims__c=claims1.id;
            solcomp2.Solutions__c=sol.Id;
            solcomp2.Service_Job__c=jo.Id;
            solcomp2.Type__c='ATC';
            solcomp2.pay_code__c='A';
            insert solcomp2;
            
            Date dToday = System.Today();
            Datetime dt = datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
            String dateStr =  dt.format('MM/dd/yyyy') ;
            Date d = date.parse(dateStr);
            system.debug('dateStr dateStr'+dateStr);
            system.debug('dateStr date date'+d);
            
            
            css_psn__c psn1 = new css_psn__c();
            psn1.CSS_Claims__c=claims1.Id;
            psn1.PSN__c='53467987';
            psn1.Primary__c=true;
            //psn1.Failure_Date__c=d;
            insert psn1;
            
            system.debug('Failure_Date__c Failure_Date__c'+psn1.Failure_Date__c);
            id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            id recodid1 = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
            id recodid2 = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
            
            CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
            partop.CSS_Claims__c=claims1.id;
            partop.selected_part__c=true;
            partop.RecordTypeId=recodid;
            partop.Fail_Code__c='WEQPEZ';
            partop.Quantity__c=1;
            partop.Covered__c=1;
            partop.Account_Code__c='Testing AccountCode';
            insert partop;
            
            CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
            partop1.CSS_Claims__c=claims1.id;
            partop1.selected_part__c=true;
            partop1.RecordTypeId=recodid1;
            partop1.Fail_Code__c='WEQPEZ';
            partop1.Quantity__c=1;
            partop1.Covered__c=1;
            partop1.Account_Code__c='Testing AccountCode';
            insert partop1;
            
            CSS_Parts_Options__c partop2 = new CSS_Parts_Options__c();
            partop2.CSS_Claims__c=claims1.id;
            partop2.selected_part__c=true;
            partop2.RecordTypeId=recodid2;
            partop2.Fail_Code__c='WEQPEZ';
            partop2.Quantity__c=1;
            partop2.Covered__c=1;
            partop2.Account_Code__c='Testing AccountCode';
            insert partop2;
            
            List<CSS_SRT__c>   lstsrt= new  List<CSS_SRT__c>();
            CSS_SRT__c srt1 = new CSS_SRT__c();
            srt1.FailCode__c='WEQPEZ';
            srt1.Account_Code__c='Testing AccountCode';
            srt1.SRT_AccessiblityCheck__c=TRUE;
            srt1.Type__c = 'Diag Access';
            srt1.srt_category__c = null;
            //srt1.Diag_Access_Time__c = 2.0;
            //srt1.Access_Code_Saved__c ='A';
            //srt1.Access_Code_A__c = ;
            //srt1.Access_Code_B__c = '';
            //srt1.Access_Code_C__c = '';
            //srt1.Access_Code_D__c = '';
            //srt1.Access_Code_R__c = '';
            srt1.SRT_Time__c =2;
            srt1.CSS_Claims__c=claims1.Id;
            lstsrt.add(srt1);
            
            List<CSS_SRT__c>   lstsrt11= new  List<CSS_SRT__c>();
            CSS_SRT__c srt11 = new CSS_SRT__c();
            srt11.FailCode__c = null;
            srt11.Account_Code__c='Testing AccountCode';
            srt11.SRT_AccessiblityCheck__c=TRUE;
            srt11.Type__c = 'Diag Access';
            srt11.srt_category__c = null;
            //srt1.Diag_Access_Time__c = 2.0;
            //srt1.Access_Code_Saved__c ='A';
            //srt1.Access_Code_A__c = ;
            //srt1.Access_Code_B__c = '';
            //srt1.Access_Code_C__c = '';
            //srt1.Access_Code_D__c = '';
            //srt1.Access_Code_R__c = '';
            srt11.SRT_Time__c =2;
            srt11.CSS_Claims__c=claims1.Id;
            lstsrt11.add(srt11);
            
            CSS_SRT__c srt2 = new CSS_SRT__c();
            srt2.FailCode__c= 'WEQPEZ';
            srt2.Account_Code__c='Testing AccountCode';
            srt2.SRT_AccessiblityCheck__c=TRUE;
            srt2.Type__c ='Field Action';
            srt2.SRT_Time__c = 2;
            srt2.SRT_Quantity__c =1;
            srt2.CSS_Claims__c=claims1.Id;
            lstsrt.add(srt2);
            
            CSS_SRT__c srt3 = new CSS_SRT__c();
            srt3.FailCode__c='WEQPEZ';
            srt3.Account_Code__c='Testing AccountCode';
            srt3.SRT_AccessiblityCheck__c=TRUE;
            srt3.Type__c = 'Repair Access';
            srt3.srt_category__c = null;
            srt3.SRT_Time__c =2;
            srt3.CSS_Claims__c=claims1.Id;
            lstsrt.add(srt3);
            
            CSS_SRT__c srt4 = new CSS_SRT__c();
            srt4.FailCode__c='WEQPEZ';
            srt4.Account_Code__c='Testing AccountCode';
            srt4.SRT_AccessiblityCheck__c=TRUE;
            srt4.Type__c = 'AdditionalDiag';
            srt4.srt_category__c = null;
            srt4.SRT_Time__c =2;
            srt4.solution_number__c = sol.id;
            srt4.CSS_Claims__c=claims1.Id;
            lstsrt.add(srt4);
            
            CSS_SRT__c srt5 = new CSS_SRT__c();
            srt5.FailCode__c='WEQPEZ';
            srt5.Account_Code__c='Testing AccountCode';
            srt5.SRT_AccessiblityCheck__c=TRUE;
            srt5.Type__c = '99Time';
            srt5.CSS_Claims__c=claims1.Id;
            lstsrt.add(srt5);
            
            insert lstsrt;
            
            CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
            claimsum.CSS_Claims__c=claims1.Id;
            claimsum.Status__c='Submitted';
            insert claimsum;
            
            note not1 = new note();
            not1.Body='Testing;test;testttt';
            not1.ParentId=claimsum.Id;
            not1.Title='Claims';
            insert not1;
            
            CSS_Claim_Submission__c claimsum1 = new CSS_Claim_Submission__c();
            
            claimsum1.CSS_Claims__c=claims1.Id;
            claimsum1.Individual_Claim_Id__c='c008543';
            claimsum1.Status__c='Submitted';
            insert claimsum1;
            
            note not2 = new note();
            not2.Body='Testing;test;testttt';
            not2.ParentId=claimsum.Id;
            not2.Title='Claims';
            insert not2;
            
            CSS_JobEventTemporary__c  jobevt = new CSS_JobEventTemporary__c ();
            jobevt.Reason__c='{"DataArea":{"Details":[{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LOSS - OVERFLOW","BusinessUnit":"EBU","ComplaintCode":"106","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"117","ActiveFlag":"Y"},{"Category":"Leak","Description":"EXHAUST LEAK","BusinessUnit":"EBU","ComplaintCode":"118","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SHUTS DOWN OR STALLS","BusinessUnit":"EBU","ComplaintCode":"205","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SURGES","BusinessUnit":"EBU","ComplaintCode":"212","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"LOW POWER","BusinessUnit":"EBU","ComplaintCode":"213","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"VIBRATION","BusinessUnit":"EBU","ComplaintCode":"401","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"INOPERATIVE COMPONENT","BusinessUnit":"EBU","ComplaintCode":"404","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE RUNS ROUGH","BusinessUnit":"EBU","ComplaintCode":"215","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"115","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"116","ActiveFlag":"Y"},{"Category":"Leak","Description":"COMPRESSION LEAK","BusinessUnit":"EBU","ComplaintCode":"120","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - RED","BusinessUnit":"EBU","ComplaintCode":"202","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE WILL NOT SHUT DOWN","BusinessUnit":"EBU","ComplaintCode":"211","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"CRUISE CONTROL","BusinessUnit":"EBU","ComplaintCode":"503","ActiveFlag":"Y"},{"Category":"Other","Description":"INSPECTION","BusinessUnit":"EBU","ComplaintCode":"603","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN AIR SYSTEM","BusinessUnit":"EBU","ComplaintCode":"121","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO NOISE","BusinessUnit":"EBU","ComplaintCode":"123","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL OUT EXHAUST","BusinessUnit":"EBU","ComplaintCode":"124","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL IN INTAKE","BusinessUnit":"EBU","ComplaintCode":"125","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - YELLOW","BusinessUnit":"EBU","ComplaintCode":"201","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT REACH RPM","BusinessUnit":"EBU","ComplaintCode":"206","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED HIGH","BusinessUnit":"EBU","ComplaintCode":"208","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"POOR THROTTLE RESPONSE","BusinessUnit":"EBU","ComplaintCode":"214","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HIGH BLOW-BY","BusinessUnit":"EBU","ComplaintCode":"408","ActiveFlag":"Y"},{"Category":"Other","Description":"REBUILD","BusinessUnit":"EBU","ComplaintCode":"602","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT COMPLETE","BusinessUnit":"EBU","ComplaintCode":"606","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"101","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT BUILD AIR OR BUILDS SLOWLY","BusinessUnit":"EBU","ComplaintCode":"122","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ROUGH IDLE","BusinessUnit":"EBU","ComplaintCode":"209","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLACK SMOKE","BusinessUnit":"EBU","ComplaintCode":"302","ActiveFlag":"Y"},{"Category":"Other","Description":"VOLTAGE (GENSET)","BusinessUnit":"EBU","ComplaintCode":"505","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"STARTER MOTOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"508","ActiveFlag":"Y"},{"Category":"Other","Description":"CAMPAIGN / TRP","BusinessUnit":"EBU","ComplaintCode":"601","ActiveFlag":"Y"},{"Category":"Other","Description":"FAILED EMISSION TEST","BusinessUnit":"EBU","ComplaintCode":"604","ActiveFlag":"Y"},{"Category":"Other","Description":"MAINTENANCE","BusinessUnit":"EBU","ComplaintCode":"605","ActiveFlag":"Y"},{"Category":"Other","Description":"TELEMATICS","BusinessUnit":"EBU","ComplaintCode":"990","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HARD START","BusinessUnit":"EBU","ComplaintCode":"203","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"204","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE MISFIRE","BusinessUnit":"EBU","ComplaintCode":"210","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ENGINE BRAKE MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"406","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BLOWING DIPSTCK OUT","BusinessUnit":"EBU","ComplaintCode":"407","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - NOT IN OIL","BusinessUnit":"EBU","ComplaintCode":"102","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"107","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"109","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE HIGH","BusinessUnit":"EBU","ComplaintCode":"112","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"113","ActiveFlag":"Y"},{"Category":"Leak","Description":"DEF LEAK","BusinessUnit":"EBU","ComplaintCode":"609","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED LOW","BusinessUnit":"EBU","ComplaintCode":"207","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WHITE SMOKE","BusinessUnit":"EBU","ComplaintCode":"301","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"NOISE IN ENGINE","BusinessUnit":"EBU","ComplaintCode":"402","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT CARRY LOAD (GENSET)","BusinessUnit":"EBU","ComplaintCode":"504","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN TOO FREQUENT","BusinessUnit":"EBU","ComplaintCode":"608","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"103","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"108","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"114","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLUE SMOKE","BusinessUnit":"EBU","ComplaintCode":"303","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE OVERSPEED","BusinessUnit":"EBU","ComplaintCode":"409","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BELT PROBLEM","BusinessUnit":"EBU","ComplaintCode":"410","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ALTERNATOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"507","ActiveFlag":"Y"},{"Category":"Other","Description":"OTHER - SEE TEXT FOR DESCRIPTION","BusinessUnit":"EBU","ComplaintCode":"999","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"607","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"104","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"105","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"110","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE LOW","BusinessUnit":"EBU","ComplaintCode":"111","ActiveFlag":"Y"},{"Category":"Leak","Description":"AIR LEAK","BusinessUnit":"EBU","ComplaintCode":"119","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"NOISY COMPONENT","BusinessUnit":"EBU","ComplaintCode":"403","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"LOOSE OR BROKEN MOUNTING HARDWARE","BusinessUnit":"EBU","ComplaintCode":"405","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BREAKER TRIPPING","BusinessUnit":"EBU","ComplaintCode":"506","ActiveFlag":"Y"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
            jobevt.Attribute1__c='CategoryComplaintCodes';
            insert jobevt;
            
            apexpages.currentPage().getparameters().put('id',claims1.Id);
            
            CG_CL_ClaimsVS vs = new CG_CL_ClaimsVS();
            vs.exchangeRate=1.33;
            vs.showReOpenbtn();
            //vs.prepareBMSRequest();
            vs.generateClaimSubmissionRecords();
            vs.verifySubmitpgAction();
            vs.prepareSiebelRequest();
            
            CG_CL_ClaimsVS cvf=new CG_CL_ClaimsVS();
            cvf.showsubmitButton=true;
            boolean showSubmitbtnvalues = true;
            vs.showSubmitbtn();
        }
    }
    
    public static testmethod void testfetchClaimRecordsmethodManualClaim(){
        user u = css_testdata.createTestUser(false);
        u.Username='TestUser.ra@cummins.com';
        u.Email='TestUser.ra@cummins.com';
        insert u;
        system.runAs(u)
        {
            /*css_job_order__c jo = new css_job_order__c();
jo.Customer_Name__c='';
jo.Customer_Code__c='123';
jo.ESN__c='53467987';
insert jo;

css_solutions__c sol = new css_solutions__c();
sol.Service_Job__c=jo.Id;
insert sol;*/
            Account acc = new Account();
            acc.name='Rtest123';
            acc.CSS_DistributorCode__c='03742';  
            acc.Type='Dealer Account';
            acc.IAM_Service_Provider_Code__c = '03741';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            css_claims__c claims1= new css_claims__C();
            claims1.Customer_Code__c='123';
            claims1.Customer_Name__c='TestUser';
            claims1.Multi_PSN_Claim__c=true;
            claims1.Account__c = acc.id;
            //claims1.CSS_Job__c=jo.Id;
            claims1.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "100000", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "EMS-Emissions Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
            claims1.Status__c='';
            claims1.Complaint_Type_Desc__c = 'nkm';
            claims1.Complaint_Type2_Desc__c = 'nkm';
            claims1.Complaint_Type3_Desc__c = 'nkm';
            claims1.Complaint_Type4_Desc__c = 'nkm';
            claims1.Complaint_Type5_Desc__c = 'nkm';
            claims1.EditCause__c = 'sfsdf';
            claims1.EditCorrection__c = 'dsfsdf';
            claims1.EditComplaint__c = 'sfasr';
            insert claims1;
            
            Attachment a1 = new attachment();
            a1.ParentId = claims1.Id;
            a1.body = blob.valueOf('sfdsf');
            a1.Name = 'kris';
            insert a1;
            
            css_solution_Component__c solcomp = new css_solution_component__c();
            solcomp.Name='Testing';
            solcomp.AccountCodeEdit__c='Testing AccountCode';
            solcomp.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp.Selected_Component__c=true;
            solcomp.System_Code__c='WE';
            solcomp.Component_Code__c='QP';
            solcomp.Failure_Mode__c='EZ';
            solcomp.CSS_Claims__c=claims1.id;
            //solcomp.Solutions__c=sol.Id;
            //solcomp.Service_Job__c=jo.Id;
            insert solcomp;
            
            css_solution_Component__c solcomp1 = new css_solution_component__c();
            solcomp1.Name='Testing';
            solcomp1.AccountCodeEdit__c='Testing AccountCode';
            solcomp1.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp1.Selected_Component__c=true;
            solcomp1.System_Code__c='WE';
            solcomp1.Component_Code__c='QP';
            solcomp1.Failure_Mode__c='EZ';
            solcomp1.CSS_Claims__c=claims1.id;
            //solcomp1.Solutions__c=sol.Id;
            //solcomp1.Service_Job__c=jo.Id;
            solcomp1.Type__c='TRP';
            solcomp1.pay_code__c='A';
            insert solcomp1;
            
            css_solution_Component__c solcomp2 = new css_solution_component__c();
            solcomp2.Name='Testing';
            solcomp2.AccountCodeEdit__c='Testing AccountCode';
            solcomp2.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp2.Selected_Component__c=true;
            solcomp2.System_Code__c='WE';
            solcomp2.Component_Code__c='QP';
            solcomp2.Failure_Mode__c='EZ';
            solcomp2.CSS_Claims__c=claims1.id;
            //solcomp2.Solutions__c=sol.Id;
            //solcomp2.Service_Job__c=jo.Id;
            solcomp2.Type__c='ATC';
            solcomp2.pay_code__c='A';
            insert solcomp2;
            
            Date dToday = System.Today();
            Datetime dt = datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
            String dateStr =  dt.format('MM/dd/yyyy') ;
            Date d = date.parse(dateStr);
            system.debug('dateStr dateStr'+dateStr);
            system.debug('dateStr date date'+d);
            
            
            css_psn__c psn1 = new css_psn__c();
            psn1.CSS_Claims__c=claims1.Id;
            psn1.PSN__c='53467987';
            psn1.Primary__c=true;
            //psn1.Failure_Date__c=d;
            insert psn1;
            
            system.debug('Failure_Date__c Failure_Date__c'+psn1.Failure_Date__c);
            id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            id recodid1 = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
            id recodid2 = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
            
            CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
            partop.CSS_Claims__c=claims1.id;
            partop.selected_part__c=true;
            partop.RecordTypeId=recodid;
            partop.Fail_Code__c='WEQPEZ';
            partop.Quantity__c=1;
            partop.Covered__c=1;
            partop.Account_Code__c='Testing AccountCode';
            insert partop;
            
            CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
            partop1.CSS_Claims__c=claims1.id;
            partop1.selected_part__c=true;
            partop1.RecordTypeId=recodid1;
            partop1.Fail_Code__c='WEQPEZ';
            partop1.Quantity__c=1;
            partop1.Covered__c=1;
            partop1.Account_Code__c='Testing AccountCode';
            insert partop1;
            
            CSS_Parts_Options__c partop2 = new CSS_Parts_Options__c();
            partop2.CSS_Claims__c=claims1.id;
            partop2.selected_part__c=true;
            partop2.RecordTypeId=recodid2;
            partop2.Fail_Code__c='WEQPEZ';
            partop2.Quantity__c=1;
            partop2.Covered__c=1;
            partop2.Account_Code__c='Testing AccountCode';
            insert partop2;
            
            CSS_Parts_Options__c partop4 = new CSS_Parts_Options__c();
            partop4.CSS_Claims__c=claims1.id;
            partop4.selected_part__c=true;
            partop4.RecordTypeId=recodid2;
            partop4.Fail_Code__c='WEQPEZ';
            partop4.Quantity__c= null;
            partop4.type__c = 'Commercial-Travel';
            partop4.Account_Code__c='Testing AccountCode';
            insert partop4;
            
            List<CSS_SRT__c>   lstsrt= new  List<CSS_SRT__c>();
            CSS_SRT__c srt1 = new CSS_SRT__c();
            srt1.FailCode__c='WEQPEZ';
            srt1.Account_Code__c='Testing AccountCode';
            srt1.SRT_AccessiblityCheck__c=TRUE;
            srt1.Type__c = 'Diag Access';
            srt1.CSS_Claims__c=claims1.Id;
            lstsrt.add(srt1);
            insert lstsrt;
            
            
            CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
            claimsum.CSS_Claims__c=claims1.Id;
            claimsum.Status__c='Submitted';
            insert claimsum;
            
            note not1 = new note();
            not1.Body='Testing;test;testttt';
            not1.ParentId=claimsum.Id;
            not1.Title='Claims';
            insert not1;
            
            CSS_Claim_Submission__c claimsum1 = new CSS_Claim_Submission__c();
            
            claimsum1.CSS_Claims__c=claims1.Id;
            claimsum1.Individual_Claim_Id__c='c008543';
            claimsum1.Status__c='Submitted';
            insert claimsum1;
            
            note not2 = new note();
            not2.Body='Testing;test;testttt';
            not2.ParentId=claimsum.Id;
            not2.Title='Claims';
            insert not2;
            
            CSS_JobEventTemporary__c  jobevt = new CSS_JobEventTemporary__c ();
            jobevt.Reason__c='{"DataArea":{"Details":[{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LOSS - OVERFLOW","BusinessUnit":"EBU","ComplaintCode":"106","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"117","ActiveFlag":"Y"},{"Category":"Leak","Description":"EXHAUST LEAK","BusinessUnit":"EBU","ComplaintCode":"118","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SHUTS DOWN OR STALLS","BusinessUnit":"EBU","ComplaintCode":"205","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SURGES","BusinessUnit":"EBU","ComplaintCode":"212","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"LOW POWER","BusinessUnit":"EBU","ComplaintCode":"213","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"VIBRATION","BusinessUnit":"EBU","ComplaintCode":"401","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"INOPERATIVE COMPONENT","BusinessUnit":"EBU","ComplaintCode":"404","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE RUNS ROUGH","BusinessUnit":"EBU","ComplaintCode":"215","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"115","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"116","ActiveFlag":"Y"},{"Category":"Leak","Description":"COMPRESSION LEAK","BusinessUnit":"EBU","ComplaintCode":"120","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - RED","BusinessUnit":"EBU","ComplaintCode":"202","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE WILL NOT SHUT DOWN","BusinessUnit":"EBU","ComplaintCode":"211","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"CRUISE CONTROL","BusinessUnit":"EBU","ComplaintCode":"503","ActiveFlag":"Y"},{"Category":"Other","Description":"INSPECTION","BusinessUnit":"EBU","ComplaintCode":"603","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN AIR SYSTEM","BusinessUnit":"EBU","ComplaintCode":"121","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO NOISE","BusinessUnit":"EBU","ComplaintCode":"123","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL OUT EXHAUST","BusinessUnit":"EBU","ComplaintCode":"124","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL IN INTAKE","BusinessUnit":"EBU","ComplaintCode":"125","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - YELLOW","BusinessUnit":"EBU","ComplaintCode":"201","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT REACH RPM","BusinessUnit":"EBU","ComplaintCode":"206","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED HIGH","BusinessUnit":"EBU","ComplaintCode":"208","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"POOR THROTTLE RESPONSE","BusinessUnit":"EBU","ComplaintCode":"214","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HIGH BLOW-BY","BusinessUnit":"EBU","ComplaintCode":"408","ActiveFlag":"Y"},{"Category":"Other","Description":"REBUILD","BusinessUnit":"EBU","ComplaintCode":"602","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT COMPLETE","BusinessUnit":"EBU","ComplaintCode":"606","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"101","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT BUILD AIR OR BUILDS SLOWLY","BusinessUnit":"EBU","ComplaintCode":"122","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ROUGH IDLE","BusinessUnit":"EBU","ComplaintCode":"209","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLACK SMOKE","BusinessUnit":"EBU","ComplaintCode":"302","ActiveFlag":"Y"},{"Category":"Other","Description":"VOLTAGE (GENSET)","BusinessUnit":"EBU","ComplaintCode":"505","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"STARTER MOTOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"508","ActiveFlag":"Y"},{"Category":"Other","Description":"CAMPAIGN / TRP","BusinessUnit":"EBU","ComplaintCode":"601","ActiveFlag":"Y"},{"Category":"Other","Description":"FAILED EMISSION TEST","BusinessUnit":"EBU","ComplaintCode":"604","ActiveFlag":"Y"},{"Category":"Other","Description":"MAINTENANCE","BusinessUnit":"EBU","ComplaintCode":"605","ActiveFlag":"Y"},{"Category":"Other","Description":"TELEMATICS","BusinessUnit":"EBU","ComplaintCode":"990","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HARD START","BusinessUnit":"EBU","ComplaintCode":"203","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"204","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE MISFIRE","BusinessUnit":"EBU","ComplaintCode":"210","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ENGINE BRAKE MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"406","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BLOWING DIPSTCK OUT","BusinessUnit":"EBU","ComplaintCode":"407","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - NOT IN OIL","BusinessUnit":"EBU","ComplaintCode":"102","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"107","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"109","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE HIGH","BusinessUnit":"EBU","ComplaintCode":"112","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"113","ActiveFlag":"Y"},{"Category":"Leak","Description":"DEF LEAK","BusinessUnit":"EBU","ComplaintCode":"609","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED LOW","BusinessUnit":"EBU","ComplaintCode":"207","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WHITE SMOKE","BusinessUnit":"EBU","ComplaintCode":"301","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"NOISE IN ENGINE","BusinessUnit":"EBU","ComplaintCode":"402","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT CARRY LOAD (GENSET)","BusinessUnit":"EBU","ComplaintCode":"504","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN TOO FREQUENT","BusinessUnit":"EBU","ComplaintCode":"608","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"103","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"108","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"114","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLUE SMOKE","BusinessUnit":"EBU","ComplaintCode":"303","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE OVERSPEED","BusinessUnit":"EBU","ComplaintCode":"409","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BELT PROBLEM","BusinessUnit":"EBU","ComplaintCode":"410","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ALTERNATOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"507","ActiveFlag":"Y"},{"Category":"Other","Description":"OTHER - SEE TEXT FOR DESCRIPTION","BusinessUnit":"EBU","ComplaintCode":"999","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"607","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"104","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"105","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"110","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE LOW","BusinessUnit":"EBU","ComplaintCode":"111","ActiveFlag":"Y"},{"Category":"Leak","Description":"AIR LEAK","BusinessUnit":"EBU","ComplaintCode":"119","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"NOISY COMPONENT","BusinessUnit":"EBU","ComplaintCode":"403","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"LOOSE OR BROKEN MOUNTING HARDWARE","BusinessUnit":"EBU","ComplaintCode":"405","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BREAKER TRIPPING","BusinessUnit":"EBU","ComplaintCode":"506","ActiveFlag":"Y"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
            jobevt.Attribute1__c='CategoryComplaintCodes';
            insert jobevt;
            
            apexpages.currentPage().getparameters().put('id',claims1.Id);
            
            CG_CL_ClaimsVS vs = new CG_CL_ClaimsVS();
            vs.exchangeRate=1.33;
            vs.showReOpenbtn();
            VS.userType = 'DLR';
            //vs.prepareBMSRequest();
            vs.generateClaimSubmissionRecords();
            vs.verifySubmitpgAction();
            vs.prepareSiebelRequest();
            
            CG_CL_ClaimsVS cvf=new CG_CL_ClaimsVS();
            cvf.userType = 'DLR';
            cvf.showsubmitButton=true;
            boolean showSubmitbtnvalues = true;
            vs.showSubmitbtn();
        }
    }
    
    public static Testmethod void TestPageRedirection(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'kal2', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,DefaultCurrencyIsoCode='USD',CurrencyIsoCode='USD',
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal10@testorg.com', user_Location__c = '56270-56270',isActive = true);
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        
        List<CSS_Claims__c> lstclaim = new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Contact_First_Name__c='tets';
        claim.Location_Code__c='03520-04892';
        claim.ESN__c='12345';
        claim.Shop_Work_Order__c='1234';
        claim.ownerId = u.Id;
        lstclaim.add(claim);
        
        CSS_Claims__c claim1 = new CSS_Claims__c();
        claim1.Contact_First_Name__c='tets';
        claim1.Location_Code__c='03520-04892';
        claim1.ESN__c='12345';
        claim1.Shop_Work_Order__c='1234';
        claim1.Pending_Authorization__c ='Not Authorized';
        lstclaim.add(claim1);
        insert lstclaim;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            claim = CSS_TestData.createclaims(true,joorder.Id); 
        }
        
        if(claim.id!=null)
            claim.id=null;
        PageReference pageRef = Page.CG_ClaimsVS;
        pageRef.getParameters().put('id', claim.id);
        Test.setCurrentPage(pageRef); 
        
        
        test.startTest();
        Currency_Conversion__c obj = new Currency_Conversion__c();
        obj.Bolt_To_Currency__c = 'USD';
        insert obj;
        CG_CL_ClaimsVS claims = new CG_CL_ClaimsVS();
        claims.exchangeRate=1.33;
        claims.nvClaimsIntake();
        claims.redirectToCC();
        claims.nvClaimsPSN();
        claims.nvClaimsFC();
        claims.nvClaimsWC();
        claims.nvClaimsCC();
        claims.nvClaimsVH();
        claims.nvClaimsSRTs();
        claims.nvClaimsPOC();
        claims.nvClaimsJobNotes();
        test.stoptest();
    }
    
    public static testmethod void testForReopenClaimNull(){
        
        CSS_Job_Order__C JO = CSS_TestData.createJobOrder(true);
        
        CSS_Claims__c claimrec = CSS_TestData.createclaims(true,JO.id);
        
        List<CSS_Claim_Submission__c> lstclaimsum = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claimrec.Id;
        claimsum.Status__c = 'Submitted';
        lstclaimsum.add(claimsum);
        insert lstclaimsum;
        
        cg_cl_claimsvs clm=new cg_cl_claimsvs();
        Currency_Conversion__c obj = new Currency_Conversion__c();
        obj.Bolt_To_Currency__c = 'USD';
        insert obj;
        clm.exchangeRate=1.33;
        clm.ReopenClaim();
        system.assert(clm.srtrec==null);
        system.assert(clm.prtopt==null);
        system.assert(clm.solncmpnt==null);
    }
    
    public static Testmethod void TestForNullValues(){
        
        string cId = ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = Page.CG_ClaimsVS;
        Test.setCurrentPage(pageRef);
        test.startTest();
        Currency_Conversion__c obj = new Currency_Conversion__c();
        obj.Bolt_To_Currency__c = 'USD';
        insert obj;
        CG_CL_ClaimsVS claims = new CG_CL_ClaimsVS();
        claims.exchangeRate=1.33;
        test.stopTest();
    }
    
    public static Testmethod void TestForFailcodeAndAccountFormula(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c = 'Oliver Trucking';
        jo.Customer_Code__c = '123456';
        jo.ESN__c = '53467987';
        insert jo;
        
        css_claims__c claims = new css_claims__C();
        claims.Customer_Code__c = '123456';
        claims.Customer_Name__c = 'Oliver Trucking';
        claims.CSS_Job__c = jo.Id;
        insert claims;
        
        css_psn__c psn = new css_psn__c();
        psn.CSS_Claims__c = claims.Id;
        psn.PSN__c = '53467987';
        psn.Primary__c = true;
        psn.Calibration_After__c  = 'A';
        psn.Calibration_Before__c = 'B';
        psn.Revision_Before__c = 'C';
        psn.Revision_After__c = 'D';
        insert psn;
        
        css_solutions__c solution = new css_solutions__c();
        solution.Service_Job__c=jo.Id;
        insert solution;    
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
        solcomps.Component_Id__c = 'F19000540';
        solcomps.Selected_Component__c = true;
        solcomps.CSS_Claims__c = claims.Id;
        solcomps.System_Code__c = 'EQ';
        solcomps.Component_Code__c = 'PE';
        solcomps.Part_Warranty_Start_Date__c = system.today();
        solcomps.Failure_Date__c = system.today() + 1;
        solcomps.Failure_Point__c = 2.0;
        solcomps.Failure_Mode__c = 'HB';
        solcomps.AccountCode__c = '70';
        solcomps.AccountCodeType__c = 'Emissions Warranty';
        solcomps.AccountCodeEdit__c = 'Emissions Warranty70';
        solcompsList.add(solcomps);
        insert solcompsList;
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'AB';
        jET.Attribute3__c = 'CD';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        insert jETList;
        
        Map<String, String> accCodeCoverage = new Map<String, String>(); 
        accCodeCoverage.put('DSBDV5789','AB');
        accCodeCoverage.values();
        
        PageReference pageRef = Page.CG_ClaimsVS;
        Test.setCurrentPage(pageRef); 
        apexpages.currentPage().getparameters().put('id',claims.id);      
        
        test.startTest();
        Currency_Conversion__c obj = new Currency_Conversion__c();
        obj.Bolt_To_Currency__c = 'USD';
        insert obj;
        CG_CL_ClaimsVS claim = new CG_CL_ClaimsVS();
        claim.exchangeRate=1.33;
        Claim.accCodeCoverageType = accCodeCoverage;
        test.stopTest();     
    }
    
    public static Testmethod void TestForMultiPSN(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c = 'Oliver Trucking';
        jo.Customer_Code__c = '123456';
        jo.ESN__c = '53467987';
        insert jo;
        
        css_claims__c claims = new css_claims__C();
        claims.Customer_Code__c = '123456';
        claims.Customer_Name__c = 'Oliver Trucking';
        claims.CSS_Job__c = jo.Id;
        claims.Multi_PSN_Claim__c = true;
        insert claims;
        
        list<css_psn__c> psnList = new list<css_psn__c>();
        css_psn__c psn1 = new css_psn__c();
        psn1.CSS_Claims__c = claims.Id;
        psn1.PSN__c = '53467987';
        psn1.Warranty_Start_Date__c = date.today();
        psnList.add(psn1);
        
        css_psn__c psn2 = new css_psn__c();
        psn2.CSS_Claims__c = claims.Id;
        psn2.PSN__c = '79464646';
        psnList.add(psn2);
        insert psnList;
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
        solcomps.Component_Id__c = 'F19000540';
        solcomps.Selected_Component__c = true;
        solcomps.CSS_Claims__c = claims.Id;
        solcomps.System_Code__c = 'EQ';
        solcomps.Component_Code__c = 'PE';
        solcomps.Failure_Mode__c = 'HB';
        solcomps.AccountCode__c = '70';
        solcomps.Type__c = 'Campaign';
        solcomps.AccountCodeType__c = 'Emissions Warranty';
        solcomps.AccountCodeEdit__c = 'Emissions Warranty70';
        solcompsList.add(solcomps);
        insert solcompsList;
        
         
        CSS_Claim_Submission__c cs=  new CSS_Claim_Submission__c();
        cs.name = 'SendNotesTest';
        cs.Individual_Claim_Id__c = 'C0000182919-01';
        cs.Siebel_Claim_Number__c = '1-2100290208';
        insert cs;
        
        List<Note> notesList = new List<Note>();
        Note nt = new Note();
        nt.ParentId = cs.Id;
        nt.title = 'SP Update';
        notesList.add(nt);
        insert notesList;
             
        PageReference pageRef = Page.CG_ClaimsVS;
        Test.setCurrentPage(pageRef); 
        apexpages.currentPage().getparameters().put('id',claims.id);      
        
        test.startTest();
        Currency_Conversion__c obj = new Currency_Conversion__c();
        obj.Bolt_To_Currency__c = 'USD';
        insert obj;
        CG_CL_ClaimsVS claim = new CG_CL_ClaimsVS();
        claim.exchangeRate=1.33;
        claim.checkAccountCode = true;
        claim.showSubmitbtn();
        claim.getMultiPSN();
        claim.fetchclaimrelatedrecords();
        test.stopTest();  
    }
    
    public static Testmethod void TestForMultiPSN1(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c = 'Oliver Trucking';
        jo.Customer_Code__c = '123456';
        jo.ESN__c = '53467987';
        insert jo;
        
        css_claims__c claims = new css_claims__C();
        claims.Customer_Code__c = '123456';
        claims.Customer_Name__c = 'Oliver Trucking';
        claims.CSS_Job__c = jo.Id;
        claims.Multi_PSN_Claim__c = true;
        insert claims;
        
        list<css_psn__c> psnList = new list<css_psn__c>();
        css_psn__c psn1 = new css_psn__c();
        psn1.CSS_Claims__c = claims.Id;
        psn1.PSN__c = '53467987';
        psn1.Warranty_Start_Date__c = date.today();
        psnList.add(psn1);
        
        
        List<CSS_Solution_Component__c> solcompsList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomps = new CSS_Solution_Component__c();
        solcomps.Component_Id__c = null;
        solcomps.Selected_Component__c = true;
        solcomps.CSS_Claims__c = claims.Id;
        solcomps.System_Code__c = 'EQ';
        solcomps.Component_Code__c = 'PE';
        solcomps.Failure_Mode__c = 'HB';
        solcomps.AccountCode__c = '70';
        solcomps.Type__c = 'Campaign';
        solcomps.AccountCodeType__c = 'Emissions Warranty';
        solcomps.AccountCodeEdit__c = 'Emissions Warranty70';
        solcompsList.add(solcomps);
        //insert solcompsList;
        PageReference pageRef = Page.CG_ClaimsVS;
        Test.setCurrentPage(pageRef); 
        apexpages.currentPage().getparameters().put('id',claims.id);      
        
        test.startTest();
        CG_CL_ClaimsVS claim = new CG_CL_ClaimsVS();
        claim.exchangeRate=1.33;
        claim.checkAccountCode = true;
        claim.showSubmitbtn();
        claim.getMultiPSN();
        claim.fetchclaimrelatedrecords();
        test.stopTest();  
    }
    
    public static Testmethod void TestForNotes(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c = 'Oliver Trucking';
        jo.Customer_Code__c = '123456';
        jo.ESN__c = '53467987';
        insert jo;
        
        list<css_claims__c> claimlist = new list<css_claims__c>();    
        css_claims__c claims = new css_claims__C();
        claims.Customer_Code__c = '123456';
        claims.Customer_Name__c = 'Oliver Trucking';
        claims.CSS_Job__c = jo.Id;
        insert claims;
        
        list<note> noteslist=new list<note>();
        Note testNote = new Note();
        testNote.Title = 'Test Account Note';
        testNote.Body = 'Test Account Note Body.';
        testNote.ParentId = claims.Id;
        noteslist.add(testNote);
        insert noteslist;
        
        PageReference pageRef = Page.CG_ClaimsVS;
        Test.setCurrentPage(pageRef); 
        apexpages.currentPage().getparameters().put('id',claims.id); 
        
        test.startTest();
        CG_CL_ClaimsVS claim = new CG_CL_ClaimsVS();
        claim.exchangeRate=1.33;
        claim.ClaimNotesList = noteslist;
        claim.multiPSN_CampNum='Test';
        claim.editQuantity=false;
        claim.getMultiPSN();
        claim.fetchclaimrelatedrecords();
        test.stopTest();  
        
    }
    
    public static testmethod void testOnfetchAccountFailCodeCombo(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.Warranty_Training_Certification__c = true;
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.CSS_In_Shop_Labor_Rate__c = 'aka';
        jo.CSS_Field_Service_Labor_Rate__c = 'ritz';
        jo.CSS_Travel_Rate__c = 'arp';
        jo.ESN__c='79464646';
        insert jo;
        
        css_claims__c claims = new css_claims__C();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c = acc.id;
        claims.CSS_Job__c=jo.Id;
        claims.Information_Only_Claim__c = true;
        insert claims;
        
        css_psn__c psn1 = new css_psn__c();
        psn1.CSS_Claims__c=claims.Id;
        psn1.ApplicationCode__c = '130';
        psn1.Justification__c = 'Broken Revision';
        psn1.VIN__c = 'aknaksha';
        psn1.Mission_Disabling__c = true;
        psn1.PSN__c='79464646';
        psn1.Primary__c=true;
        insert psn1;
        
        
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.CSS_Claims__c=claims.id;
        solcomp.System_Code__c='te';
        solcomp.Component_Code__c='st';
        solcomp.Failure_Mode__c = '3I';
        
        solComp.AccountCodeEdit__c = 'NEW PARTS WARRANTY 62';
        solcomp.Fail_Code_Editable__c='test-TEST';
        solcomp.Type__c= null;
        solcomp.Selected_Component__c = true;
        lstsolcomp.add(solcomp);
        insert lstsolcomp;
        
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
        parts.Service_partnumber__c = '540571401';
        parts.Part_Name__c = 'TestPart';
        parts.Parts_Type__c = 'Custom';
        parts.ReturnToFactory__c = 'Campaign-TRP-ATC';
        parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts.Quantity__c = 55;
        parts.Notes__c = 'Test Notes';
        parts.CSS_Claims__c = claims.id;
        parts.recordtypeid = rtp.id;
        parts.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts.Fail_Code__c=null;
        parts.Covered__c = 100;
        insert parts;
        lstparts.add(parts);
        system.debug('parts.Fail_Code__c'+parts.Fail_Code__c);
        
        
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.selected_part__c = True;
        parts1.Service_partnumber__c = '540571401';
        parts1.OEM__c = 'OEMWRS';
        parts1.Part_Name__c = 'TestPartCamp';
        parts1.ReturnToFactory__c = 'Campaign-TRP-ATC';
        parts1.Replacement_Reason__c = 'Campaign-TRP-ATC';
        parts1.Quantity__c = 55;
        parts1.Notes__c = 'Test Notes';
        parts1.CSS_Claims__c = claims.id;
        parts1.recordtypeid=rtp.id;
        parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts1.Fail_Code__c=null;
        insert parts1;
        lstparts.add(parts1);
        
        List<CSS_SRT__c> lstsrt= new  List<CSS_SRT__c>();
        CSS_SRT__c SRT1 = new CSS_SRT__c();
        SRT1.CSS_Claims__c = claims.Id;
        srt1.SRT_AccessiblityCheck__c=TRUE;
        SRT1.Component_Id__c = solcomp.id; 
        SRT1.Account_Code__c = null;
        SRT1.FailCode__c = null;
        SRT1.Fail_Code_Description__c = 'WUSSCB';
        SRT1.Type__c ='Field Action';
        lstSrt.add(SRT1);
        
        CSS_SRT__c SRT2 = new CSS_SRT__c();
        SRT2.CSS_Claims__c = claims.Id;
        srt2.SRT_AccessiblityCheck__c=TRUE;
        SRT2.Component_Id__c = solcomp.id; 
        SRT2.Account_Code__c = 'test';
        SRT2.FailCode__c = null;
         SRT2.Type__c ='Field Action';
        lstSrt.add(SRT2);
        
        
        CSS_SRT__c SRT3 = new CSS_SRT__c();
        SRT3.CSS_Claims__c = claims.Id;
        srt3.SRT_AccessiblityCheck__c=TRUE;
        SRT3.Component_Id__c = solcomp.id;
        SRT3.ODM_Status__c = 'YTBV';
        SRT3.Account_Code__c = 'test';
        SRT3.FailCode__c = null;
         SRT3.Type__c ='Field Action';
        lstSrt.add(SRT3);
        
        CSS_SRT__c SRT4 = new CSS_SRT__c();
        SRT4.CSS_Claims__c = claims.Id;
        srt4.SRT_AccessiblityCheck__c=TRUE;
        SRT4.Component_Id__c = solcomp.id; 
        SRT4.Account_Code__c = null;
        SRT4.FailCode__c = null;
        SRT4.Fail_Code_Description__c = 'THAC-Turbocharge Actuator';
         SRT4.Type__c ='Field Action';
        lstSrt.add(SRT4);
        
        CSS_SRT__c SRT5 = new CSS_SRT__c();
        SRT5.CSS_Claims__c = claims.Id;
        srt5.SRT_AccessiblityCheck__c=TRUE;
        SRT5.Component_Id__c = solcomp.id;
        SRT5.ODM_Status__c = 'YTBV';
        SRT5.Account_Code__c = 'test';
        SRT5.FailCode__c = null;
        SRT5.Type__c ='Field Action';
        lstSrt.add(SRT5);
        
        CSS_SRT__c SRT6 = new CSS_SRT__c();
        SRT6.CSS_Claims__c = claims.Id;
        srt6.SRT_AccessiblityCheck__c=TRUE;
        SRT6.Component_Id__c = solcomp.id; 
        SRT6.Account_Code__c = null;
        SRT6.FailCode__c = null;
        SRT6.Fail_Code_Description__c = 'THACEB-Turbocharge Actuator';
        SRT6.Type__c ='Field Action';
        lstSrt.add(SRT6);
        
        CSS_SRT__c SRT7 = new CSS_SRT__c();
        SRT7.CSS_Claims__c = claims.Id;
        srt7.SRT_AccessiblityCheck__c=TRUE;
        SRT7.Component_Id__c = solcomp.id; 
        SRT7.Account_Code__c = 'NEW PARTS WARRANTY 62';
        SRT7.FailCode__c =null;
        SRT7.Fail_Code_Description__c = 'test';
        SRT7.Type__c ='Field Action';
        lstSrt.add(SRT7);
        
        insert lstSrt;
        system.debug('lstSrt'+lstSrt);
        
        
        PageReference pageRef = Page.CG_ClaimsVS;
        Test.setCurrentPage(pageRef); 
        apexpages.currentPage().getparameters().put('id',claims.Id);
        
        test.startTest();
        CG_CL_ClaimsVS VS = new CG_CL_ClaimsVS();
        VS.exchangeRate=1.33;
        Vs.claimsSCList = lstsolcomp;
        Vs.claimsSRTList = lstSrt;
        VS.getMultiPSN();
        vs.fetchClaimRelatedRecords();
        VS.fetchAccountFailCodeCombo();
         Map<String,List<CSS_SRT__c>> overlapSRTListMap = new Map<String,List<CSS_SRT__c>>();
         overlapSRTListMap.put(srt1.id,lstSRT);
          
        vs.overlapSRTListMap=overlapSRTListMap;
        VS.generateClaimSubmissionRecords();
        test.stopTest();
        
    }
    
    public static testmethod void testOnDealerUSerType(){
        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.ESN__c='79464646';
        insert jo;
        
        css_claims__c claims = new css_claims__C();
        claims.Customer_Name__c='Oliver Trucking';
        claims.CSS_Job__c = jo.Id;
        claims.Account__c = acc.id;
        claims.Pending_Authorization__c = 'Authorization Required';
        claims.Information_Only_Claim__c = true;
        insert claims;
        
        css_psn__c psn1 = new css_psn__c();
        psn1.CSS_Claims__c=claims.Id;
        psn1.PSN__c='79464646';
        psn1.Primary__c=true;
        insert psn1;
        
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.CSS_Claims__c=claims.id;
        solcomp.System_Code__c='te';
        solcomp.Component_Code__c='st';
        solcomp.Failure_Mode__c = '3I';
        
        solComp.AccountCodeEdit__c = 'NEW PARTS WARRANTY 62';
        solcomp.Fail_Code_Editable__c='test-TEST';
        solcomp.Type__c= null;
        solcomp.Selected_Component__c = true;
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        solcomp1.CSS_Claims__c=claims.id;
        solcomp1.System_Code__c='te';
        solcomp1.Component_Code__c='st';
        solcomp1.Failure_Mode__c = '3I';
        
        solComp1.AccountCodeEdit__c = 'NEW PARTS WARRANTY 62';
        solcomp1.Fail_Code_Editable__c='test-TEST';
        solcomp1.Type__c= null;
        solcomp.Selected_Component__c = true;
        lstsolcomp.add(solcomp1);
        insert lstsolcomp;
        
        
        apexpages.currentPage().getparameters().put('id',claims.Id);
        
        test.startTest();
        CG_CL_ClaimsVS VS = new CG_CL_ClaimsVS();
        Currency_Conversion__c obj = new Currency_Conversion__c();
        obj.Bolt_To_Currency__c = 'USD';
        insert obj;
        VS.exchangeRate=1.33;
        boolean showSubmitbtnvalues = true;
        VS.userType = 'DLR';
        Vs.accCodeSelected = 'EMISSION WARRANTY 70';
        VS.pendingAuthrizationFlag();
        VS.showSubmitbtn();
        VS.SubmitClaim();
        test.stopTest();
    }
    
    public static testmethod void testOnSubmit(){   
        
        css_claims__c claims1 = new css_claims__C();
        claims1.Customer_Name__c='Oliver Trucking';
        insert claims1;
        
        css_psn__c psn2 = new css_psn__c();
        psn2.CSS_Claims__c=claims1.Id;
        psn2.PSN__c='79464646';
        psn2.License_Plate_State__c = 'Select One';
        psn2.Primary__c=true;
        insert psn2;
        
        apexpages.currentPage().getparameters().put('id',claims1.Id);
        
        test.startTest();
        CG_CL_ClaimsVS VS = new CG_CL_ClaimsVS();
        VS.exchangeRate=1.33;
        Vs.accCodeSelected = 'EMISSION WARRANTY 70';
        VS.SubmitClaim();
        test.stopTest();
    }
    
    public static testmethod void TestOnshowSubmitButton(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.ESN__c='79464646';
        insert jo;
        
        css_claims__c claims = new css_claims__C();
        claims.CSS_Job__c = jo.id;
        claims.Customer_Name__c = 'Oliver Trucking';
        claims.Mutual_Exclusive_Message__c = null;
        claims.SRT_Olap_Reason_Msg__c = null;
        Claims.Multi_PSN_Claim__c = true;
        claims.Actual_Technician_Time__c = 2.0;
        insert claims;
        
        
        list<css_psn__c> psnList = new list<css_psn__c>();
        css_psn__c psn1 = new css_psn__c();
        psn1.CSS_Claims__c = claims.Id;
        psn1.PSN__c = '53467987';
        psnList.add(psn1);
        
        css_psn__c psn2 = new css_psn__c();
        psn2.CSS_Claims__c = claims.Id;
        psn2.PSN__c = '79464646';
        psnList.add(psn2);
        insert psnList;
        
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.CSS_Claims__c=claims.id;
        solcomp.Pay_Code__c= 'A';
        solcomp.System_Code__c='te';
        solcomp.Component_Code__c='st';
        solcomp.Failure_Mode__c =  null;
        solComp.AccountCodeEdit__c = 'NEW PARTS WARRANTY 62';
        solcomp.Fail_Code_Editable__c='test-TEST';
        //solcomp.Type__c= null;
        solcomp.OldSolCompID__c = '101';
        solcomp.Selected_Component__c = true;
        lstsolcomp.add(solcomp);
        insert lstsolcomp;    
        
        PageReference pageRef = Page.CG_ClaimsVS;
        Test.setCurrentPage(pageRef); 
        apexpages.currentPage().getparameters().put('id',claims.Id);
        
        test.startTest();
        CG_CL_ClaimsVS VS = new CG_CL_ClaimsVS();
        VS.exchangeRate=1.33;
        VS.warrantyAuthFlag = 'G';
        Vs.pendingAuthFlag = true;
        Vs.psncheck = true;
        VS.showSubmitbtn();
        test.stopTest();
    }
    
    public static testmethod void TestOngetOverlapSRTMap(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        css_claims__c claims = new css_claims__C();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c = acc.id;
        claims.ODM_Penalty__c = '25';
        insert claims;
        
        css_psn__c psn1 = new css_psn__c();
        psn1.CSS_Claims__c=claims.Id;
        psn1.PSN__c='79464646';
        psn1.Primary__c=true;
        insert psn1;
        
        
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.CSS_Claims__c=claims.id;
        solcomp.System_Code__c='te';
        solcomp.Component_Code__c='st';
        solcomp.Failure_Mode__c =  null;
        solComp.AccountCodeEdit__c = 'NEW PARTS WARRANTY 62';
        solcomp.Fail_Code_Editable__c='test-TEST';
        //solcomp.Type__c= null;
        solcomp.OldSolCompID__c = '101';
        solcomp.Selected_Component__c = true;
        lstsolcomp.add(solcomp);
        insert lstsolcomp;
        
        
        
        List<CSS_SRT__c> lstsrt= new  List<CSS_SRT__c>();
        CSS_SRT__c SRT1 = new CSS_SRT__c();
        SRT1.CSS_Claims__c = claims.Id;
        srt1.SRT_AccessiblityCheck__c=TRUE;
        SRT1.Component_Id__c = solcomp.id; 
        SRT1.Account_Code__c = 'AB CD';
        SRT1.Override__c = true;
        SRT1.Type__c = 'Overlap';
        SRT1.Overlap_SRT_Number__c = '1';
        SRT1.SRT_Warrantable__c = '110';
        SRT1.SRT_ID__c = '2';
        lstSrt.add(SRT1);
        
        CSS_SRT__c SRT2 = new CSS_SRT__c();
        SRT2.CSS_Claims__c = claims.Id;
        srt2.SRT_AccessiblityCheck__c=TRUE;
        SRT2.Component_Id__c = solcomp.id; 
        SRT2.Account_Code__c = null;
        SRT2.Override__c = true;
        SRT2.Type__c = 'Overlap';
        SRT2.Overlap_SRT_Number__c = '1';
        SRT2.SRT_Warrantable__c = '110';
        SRT2.SRT_ID__c = '2';
        lstSrt.add(SRT2);
        insert lstSRt; 
        
        
        List<CSS_JobEventTemporary__c> jETList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jET = new CSS_JobEventTemporary__c();
        jET.Attribute1__c = 'POL';
        jET.Attribute2__c = 'AB';
        jET.Attribute3__c = 'CD';
        jET.Attribute4__c = 'DSBDV5789';
        jET.Key__c = 'AccountCodes';
        jETList.add(jET);
        insert jETList;        
        
        
        PageReference pageRef = Page.CG_ClaimsVS;
        Test.setCurrentPage(pageRef); 
        apexpages.currentPage().getparameters().put('id',claims.Id);
        
        test.startTest();
        Currency_Conversion__c obj = new Currency_Conversion__c();
        obj.Bolt_To_Currency__c = 'USD';
        insert obj;
        CG_CL_ClaimsVS VS = new CG_CL_ClaimsVS();
        vs.exchangeRate=1.33;
        Boolean showSubmitbtnvalues = true;
        VS.getOverlapSRTMap();
        Vs.updateSRTforPenalty();
        Vs.showSubmitbtn();
        test.stopTest();
        
    }
    
    public static testmethod void Testduplicatesrecords(){
        
        CG_CL_ClaimsVS VS = new CG_CL_ClaimsVS();
        vs.exchangeRate=1.33;
        
        Map<String, List<CG_CL_ClaimsVS.fieldActionSRTsWrapperClass>> FASRTsWrapList = new Map<String, List<CG_CL_ClaimsVS.fieldActionSRTsWrapperClass>> ();
        List<CG_CL_ClaimsVS.fieldActionSRTsWrapperClass> tempList = new List<CG_CL_ClaimsVS.fieldActionSRTsWrapperClass>();
        FASRTsWrapList.put('Oil Leak',new List<CG_CL_ClaimsVS.fieldActionSRTsWrapperClass>{ new CG_CL_ClaimsVS.fieldActionSRTsWrapperClass ('Oil Leak','test','test','test','test','test','5','test','10','test','test','test','test','test','test','test','test','test','test','test','test','test','test', 'test', 'test',true)  });
        VS.checkDuplicateFASRTs('Test FailCode',FASRTsWrapList);
        
        FASRTsWrapList = new Map<String, List<CG_CL_ClaimsVS.fieldActionSRTsWrapperClass>> ();
        FASRTsWrapList.put('Oil Leak1',new List<CG_CL_ClaimsVS.fieldActionSRTsWrapperClass>{ new CG_CL_ClaimsVS.fieldActionSRTsWrapperClass ('Oil Leak','test','test','test','test','test','5','test','10','test','test','test','test','test','','test','test','test','test','test','test','test','test', 'test', 'test',true) , 
            new CG_CL_ClaimsVS.fieldActionSRTsWrapperClass ('Oil Leak','test','test','test','test','test','5','test','10','test','test','test','test','test','Repair','test','test','test','test','test','test','test','test', 'test', 'test',false)  ,
            new CG_CL_ClaimsVS.fieldActionSRTsWrapperClass ('Oil Leak','test','test','test','test','test','5','test','10','test','test','test','test','test','Diagnostic','test','test','test','test','test','test','test','test', 'test', 'test',false)  });
        VS.checkDuplicateFASRTs('Test FailCode',FASRTsWrapList);
        
        Map<String, List<CG_CL_ClaimsVS.SRTsWrapperClass>> SRTsWrapList = new Map<String, List<CG_CL_ClaimsVS.SRTsWrapperClass>> ();
        SRTsWrapList.put('Test Code', new List<CG_CL_ClaimsVS.SRTsWrapperClass>{new CG_CL_ClaimsVS.SRTsWrapperClass ('Test','Test','Test','Test','Test','10','Test','10','Test','Test','Test','Test','Test', 'Repair','Test','Test','Test','Test','Test','Test','Test','Test','Test','Test',true)} );
        vs.checkDuplicateSRTs('Test Fail Code',SRTsWrapList);
        
        SRTsWrapList = new Map<String, List<CG_CL_ClaimsVS.SRTsWrapperClass>> ();
        SRTsWrapList.put('Test Code', new List<CG_CL_ClaimsVS.SRTsWrapperClass>{
            
            new CG_CL_ClaimsVS.SRTsWrapperClass ('Test','Test','Test','Test','Test','10','Test','10','Test','Test','Test','Test','Test', '','Test','Test','Test','Test','Test','Test','Test','Test','Test','Test',true),
                new CG_CL_ClaimsVS.SRTsWrapperClass ('Test','Test','Test','Test','Test','10','Test','10','Test','Test','Test','Test','Test', 'Repair','Test','Test','Test','Test','Test','Test','Test','Test','Test','Test',false),
                new CG_CL_ClaimsVS.SRTsWrapperClass ('Test','Test','Test','Test','Test','10','Test','10','Test','Test','Test','Test','Test', 'Diagnostic','Test','Test','Test','Test','Test','Test','Test','Test','Test','Test',true)
                
                } );
        
        vs.checkDuplicateSRTs('Test Fail Code',SRTsWrapList);
        vs.getCoverageType('Sample Accountcode');
        vs.userType=null;
        vs.pendingAuthrizationFlag();
        vs.displayEdit=null;
        vs.displayEditfunctioanity();
        vs.cId=null;
        vs.updateSRTforPenalty();
        vs.updateClaimRecord();
        vs.nvClaimsVS();
        
        // List<partsWrapperClass> = CG_CL_ClaimsVS.checkDuplicateParts();
        //List<otherClaimWrapperClass> =checkDuplicateOCs();
        //List<SRTsWrapperClass> =checkDuplicateSRTs();
    }
    /*public static testmethod void getMultiPSNMethod(){
Test.startTest();
CSS_Claims__c claims = CSS_TestData.createclaims(true,null);
CSS_Claims__c claims1 = [select id from CSS_Claims__c limit 1];
claims.Status__c='Draft';
claims.ESN__c='79462880';
claims.Customer_Name__c='BRITESTONE COLONY';
claims.Customer_Code__c='123';
claims.Location_Code__c='12345-12345';
insert claims;
List<CSS_Solution_Component__c> sollist = new List<CSS_Solution_Component__c>();     
CSS_Solution_Component__c sol = new CSS_Solution_Component__c();
sol.CSS_Claims__c = claims.Id;
sol.Selected_Component__c = true;
sol.Type__c = 'Campaign';
sol.Status__c = 'Approved';
//sol.AccountCodeEdit__c = '62';
//sol.AccountCode__c = '62';
insert sol;
sollist.add(sol); 
CG_CL_ClaimsVS VS = new CG_CL_ClaimsVS();
vs.getMultiPSN();
Test.stopTest();

}*/
    public static testmethod void testforverifySubmitpgAction111(){
        
        user u = css_testdata.createTestUser(false);
        u.Username='TestUser.ra@cummins.com';
        u.Email='TestUser.ra@cummins.com';
        u.User_Location__c='56354-53426';
        insert u;
        
        system.runAs(u)
        {
            Group Q = new Group();
            Q.Type = 'Queue';
            //Q.OwnerId=objUser1.id;
            Q.Name = 'CQ'+'-'+'56354-53426';
            insert Q;
            QueueSObject q1 = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=Q.Id);
            insert q1;
            
            css_job_order__c jo = new css_job_order__c();
            jo.Customer_Name__c='TestUser';
            jo.Customer_Code__c='123';
            jo.ESN__c='53467987';
            insert jo;
            Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc; 
            css_claims__c claims1= new css_claims__C();
            claims1.Customer_Code__c='123';
            claims1.Customer_Name__c='TestUser';
            claims1.Account__c = acc.id;
            claims1.CSS_Job__c=jo.Id;
            claims1.CoverageResponse__c='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "100000", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "EMS-Emissions Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
            claims1.Status__c='Draft';
            claims1.Location_Code__c='56354-53426';
            claims1.ownerId=u.id;
            insert claims1; 
            
            date d1 = date.parse('10/10/17');
            css_claims__c claims2=[select id,Status__c,createddate from css_claims__c limit 1];
            test.setCreatedDate(claims2.Id, d1);
            system.debug('Created Date'+claims2.createddate);
            
            css_claims__c claims3=[select id,Status__c,createddate from css_claims__c limit 1];
            system.debug('Created Date'+claims3.createddate);   
            
            css_psn__c psn1 = new css_psn__c();
            psn1.CSS_Claims__c=claims1.Id;
            psn1.PSN__c='53467987';
            psn1.Primary__c=true;
            insert psn1;
            
            css_solutions__c sol = new css_solutions__c();
            sol.Service_Job__c=jo.Id;
            //sol.FSL_Service_Job__c=jo.Id;
            insert sol;
            
            css_solution_Component__c solcomp = new css_solution_component__c();
            solcomp.Name='Testing';
            solcomp.AccountCodeEdit__c='SERVICE TOOL WARRANTY 52';
            solcomp.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp.Selected_Component__c=true;
            solcomp.System_Code__c='WE';
            solcomp.Component_Code__c='QP';
            solcomp.Failure_Mode__c='EZ';
            solcomp.CSS_Claims__c=claims1.id;
            solcomp.Solutions__c=sol.Id;
            solcomp.Service_Job__c=jo.Id;
            solcomp.Type__c='Campaign';
            solcomp.Status__c='Approved';
            solcomp.Complete_Indicator__c=true;
            solcomp.Multiple_Times__c=true;
            insert solcomp;
            
            css_solution_Component__c solcomp1 = new css_solution_component__c();
            solcomp1.Name='Testing';
            solcomp1.AccountCodeEdit__c='SERVICE TOOL WARRANTY 52';
            solcomp1.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp1.Selected_Component__c=true;
            solcomp1.System_Code__c='WE';
            solcomp1.Component_Code__c='QP';
            solcomp1.Failure_Mode__c='EZ';
            solcomp1.CSS_Claims__c=claims1.id;
            solcomp1.Solutions__c=sol.Id;
            solcomp1.Service_Job__c=jo.Id;
            solcomp1.Type__c='TRP';
            solcomp1.Status__c='Approved';
            solcomp1.Complete_Indicator__c=true;
            solcomp1.Multiple_Times__c=true;
            insert solcomp1;
            
            css_solution_Component__c solcomp2 = new css_solution_component__c();
            solcomp2.Name='Testing';
            solcomp2.AccountCodeEdit__c='SERVICE TOOL WARRANTY 52';
            solcomp2.Fail_Code_Editable__c='Testing-WEQPEZ';
            solcomp2.Selected_Component__c=true;
            solcomp2.System_Code__c='WE';
            solcomp2.Component_Code__c='QP';
            solcomp2.Failure_Mode__c='EZ';
            solcomp2.CSS_Claims__c=claims1.id;
            solcomp2.Solutions__c=sol.Id;
            solcomp2.Service_Job__c=jo.Id;
            solcomp2.Type__c='ATC';
            solcomp2.Status__c='Approved';
            solcomp2.Complete_Indicator__c=true;
            solcomp2.Multiple_Times__c=true;
            insert solcomp2;
            
            CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
            solcomp3.Name = 'solcomp3';
            solcomp3.CSS_Claims__c=claims1.id;
            solcomp3.Solutions__c=sol.Id;
            solcomp3.Service_Job__c=jo.Id;
            solcomp3.System_Code__c='FH';
            solcomp3.Component_Code__c='AS';
            solcomp3.Failure_Mode__c='BT';
            solcomp3.AccountCode__c = 'SERVICE TOOL WARRANTY 52';
            solcomp3.Type__c = 'Campaign';
            solcomp3.Selected_Component__c = true;
            solcomp3.Status__c='Approved';
            solcomp3.CoverageLimitExceedMsg_Status__c = 'ERROR';
            solcomp3.CoverageTravelBaseFareMsgTstatus__c = 'ERROR';
            solcomp3.AccountCode_Call_Status__c = 'Failure';
            solcomp3.CoverageLimitExceedMsgSRT_Status__c ='ERROR';
            insert solcomp3;    
            
            RecordType rtbms = [SELECT id,Name 
                                FROM RecordType 
                                WHERE name='BMS Parts'];
            
            RecordType rtp = [SELECT id,Name 
                              FROM RecordType 
                              WHERE name='Parts']; 
            
            RecordType rtOC = [SELECT id,Name 
                               FROM RecordType 
                               WHERE name='OtherClaimables'];                    
            
            RecordType rtTTML = [SELECT id,Name 
                                 FROM RecordType 
                                 WHERE name='TTML'];
            
            CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
            partop.CSS_Claims__c=claims1.id;
            partop.FailurepartId__c=solcomp.Id;
            partop.selected_part__c=true;
            partop.Fail_Code__c='WEQPEZ';
            partop.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop.Quantity__c= 0;
            partop.Unit_Price__c = '10';
            partop.recordtypeid = rtbms.id;
            partop.Covered__c = 100;
            insert partop;
            
            CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
            partop1.CSS_Claims__c=claims1.id;
            partop1.FailurepartId__c=solcomp1.Id;
            partop1.selected_part__c=true;
            partop1.Fail_Code__c='WEQPEZ';
            partop1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop1.Quantity__c=null;
            partop1.BMS_Quantity__c=1.0;
            partop1.Covered__c=10.87;
            partop1.recordtypeid = rtp.id;
            insert partop1;
            
            CSS_Parts_Options__c partop2 = new CSS_Parts_Options__c();
            partop2.CSS_Claims__c=claims1.id;
            partop2.FailurepartId__c=solcomp2.Id;
            partop2.selected_part__c=true;
            partop2.Fail_Code__c='WEQPEZ';
            partop2.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop2.recordtypeid = rtOC.id;
            partop2.Quantity__c=2.0;
            partop2.BMS_Quantity__c=1.0;
            insert partop2;
            
            CSS_Parts_Options__c partop3 = new CSS_Parts_Options__c();
            partop3.CSS_Claims__c=claims1.id;
            partop3.FailurepartId__c=solcomp2.Id;
            partop3.selected_part__c=true;
            partop3.Fail_Code__c='WEQPEZ';
            partop3.Account_Code__c='SERVICE TOOL WARRANTY 52';
            partop3.recordtypeid = rtTTML.id;
            partop3.Quantity__c=2.0;
            partop3.BMS_Quantity__c=1.0;
            insert partop3;        
            
            list<CSS_SRT__c> lstSRT = new  list<CSS_SRT__c>();
            CSS_SRT__c srt1 = new CSS_SRT__c();
            srt1.FailCode__c='WEQPEZ';
            srt1.Account_Code__c='SERVICE TOOL WARRANTY 52';
            srt1.SRT_AccessiblityCheck__c=TRUE;
            srt1.CSS_Claims__c=claims1.Id;
            srt1.Type__c='Field Action';
            insert srt1;
            lstSRT.add(srt1);
            /*  CSS_SRT__c srt11 = new CSS_SRT__c();
srt11.FailCode__c='WEQPEZ';
srt11.Account_Code__c='SERVICE TOOL WARRANTY 52';
srt11.SRT_AccessiblityCheck__c=TRUE;
srt11.CSS_Claims__c=claims1.Id;
srt11.Type__c='99Time';
insert srt11;
lstSRT.add(srt11);*/
            
            PageReference pageRef = Page.CG_ClaimsVS;
            pageRef.getParameters().put('id', claims1.id);
            Test.setCurrentPage(pageRef); 
            user u1=new user();
            
            list<Note> ClaimNotesList=new list<Note>();  
            note not1 = new note();
            not1.Body='Testing';
            not1.ParentId=claims1.Id;
            not1.Title='Claims';
            insert not1;
            ClaimNotesList.add(not1);
            
            CSS_JobEventTemporary__c  jobevt = new CSS_JobEventTemporary__c ();
            jobevt.Reason__c='{"DataArea":{"Details":[{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LOSS - OVERFLOW","BusinessUnit":"EBU","ComplaintCode":"106","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"117","ActiveFlag":"Y"},{"Category":"Leak","Description":"EXHAUST LEAK","BusinessUnit":"EBU","ComplaintCode":"118","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SHUTS DOWN OR STALLS","BusinessUnit":"EBU","ComplaintCode":"205","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SURGES","BusinessUnit":"EBU","ComplaintCode":"212","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"LOW POWER","BusinessUnit":"EBU","ComplaintCode":"213","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"VIBRATION","BusinessUnit":"EBU","ComplaintCode":"401","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"INOPERATIVE COMPONENT","BusinessUnit":"EBU","ComplaintCode":"404","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE RUNS ROUGH","BusinessUnit":"EBU","ComplaintCode":"215","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"115","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"116","ActiveFlag":"Y"},{"Category":"Leak","Description":"COMPRESSION LEAK","BusinessUnit":"EBU","ComplaintCode":"120","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - RED","BusinessUnit":"EBU","ComplaintCode":"202","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE WILL NOT SHUT DOWN","BusinessUnit":"EBU","ComplaintCode":"211","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"CRUISE CONTROL","BusinessUnit":"EBU","ComplaintCode":"503","ActiveFlag":"Y"},{"Category":"Other","Description":"INSPECTION","BusinessUnit":"EBU","ComplaintCode":"603","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN AIR SYSTEM","BusinessUnit":"EBU","ComplaintCode":"121","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO NOISE","BusinessUnit":"EBU","ComplaintCode":"123","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL OUT EXHAUST","BusinessUnit":"EBU","ComplaintCode":"124","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL IN INTAKE","BusinessUnit":"EBU","ComplaintCode":"125","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - YELLOW","BusinessUnit":"EBU","ComplaintCode":"201","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT REACH RPM","BusinessUnit":"EBU","ComplaintCode":"206","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED HIGH","BusinessUnit":"EBU","ComplaintCode":"208","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"POOR THROTTLE RESPONSE","BusinessUnit":"EBU","ComplaintCode":"214","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HIGH BLOW-BY","BusinessUnit":"EBU","ComplaintCode":"408","ActiveFlag":"Y"},{"Category":"Other","Description":"REBUILD","BusinessUnit":"EBU","ComplaintCode":"602","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT COMPLETE","BusinessUnit":"EBU","ComplaintCode":"606","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"101","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT BUILD AIR OR BUILDS SLOWLY","BusinessUnit":"EBU","ComplaintCode":"122","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ROUGH IDLE","BusinessUnit":"EBU","ComplaintCode":"209","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLACK SMOKE","BusinessUnit":"EBU","ComplaintCode":"302","ActiveFlag":"Y"},{"Category":"Other","Description":"VOLTAGE (GENSET)","BusinessUnit":"EBU","ComplaintCode":"505","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"STARTER MOTOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"508","ActiveFlag":"Y"},{"Category":"Other","Description":"CAMPAIGN / TRP","BusinessUnit":"EBU","ComplaintCode":"601","ActiveFlag":"Y"},{"Category":"Other","Description":"FAILED EMISSION TEST","BusinessUnit":"EBU","ComplaintCode":"604","ActiveFlag":"Y"},{"Category":"Other","Description":"MAINTENANCE","BusinessUnit":"EBU","ComplaintCode":"605","ActiveFlag":"Y"},{"Category":"Other","Description":"TELEMATICS","BusinessUnit":"EBU","ComplaintCode":"990","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HARD START","BusinessUnit":"EBU","ComplaintCode":"203","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"204","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE MISFIRE","BusinessUnit":"EBU","ComplaintCode":"210","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ENGINE BRAKE MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"406","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BLOWING DIPSTCK OUT","BusinessUnit":"EBU","ComplaintCode":"407","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - NOT IN OIL","BusinessUnit":"EBU","ComplaintCode":"102","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"107","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"109","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE HIGH","BusinessUnit":"EBU","ComplaintCode":"112","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"113","ActiveFlag":"Y"},{"Category":"Leak","Description":"DEF LEAK","BusinessUnit":"EBU","ComplaintCode":"609","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED LOW","BusinessUnit":"EBU","ComplaintCode":"207","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WHITE SMOKE","BusinessUnit":"EBU","ComplaintCode":"301","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"NOISE IN ENGINE","BusinessUnit":"EBU","ComplaintCode":"402","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT CARRY LOAD (GENSET)","BusinessUnit":"EBU","ComplaintCode":"504","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN TOO FREQUENT","BusinessUnit":"EBU","ComplaintCode":"608","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"103","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"108","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"114","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLUE SMOKE","BusinessUnit":"EBU","ComplaintCode":"303","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE OVERSPEED","BusinessUnit":"EBU","ComplaintCode":"409","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BELT PROBLEM","BusinessUnit":"EBU","ComplaintCode":"410","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ALTERNATOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"507","ActiveFlag":"Y"},{"Category":"Other","Description":"OTHER - SEE TEXT FOR DESCRIPTION","BusinessUnit":"EBU","ComplaintCode":"999","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"607","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"104","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"105","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"110","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE LOW","BusinessUnit":"EBU","ComplaintCode":"111","ActiveFlag":"Y"},{"Category":"Leak","Description":"AIR LEAK","BusinessUnit":"EBU","ComplaintCode":"119","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"NOISY COMPONENT","BusinessUnit":"EBU","ComplaintCode":"403","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"LOOSE OR BROKEN MOUNTING HARDWARE","BusinessUnit":"EBU","ComplaintCode":"405","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BREAKER TRIPPING","BusinessUnit":"EBU","ComplaintCode":"506","ActiveFlag":"Y"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
            jobevt.Attribute1__c='CategoryComplaintCodes';
            insert jobevt;
            //Map<String,String> overlapSRTListMap = new Map<String,String>();
            //overlapSRTListMap.put('srt1.id','Test');
            
            apexpages.currentPage().getparameters().put('id',claims1.Id);
            
            
            
            
            CG_CL_ClaimsVS vs = new CG_CL_ClaimsVS();
            vs.exchangeRate=1.33;
            //vs.userType  = 'DLR';
            vs.verifySubmitpgAction();
            //vs.overlapSRTListMap = overlapSRTListMap;
            vs.prepareSiebelRequest();
            vs.prepareBMSRequest();
            vs.checkQuantity();
            
        }
    }
    
     public static testmethod void testcheckDuplicateTTMLs(){
         
        
        List<Cg_Cl_Claimsvs.TTMLWrapperClass> lstttmlwrap = new List<Cg_Cl_Claimsvs.TTMLWrapperClass>();
        Cg_Cl_Claimsvs.TTMLWrapperClass ttmlwrap1 = new Cg_Cl_Claimsvs.TTMLWrapperClass('THAC','Commercial-Travel','John','200','100','Validaitonmessage','Pass','1','1','1','1','1','1','1','Traveltype','222','88','10','10','10','10','10','10','10','10','10');
        lstttmlwrap.add(ttmlwrap1);
       
        Cg_Cl_Claimsvs.TTMLWrapperClass ttmlwrap2 = new Cg_Cl_Claimsvs.TTMLWrapperClass('THAC','Non Commercial-Travel','John','200','100','Validaitonmessage','Pass','1','1','1','1','1','1','1','Traveltype','222','88','10','10','10','10','10','10','10','10','10');
        lstttmlwrap.add(ttmlwrap2);
        
        Cg_Cl_Claimsvs.TTMLWrapperClass ttmlwrap3 = new Cg_Cl_Claimsvs.TTMLWrapperClass('THAC','Meals','John','200','100','Validaitonmessage','Pass','1','1','1','1','1','1','1','Traveltype','222','88','10','10','10','10','10','10','10','10','10');
        lstttmlwrap.add(ttmlwrap3);
        
        Cg_Cl_Claimsvs.TTMLWrapperClass ttmlwrap4 = new Cg_Cl_Claimsvs.TTMLWrapperClass('THAC','Lodging','John','200','100','Validaitonmessage','Pass','1','1','1','1','1','1','1','Traveltype','222','88','10','10','10','10','10','10','10','10','10');
        lstttmlwrap.add(ttmlwrap4);
        
        Cg_Cl_Claimsvs.TTMLWrapperClass ttmlwrap5 = new Cg_Cl_Claimsvs.TTMLWrapperClass('THAC','Towing','John','200','100','Validaitonmessage','Pass','1','1','1','1','1','1','1','Traveltype','222','88','10','10','10','10','10','10','10','10','10');
        lstttmlwrap.add(ttmlwrap5);
        
        Map<String, List<Cg_Cl_Claimsvs.TTMLWrapperClass>> TTMLWrapList = new Map<String, List<Cg_Cl_Claimsvs.TTMLWrapperClass>>();
        TTMLWrapList.put('THAC',lstttmlwrap);
       
        Test.startTest(); 
        CG_CL_ClaimsVS VS = new CG_CL_ClaimsVS();
         vs.exchangeRate=1.33;
        vs.checkDuplicateTTMLs('THAC',TTMLWrapList);
        Test.stopTest();
        
    }
}