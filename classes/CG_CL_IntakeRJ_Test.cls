@isTest
public class CG_CL_IntakeRJ_Test {
    
    static testMethod void CG_CL_IntakeRJ_Test_TestMethod1() {        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
            JO.Customer_Name__c = 'Rajasekhar';
            JO.First_Name__c = 'hindu';
            JO.Application__c = 'Recreational Vehicle';
            JO.Model__c = 'RajTest';
            JO.Make__c = 'CSSTest';
            JO.Notes__c = 'CAMPCOMMENTS';
            JO.Failure_Point__c = 122;
            JO.Failure_Point_Measure__c = 'Miles';
            JO.VIN__c = '12345677890';
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.Before_In_Service__c = True;
            JO.Status__c = 'Repair Complete';
            //JO.Unit_Number__c = '12345';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.esn__c = '79464646';
            JO.Service_Model__c = 'model';
            JO.Unit_Type__c = 'type';
            JO.Sub_Type__c = 'sub type';
            Jo.Country__c = 'United States';
            Jo.CSS_State__c = 'Indiana';
            JO.Address__c = 'Bangalore';
            JO.ZipCode__c = '12345';
            JO.Primary_Segment__c = 'AG - AGRICULTURE';
            JO.CSS_Charge_Account_Status__c = 'charge';
            Jo.City__c = 'Columbus';
            JO.BMS_Last_Name__c = 'user';
            Jo.Customer_Code__c = '23456';
            Jo.EditComplaint__c = 'complaint';
            Jo.EditCoverage__c = 'coverage';
            Jo.EditCause__c = 'cause';
            Jo.EditCorrection__c = 'correction';
            JO.chevron_page__c = 'prt';
            JO.CSS_Resolution__c = 'Test';
            JO.DSID__c = 'VFD23';
            JO.Email_Address__c = 'prabhu@gmail.com';
            //JO.Sub_Status__c = 'Escalated';
            JO.Phone_Number__c = '9666666666';
            JO.Cstmr_Contacts_Phone__c = '8888888888';
            //JO.Previous_Status__c = 'intake';
            JO.Status__c = 'intake complete';
            JO.PSN_Not_Available__c = false;
            JO.Complaint_Type_Desc__c = 'null';
            JO.Category_Desc__c = 'test';
            JO.Contact_ID__c = 'wee';
            JO.Repair_Location__c = 'Mobile';
            JO.General_Symptoms__c = 'symptoms';
            JO.Shop_Work_Order__c = 'WO';
            JO.Mileage__c = 10.2;
            JO.Application_Desc__c = 'test58';
            Jo.Category_Desc__c='TEST';
            Jo.Category2_Desc__c='TEST';
            Jo.Category3_Desc__c='TEST';
            Jo.Category4_Desc__c='TEST';
            Jo.Category5_Desc__c='TEST';
            JO.Complaint_Type2_Desc__c = 'ggg';
            JO.Complaint_Type2_Desc__c = 'ttyy';
            JO.Complaint_Type3_Desc__c = 'bbb';
            JO.Complaint_Type4_Desc__c = 'fffh';
            JO.Complaint_Type5_Desc__c = 'coml';
            JO.CSS_Job_Location_Code__c = '56270-56255';
            JO.Mileage_Measure__c = 'mileage';
            JO.Failure_Point_Measure__c = 'failure';
            JO.ESN_Locked__c = true;
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.bmsCreateAccount__c = true;
            JO.Application__c = 'Fire Truck';
            JO.Customer_Code__c = null;
            JO.CSS_Job_Location_Code__c='56270-56255'; 
        //try{
          //  insert JO;
            //JO.Sub_Status__c = 'Estimate Needs Update';
            JO.Location_Certification__c = 'abcwer';
        insert JO;
            //JO.Unit_Number__c = '1234567';
        //update JO;
      //  }
//catch(Exception e){}
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Service_Job__c = JO.id;
        solcomp.Status__c = 'Approved';
        solcomp.Type__c = 'Campaign';
        solcomp.Complete_Indicator__c = true;
        solcomp.Multiple_Times__c = true;
        insert solcomp;
        
        system.debug('init no.>>>>'+JO.Unit_Number__c);
        //Record for Country State Values
        CSS_CountryStateValues__c countryState = new CSS_CountryStateValues__c();
        countryState.Name = 'USIN';
        countryState.CountryCode__c = 'United States';
        countryState.CountryName__c = 'US';
        countryState.StateCode__c = 'Indiana';
        countryState.StateName__c = 'IN';
        insert countryState;
        //
        Note note = new Note();
        note.Title = 'CAMPCOMMENTS';
        note.ParentId = JO.Id;  
        note.Body = 'Bold';
        insert note;
        //
        list <CSS_CampTsbTrp__c> solutionList = new list < CSS_CampTsbTrp__c > ();
        CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                         Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false,
                                                         Performed_Review__c = false, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList.add(solRec);
        CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB14013368', URL__c = 'https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                          Type__c = 'TRP', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, 
                                                          Performed_Review__c = true, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList.add(solRec2);
        CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB1401689', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c = 'TSB', Doc_Title__c = 'xyzk', Cu_Language__c = 'xc', Performed__c = true, 
                                                          Performed_Review__c = false, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList.add(solRec1);
        CSS_CampTsbTrp__c solRec7 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB1401689', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c = 'ATC', Doc_Title__c = 'xyzk', Cu_Language__c = 'xc', Performed__c = true, 
                                                          Performed_Review__c = false, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList.add(solRec7);
        
        insert solutionList;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        CSS_JobEventTemporary__c je = CSS_TestData.createJobEventTempObj(false);
        String json = '{'+
            '  \"Details\": {'+
            '    \"ApplicationCode\": \"12345\",'+
            '    \"Description\": \"testing\",'+
            '    \"BusinessUnit\": \"GetAssessData\",'+
            '    \"AutomotiveFlag\": \"Fault Details Data sent successfully\",'+
            '    \"MarineFlag\": \"Fault Details Data sent successfully\",'+   
            '    \"ActiveFlag\": \"Y\",'+    
            '    \"DefaultUom\": \"Fault Details Data sent successfully\"'+     
            '  },'+
            '  \"Header\": {'+   
            '        \"ReturnCodeDescription\": \"Test\",'+
            '        \"Status\": \"completed\"'+
            '      }'+
            '}'; 
        String jsonCategory = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        string jsonResponse='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        je.Reason__c =  json;
        je.attribute1__c = 'ApplicationCodes';      
        insert je;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
list<account> lstAcc = new list<Account>();
            list<CSS_UserLocation__c> lstUsrLoc =new list<CSS_UserLocation__c>();
             Account a= new Account();
               a.name='Rtest';
               a.CSS_DistributorCode__c='56270';
               a.IAM_Service_Provider_Code__c='56270';
               a.BMS_Enabled__c = true;
               a.IAM_Service_Provider_Code__c = '56270';
               a.CMI_Account_Status__c = 'Active';
               
            lstAcc.add(a);
            Account a1= new Account();
               a1.name='Rtest';
               a1.CSS_DistributorCode__c='56271';
               a1.IAM_Service_Provider_Code__c='56271';
               a1.BMS_Enabled__c = true;
               a1.IAM_Service_Provider_Code__c = '56271';
               a1.CMI_Account_Status__c = 'Active';
            lstAcc.add(a1);
             Account a2= new Account();
               a2.name='Rtest';
               a2.CSS_DistributorCode__c='56272';
               a2.IAM_Service_Provider_Code__c='56272';
               a2.BMS_Enabled__c = false;
               a2.IAM_Service_Provider_Code__c = '56272';
               a2.CMI_Account_Status__c = 'Active';
            lstAcc.add(a2);
               insert lstAcc;
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=lstAcc[0].id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
CSS_UserLocation__c userLocation1 = new CSS_UserLocation__c(AccountId__c=lstAcc[1].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56271-56271');
            CSS_UserLocation__c userLocation2 = new CSS_UserLocation__c(AccountId__c=lstAcc[2].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56272-56272');
lstUsrLoc.add(userLocation);
            lstUsrLoc.add(userLocation1);
            lstUsrLoc.add(userLocation2);
            insert lstUsrLoc;
        
        //css_utility.setSessionVariables(JO.Creator_Location__c);
        css_utility.setSessionVariables(JO.CSS_Job_Location_Code__c);
        
        
        
        
        
        CSS_JobEventTemporary__c jeCategory = CSS_TestData.createJobEventTempObj(false);
        jeCategory.Reason__c =  jsonCategory;
        jeCategory.attribute1__c = 'CategoryComplaintCodes';      
        insert jeCategory;
        string scode3=css_utility.getCodes('Application Code','Fire Truck',null,null);
        CSS_DataExchange_Parent__c de = CSS_TestData.createDataExchangeParentRecords(true);
        //string scode3=css_utility.getCodes('Application Code','Fire Truck',null,null);
        
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        css_utility.validateEmail(JO.Email_Address__c);
        boolean Error = css_utility.CheckPhoneNoIsValid(JO.Phone_Number__c);
        boolean Error1 = css_utility.CheckPhoneNoIsValid(JO.Cstmr_Contacts_Phone__c);
        
        CG_CL_IntakeRJ ccirj = new CG_CL_IntakeRJ();
        ccirj.reqBooleanshop = false;
        ccirj.reqCusNumBoolean = false;
        ccirj.reqPhnnoBoolean = false;
        ccirj.reqPhnnototalchar = false;
        ccirj.reqFrstNamBoolean = false;
        ccirj.reqLastNamBoolean = false;
        ccirj.reqCstmrContactPhnBoolean = false;
        ccirj.reqCstmrContactPhntotalchar = false;
        ccirj.reqUNumBoolean = false;
        ccirj.reqAppBoolean = false;
        ccirj.reqMakeBoolean = false;
        ccirj.reqMdlBoolean = false;
        ccirj.reqCatBoolean = false;
        ccirj.reqComtypBoolean = false;
        ccirj.higherdateErrFlag = false;
        ccirj.reqBoolean = false;
     // ccirj.locationChangeValue = 'hhh';
       ccirj.userERPSystem = 'One BMS';
        ccirj.selectedLocation = '56271-56271';
        map<string,boolean> mapLocationBmsFlag11 = new map<string,boolean>() ;
        //mapLocationBmsFlag11.put(JO.Creator_Location__c, false);
        mapLocationBmsFlag11.put(JO.CSS_Job_Location_Code__c, false);
        mapLocationBmsFlag11.put(ccirj.selectedLocation, true);
        
        map<string,string> mapLocationBmsUrl2 = new map<string,string>();
        mapLocationBmsUrl2.put('key', 'value');
        ccirj.reqESNBoolean  = false;
        ccirj.locationChangeCounter = 0;
        ccirj.mapLocationBmsFlag = mapLocationBmsFlag11;
        ccirj.mapLocationBmsUrl = mapLocationBmsUrl2;
        //ccirj.selectedLocation = '56271-56271';
        ccirj.selectedoldLocation = 'hyddd';
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        ccirj.EmailAddress1 = 'xyz@cummins.com';
        ccirj.EmailAddress = 'zsss@cummins.com';
        ccirj.Cancel();
        ccirj.changeLocationOutcomes();
        ccirj.getLocationsName();
        ccirj.getApplication();
        ccirj.filterApplication = 'APPP';
        Test.setMock(HttpCalloutMock.class, new CSS_CustInboundMock());
        ccirj.bmsCustInbound();
        ccirj.userERPSystem = 'BMS Legacy';
        ccirj.reqEmailBoolean = true;
        ccirj.reqEmailBoolean = false;
        ccirj.reqEmailValidBoolean = false;
        ccirj.selectedSubStatusVal = 'escalated';
        ccirj.SubStatusPrevValue = 'intake';
        ccirj.locationChangeValue = 'hhh';
        ccirj.strBMSAccountMsg = 'msg';
        //ccirj.SubStatusPrevValue = 'intake';
        ccirj.reqUTBoolean = false;
        ccirj.reqSTBoolean = false;
        ccirj.reqEmailBoolean = false;
        ccirj.allFieldsValidate = false;
        ccirj.reqEmailValidBoolean = false;
        ccirj.disableAssignmentBtn = true;
        ccirj.bmsEnabled = true;
        ccirj.filterApplication = 'Application';
        ccirj.comm = 'body';
        ccirj.locationName = 'Bangalore';
        //ccirj.selectedLocation = 'North America';
        ccirj.getLocationsName();
        ccirj.concatenateStrings();
        ccirj.getLocationLabel('Bangalore');
        //CSS_WS_BMS.callUnitInbound(JO.Customer_Code__c,JO.Unit_Number__c,'unitDescription',JO.Model__c,JO.VIN__c,JO.Make__c,JO.Service_Model__c,JO.ESN__c,'engineFamily','applicationCode','miles','5678','60.0','4','21/02/2018','21/02/2018','application');
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        ccirj.callCreateWoAndUpdateComment();
        ccirj.BMSwarningMsg1 = 'warning';
        ccirj.BMSwarningMsg2 = 'warning';
        ccirj.getfail_measure();
        ccirj.setfail_measure('measure');
        ccirj.setmil_measure('trrr');
        ccirj.setfilterMake('make');
        ccirj.setfilterModel('model');
        ccirj.setfilterState('state');
        
        ccirj.getmil_measure();
        ccirj.getfilterMake();
        ccirj.getfilterModel();
        ccirj.getfilterState();
        ccirj.getfilterCategory();
        //ccirj.setfilterCategory('TestCategory');
        ccirj.getfilterCategory2();
        //ccirj.setfilterCategory2('TestCategory2');
        ccirj.getfilterCountry();
        ccirj.setfilterCountry('TestCategory3');
        //ccirj.getfilterCategory4();
        //ccirj.setfilterCategory4('TestCategory4');
        //ccirj.getfilterCategory5();
        //ccirj.setfilterCategory5('TestCategory5');
        
        ccirj.Wid = Wid;
        ccirj.pageAction();
        ccirj.redirectPopup();
        ccirj.pgSave();
        ccirj.closeSession();
        ccirj.nvIntakeCustomer();
        ccirj.nvIntakeUE();
        ccirj.nvIntakeCC();
        ccirj.nvIntakeVH();
        ccirj.nvIntakeWarranty();
        ccirj.getCountry();
        ccirj.getCamps();
        ccirj.getTrps();
        ccirj.getAtcs();
        ccirj.getTsbs();
        ccirj.saveCheckBox();
        ccirj.sendAdminSRTtoBMS();
        //Cache.Session.put('UserERPSystem', null);
        //ccirj.selectedSubStatusVal='';
      // ccirj.pgSaveAssign();
       
        ccirj.wid=null;
        ccirj.pageAction();
        ccirj.displayPopup=null;
        ccirj.redirectPopup();
        ccirj.pgSave();
        ccirj.nvIntakeCustomer();
        ccirj.nvIntakeUE();
        ccirj.nvIntakeCC();
        ccirj.nvIntakeVH();
        ccirj.nvIntakeWarranty();
        ccirj.CG_BL_IntakeObj=null;
        ccirj.getCountry();
        ccirj.getLocationsName();
        
        
        
        Test.stopTest();
        
    }
    static testmethod void method2(){
        Test.startTest();
        css_job_order__c JO1 = new CSS_Job_order__c();
        JO1.Shop_Work_Order__c='null';
        JO1.Customer_Name__c='Test';
        JO1.Phone_Number__c ='9999999999';
        JO1.Cstmr_Contacts_Phone__c='8888888888';
        JO1.BMS_Last_Name__c='TestLast';
        JO1.First_Name__c='FirstName';
        //jo1.Application_Desc__c = 'testdesc349';
        jo1.Customer_Code__c = '12345';
        jo1.Email_Address__c = 'abc123@gmail.com';
        jo1.ESN__c = '79464646';
        jo1.Make__c = 'null';
        jo1.Model__c = 'model';
        jo1.Category_Desc__c = 'desc';
        jo1.PSN_Not_Available__c = false;
        jo1.Unit_Number__c = '12345';
        jo1.Unit_Type__c = 'unittype';
        jo1.Sub_Type__c = 'subtype';
        jo1.Complaint_Type_Desc__c = 'complaintdesc';
        //jo1.Customer_Name__c = 'Prabhu';
        jo1.Application_Desc__c = 'appdesc';
        insert JO1;
                CSS_Job_Order__c workJob12 = [Select Id,Name,Customer_Name__c,Account__r.ERP_System__c,AccessCode__c, Creator_Location__c,CreatedDate,Date_In__c,JobLocation__c,CSS_Job_Location_Code__c,Complaint_Type4_Desc__c, Primary_Segment__c,Failure_Date__c,Failure_Point__c,IsAppointment__c,
                   Customer_Code__c,First_Name__c,TSR_EscalateNumber__c,CSS_Bms_ContactBoolean__c ,CSS_Charge_Account_Status__c,Available_Credit__c, Amount_Due__c, Credit_Limit__c, BMS_Last_Name__c,Email_Address__c,Complaint_Type3_Desc__c, VIN_Flag__c,previousESN_MultiLoc__c,Location_Certification__c,
                   Email_check_box__c ,bmsCreateAccount__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Preventive_Maintenance__c,Complaint_Type2_Desc__c,Qsol_Engine_Family_Code__c,Warranty_Authorization_Flag__c,
                   CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                   Address__c,City__c,ZipCode__c,Country__c,Category2_Desc__c,SP_Country__c, Category3_Desc__c,Category4_Desc__c,Category5_Desc__c ,Sub_Type__c,Application__c, Region__c,Territory__c,Before_In_Service__c,Contact_ID__c,
                   Category_Desc__c ,Complaint_Type_Desc__c,Expedited_Service__c ,Unit_Number__c ,Application_Desc__c,Make__c,Repair_Location__c,CSS_State__c ,BMSStatus__c,ApplicationCode__c,SP_ClaimAllowedDays__c,   
                   Status__c,LastModifiedDate,Repeat_Or_Recent_Calc__c,Shop_Work_Order__c,ESN__c,Service_Model__c,Model__c,VIN__c,Mileage__c,CSS_Hours__c,Unit_Type__c,Sub_Status__c, SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,    
                   General_Symptoms__c,Warranty_Start_Date__c,Mileage_Measure__c,Failure_Point_Measure__c,ESN_Locked__c,PSN_Not_Available__c,Date_in_Shop__c,ESN_IA__c , Complaint_Type5_Desc__c, Complaint_Type5__c, 
                   (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC)
                   from CSS_Job_Order__c limit 1];
        
        CG_CL_IntakeRJ rj = new CG_CL_IntakeRJ();
        rj.workJob=jo1;
        //rj.wid = wid;
        rj.userERPSystem='BMS Legacy';
        rj.workJob.Customer_Name__c='';
rj.validateBeforeSave();
rj.workJob.Customer_Name__c='test customer';

rj.workJob.Shop_Work_Order__c=null;
rj.isDealer=true;
rj.validateBeforeSave();
rj.workJob.Shop_Work_Order__c='test';
        rj.validateBeforeSave();
        rj.userERPSystem ='BMS Legacy';
        rj.workJob.Phone_Number__c = null;
         rj.validateBeforeSave();
        rj.workJob.Phone_Number__c = '949592234';
         rj.validateBeforeSave();
                rj.userERPSystem =' Test BMS Legacy';
        rj.validateBeforeSave();
                rj.userERPSystem ='BMS Legacy';
        rj.workJob.First_Name__c = null;
        rj.validateBeforeSave();
        rj.workJob.First_Name__c = 'Test Name';
        rj.workJob.BMS_Last_Name__c = null;
        rj.validateBeforeSave();
        rj.workJob.Cstmr_Contacts_Phone__c='';
        rj.validateBeforeSave();
        rj.workJob.Cstmr_Contacts_Phone__c='949592234';
        rj.validateBeforeSave();
        rj.workJob.Email_Address__c = null;
        rj.validateBeforeSave();
        rj.workJob.Email_Address__c = 'cummins';
        rj.validateBeforeSave();
         rj.workJob.Email_Address__c = 'cumminstest@gmail.com';
        rj.workJob.ESN__c=null;
rj.workjob.ESN_Locked__c = false;
        rj.workJob.PSN_Not_Available__c = false;
         rj.validateBeforeSave();
        rj.workJob.ESN__c='test';
        rj.workJob.Application_Desc__c  = null;
         rj.validateBeforeSave();
        rj.workJob.Application_Desc__c  = 'test';
        rj.workJob.Model__c=null;
        rj.validateBeforeSave();
        rj.workJob.Model__c='hyndai';
        rj.workJob.Model__c=null;
        rj.validateBeforeSave();
        rj.workJob.Model__c='2105';
        rj.workJob.Category_Desc__c = null;
        rj.validateBeforeSave();
        rj.workJob.Category_Desc__c = 'testdescription';
        rj.workJob.Unit_Number__c='';
        rj.validateBeforeSave();
        rj.workJob.Unit_Number__c='1045';
        rj.workJob.Unit_Type__c='';
         rj.validateBeforeSave();
        rj.workJob.Unit_Type__c='testtype';
        rj.workJob.Sub_Type__c='';
         rj.validateBeforeSave();
        rj.workJob.Sub_Type__c='testtype';
        rj.workJob.Complaint_Type_Desc__c = null;
         rj.validateBeforeSave();
        Test.stopTest();
       
       
    }
        static testmethod void method29(){
        css_job_order__c JO1 = new CSS_Job_order__c();
        JO1.Shop_Work_Order__c=null;
        JO1.Customer_Name__c='null';
       // JO1.Phone_Number__c ='9999999999';
        //JO1.Cstmr_Contacts_Phone__c='8888888888';
        JO1.BMS_Last_Name__c='TestLast';
        JO1.First_Name__c='FirstName';
        jo1.Application_Desc__c = 'null';
        jo1.Customer_Code__c = null;
        jo1.Email_Address__c = null;
        jo1.ESN__c = '79464646';
        jo1.ESN_Locked__c = true;
        jo1.PSN_Not_Available__c = true;
        jo1.Make__c = null;
            jo1.Model__c = null;
        insert JO1;
                CSS_Job_Order__c workJob12 = [Select Id,Name,Customer_Name__c,Account__r.ERP_System__c,AccessCode__c, Creator_Location__c,CreatedDate,Date_In__c,JobLocation__c,CSS_Job_Location_Code__c,Complaint_Type4_Desc__c, Primary_Segment__c,Failure_Date__c,Failure_Point__c,IsAppointment__c,
                   Customer_Code__c,First_Name__c,TSR_EscalateNumber__c,CSS_Bms_ContactBoolean__c ,CSS_Charge_Account_Status__c,Available_Credit__c, Amount_Due__c, Credit_Limit__c, BMS_Last_Name__c,Email_Address__c,Complaint_Type3_Desc__c, VIN_Flag__c,previousESN_MultiLoc__c,Location_Certification__c,
                   Email_check_box__c ,bmsCreateAccount__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Preventive_Maintenance__c,Complaint_Type2_Desc__c,Qsol_Engine_Family_Code__c,Warranty_Authorization_Flag__c,
                   CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                   Address__c,City__c,ZipCode__c,Country__c,Category2_Desc__c,SP_Country__c, Category3_Desc__c,Category4_Desc__c,Category5_Desc__c ,Sub_Type__c,Application__c, Region__c,Territory__c,Before_In_Service__c,Contact_ID__c,
                   Category_Desc__c ,Complaint_Type_Desc__c,Expedited_Service__c ,Unit_Number__c ,Application_Desc__c,Make__c,Repair_Location__c,CSS_State__c ,BMSStatus__c,ApplicationCode__c,SP_ClaimAllowedDays__c,   
                   Status__c,LastModifiedDate,Repeat_Or_Recent_Calc__c,Shop_Work_Order__c,ESN__c,Service_Model__c,Model__c,VIN__c,Mileage__c,CSS_Hours__c,Unit_Type__c,Sub_Status__c, SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,    
                   General_Symptoms__c,Warranty_Start_Date__c,Mileage_Measure__c,Failure_Point_Measure__c,ESN_Locked__c,PSN_Not_Available__c,Date_in_Shop__c,ESN_IA__c , Complaint_Type5_Desc__c, Complaint_Type5__c, 
                   (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC)
                   from CSS_Job_Order__c limit 1];
        ApexPages.CurrentPage().getParameters().put('id',jo1.id);
        CG_CL_IntakeRJ rj = new CG_CL_IntakeRJ();
        rj.workJob=jo1;
        rj.userERPSystem='One BMS';
        rj.validateBeforeSave();
       
       
    }
    static testmethod void method22(){
        css_job_order__c JO1 = new CSS_Job_order__c();
        JO1.Shop_Work_Order__c='null';
        JO1.Customer_Name__c='Test';
        JO1.Phone_Number__c ='9999999999';
        JO1.Cstmr_Contacts_Phone__c='8888888888';
        JO1.BMS_Last_Name__c='TestLast';
        JO1.First_Name__c='FirstName';
        jo1.Application_Desc__c = 'desccc';
        jo1.Customer_Code__c = '12345';
        jo1.Email_Address__c = 'abc123@gmail.com';
        jo1.ESN__c = '79464646';
        jo1.ESN_Locked__c = false;   
        jo1.PSN_Not_Available__c = false; 

        jo1.Make__c = null;
        jo1.Model__c = null;
        insert JO1;
                CSS_Job_Order__c workJob12 = [Select Id,Name,Customer_Name__c,Account__r.ERP_System__c,AccessCode__c, Creator_Location__c,CreatedDate,Date_In__c,JobLocation__c,CSS_Job_Location_Code__c,Complaint_Type4_Desc__c, Primary_Segment__c,Failure_Date__c,Failure_Point__c,IsAppointment__c,
                   Customer_Code__c,First_Name__c,TSR_EscalateNumber__c,CSS_Bms_ContactBoolean__c ,CSS_Charge_Account_Status__c,Available_Credit__c, Amount_Due__c, Credit_Limit__c, BMS_Last_Name__c,Email_Address__c,Complaint_Type3_Desc__c, VIN_Flag__c,previousESN_MultiLoc__c,Location_Certification__c,
                   Email_check_box__c ,bmsCreateAccount__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Preventive_Maintenance__c,Complaint_Type2_Desc__c,Qsol_Engine_Family_Code__c,Warranty_Authorization_Flag__c,
                   CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                   Address__c,City__c,ZipCode__c,Country__c,Category2_Desc__c,SP_Country__c, Category3_Desc__c,Category4_Desc__c,Category5_Desc__c ,Sub_Type__c,Application__c, Region__c,Territory__c,Before_In_Service__c,Contact_ID__c,
                   Category_Desc__c ,Complaint_Type_Desc__c,Expedited_Service__c ,Unit_Number__c ,Application_Desc__c,Make__c,Repair_Location__c,CSS_State__c ,BMSStatus__c,ApplicationCode__c,SP_ClaimAllowedDays__c,   
                   Status__c,LastModifiedDate,Repeat_Or_Recent_Calc__c,Shop_Work_Order__c,ESN__c,Service_Model__c,Model__c,VIN__c,Mileage__c,CSS_Hours__c,Unit_Type__c,Sub_Status__c, SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,    
                   General_Symptoms__c,Warranty_Start_Date__c,Mileage_Measure__c,Failure_Point_Measure__c,ESN_Locked__c,PSN_Not_Available__c,Date_in_Shop__c,ESN_IA__c , Complaint_Type5_Desc__c, Complaint_Type5__c, 
                   (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC)
                   from CSS_Job_Order__c limit 1];
        ApexPages.CurrentPage().getParameters().put('id',jo1.id);
        CG_CL_IntakeRJ rj = new CG_CL_IntakeRJ();
        rj.workJob=jo1;
        rj.userERPSystem='BMS Legacy';
        rj.validateBeforeSave();
       
       
    }
    static testmethod void method3(){
        CG_CL_IntakeRJ_Test_TestMethod1();
         css_job_order__c JO = new CSS_Job_order__c();
        css_job_order__c job = new CSS_Job_order__c();
        JO.id = job.id;
        job.Sub_Status__C = 'Work in Progress';
        job.Status__c = 'Intake Complete';
       // upsert job;
        CG_CL_IntakeRJ rj1 = new CG_CL_IntakeRJ();
              
        try{
            upsert job;

        }
        catch(Exception e){
            
        }
          rj1.pgSaveAssign();
       // PageReference PGW = rj1.pgSaveAssign();
       // String curl=pgw.getUrl();
       // system.assertequals(curl,'/apex/CSS_Job_Detail');
       
       
    }
   
    static testmethod void method4(){        
    css_job_order__c JO = new CSS_Job_order__c();
        JO.Customer_Name__c = null;
       // JO.Customer_Name__c = '';
        JO.ESN__c= null;
        JO.ESN__c= '';
        JO.ESN_Locked__c = false;
        JO.PSN_Not_Available__c = false;
        JO.Application_Desc__c  = 'TestPr';
        //JO.Application_Desc__c  = '----None----';
        JO.Make__c = null;
        JO.Make__c = '----None----';
        JO.Model__c = null;
        JO.Model__c = '----None----';
        JO.Category_Desc__c = null ;
        JO.Category_Desc__c = '';
        JO.Category_Desc__c = '----None----';
        JO.Unit_Number__c = '' ;
        JO.Unit_Number__c = null;
        JO.Unit_Number__c = '----None----';
        JO.Complaint_Type_Desc__c = null ;
        JO.Complaint_Type_Desc__c = '' ;
        JO.Complaint_Type_Desc__c = '----None----';
        //JO.Status__c = 'Closed';
        //JO.userERPSystem =='BMS Legacy';
        JO.Shop_Work_Order__c=null;
        JO.Phone_Number__c = null;
        JO.Customer_Code__c=null;
        insert JO;
        system.debug('JO*****'+JO);
        system.debug('JO.Shop_Work_Order__c*****'+JO.Shop_Work_Order__c);
        system.debug('JO.Customer_Name__c***'+JO.Customer_Name__c);
        CG_CL_IntakeRJ ccirj = new CG_CL_IntakeRJ();
        //ccirj.isDealer = true;
        ccirj.ChkFieldBlank();
        ccirj.closeSession();
        //ccirj.validateBeforeSave();
    }
     //Boolean isDealer = true;
    static testMethod void method6(){
         Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u1 = new User(Alias = 'standt1', Email='standarduser14@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser14@testorg.com',User_Location__c = 'location');
        insert u1;
       css_job_order__c JO1 = new CSS_Job_order__c();
        JO1.Shop_Work_Order__c=null;
        JO1.Shop_Work_Order__c='';
        JO1.Customer_Code__c=null;
        jo1.Customer_Name__c='Test';
        jo1.Application_Desc__c = 'applicatdesc';
        insert JO1;
        system.debug('JO*****'+JO1);
        system.debug('JO.Shop_Work_Order__c*****'+JO1.Shop_Work_Order__c);
        system.debug('JO.Customer_Name__c***'+JO1.Customer_Name__c);
        CSS_Job_Order__c workJob12 = [Select Id,Name,Customer_Name__c,Account__r.ERP_System__c,AccessCode__c, Creator_Location__c,CreatedDate,Date_In__c,JobLocation__c,CSS_Job_Location_Code__c,Complaint_Type4_Desc__c, Primary_Segment__c,Failure_Date__c,Failure_Point__c,IsAppointment__c,
                   Customer_Code__c,First_Name__c,TSR_EscalateNumber__c,CSS_Bms_ContactBoolean__c ,CSS_Charge_Account_Status__c,Available_Credit__c, Amount_Due__c, Credit_Limit__c, BMS_Last_Name__c,Email_Address__c,Complaint_Type3_Desc__c, VIN_Flag__c,previousESN_MultiLoc__c,Location_Certification__c,
                   Email_check_box__c ,bmsCreateAccount__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Preventive_Maintenance__c,Complaint_Type2_Desc__c,Qsol_Engine_Family_Code__c,Warranty_Authorization_Flag__c,
                   CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                   Address__c,City__c,ZipCode__c,Country__c,Category2_Desc__c,SP_Country__c, Category3_Desc__c,Category4_Desc__c,Category5_Desc__c ,Sub_Type__c,Application__c, Region__c,Territory__c,Before_In_Service__c,Contact_ID__c,
                   Category_Desc__c ,Complaint_Type_Desc__c,Expedited_Service__c ,Unit_Number__c ,Application_Desc__c,Make__c,Repair_Location__c,CSS_State__c ,BMSStatus__c,ApplicationCode__c,SP_ClaimAllowedDays__c,   
                   Status__c,LastModifiedDate,Repeat_Or_Recent_Calc__c,Shop_Work_Order__c,ESN__c,Service_Model__c,Model__c,VIN__c,Mileage__c,CSS_Hours__c,Unit_Type__c,Sub_Status__c, SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,    
                   General_Symptoms__c,Warranty_Start_Date__c,Mileage_Measure__c,Failure_Point_Measure__c,ESN_Locked__c,PSN_Not_Available__c,Date_in_Shop__c,ESN_IA__c , Complaint_Type5_Desc__c, Complaint_Type5__c, 
                   (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC)
                   from CSS_Job_Order__c limit 1];
        ApexPages.CurrentPage().getParameters().put('id',workJob12.id);
       //string userERPSystem = (string) Cache.Session.put('BMS Legacy','One BMS');
        CG_CL_IntakeRJ ccirj1 = new CG_CL_IntakeRJ();
        ccirj1.isDealer = true;
        ccirj1.userERPSystem='BMS Legacy';
        ccirj1.workJob=jo1;
        Boolean Error=true;
           //ccirj1.validateBeforeSave();
        system.debug('workJob.userERPSystem***--'+ccirj1.userERPSystem);
        system.debug('workJob.isDealer***--'+ccirj1.isDealer);
        ccirj1.ChkFieldBlank();
        ccirj1.closeSession();
     
        
    }
        static testMethod void method7(){
         Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u1 = new User(Alias = 'standt11', Email='standarduser114@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser114@testorg.com',User_Location__c = 'location');
        insert u1;
       css_job_order__c JO1 = new CSS_Job_order__c();
        JO1.Shop_Work_Order__c=null;
        JO1.Shop_Work_Order__c='';
        JO1.Customer_Name__c='Test';
            jo1.Application_Desc__c = 'Appdesc567';
        insert JO1;
        system.debug('JO*****'+JO1);
        system.debug('JO.Shop_Work_Order__c*****'+JO1.Shop_Work_Order__c);
        system.debug('JO.Customer_Name__c***'+JO1.Customer_Name__c);
        CSS_Job_Order__c workJob12 = [Select Id,Name,Customer_Name__c,Account__r.ERP_System__c,AccessCode__c, Creator_Location__c,CreatedDate,Date_In__c,JobLocation__c,CSS_Job_Location_Code__c,Complaint_Type4_Desc__c, Primary_Segment__c,Failure_Date__c,Failure_Point__c,IsAppointment__c,
                   Customer_Code__c,First_Name__c,TSR_EscalateNumber__c,CSS_Bms_ContactBoolean__c ,CSS_Charge_Account_Status__c,Available_Credit__c, Amount_Due__c, Credit_Limit__c, BMS_Last_Name__c,Email_Address__c,Complaint_Type3_Desc__c, VIN_Flag__c,previousESN_MultiLoc__c,Location_Certification__c,
                   Email_check_box__c ,bmsCreateAccount__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Preventive_Maintenance__c,Complaint_Type2_Desc__c,Qsol_Engine_Family_Code__c,Warranty_Authorization_Flag__c,
                   CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                   Address__c,City__c,ZipCode__c,Country__c,Category2_Desc__c,SP_Country__c, Category3_Desc__c,Category4_Desc__c,Category5_Desc__c ,Sub_Type__c,Application__c, Region__c,Territory__c,Before_In_Service__c,Contact_ID__c,
                   Category_Desc__c ,Complaint_Type_Desc__c,Expedited_Service__c ,Unit_Number__c ,Application_Desc__c,Make__c,Repair_Location__c,CSS_State__c ,BMSStatus__c,ApplicationCode__c,SP_ClaimAllowedDays__c,   
                   Status__c,LastModifiedDate,Repeat_Or_Recent_Calc__c,Shop_Work_Order__c,ESN__c,Service_Model__c,Model__c,VIN__c,Mileage__c,CSS_Hours__c,Unit_Type__c,Sub_Status__c, SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,    
                   General_Symptoms__c,Warranty_Start_Date__c,Mileage_Measure__c,Failure_Point_Measure__c,ESN_Locked__c,PSN_Not_Available__c,Date_in_Shop__c,ESN_IA__c , Complaint_Type5_Desc__c, Complaint_Type5__c, 
                   (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC)
                   from CSS_Job_Order__c limit 1];
        ApexPages.CurrentPage().getParameters().put('id',workJob12.id);
       //string userERPSystem = (string) Cache.Session.put('BMS Legacy','One BMS');
        CG_CL_IntakeRJ ccirj1 = new CG_CL_IntakeRJ();
        ccirj1.isDealer = false;
        //ccirj1.userERPSystem='BMS Legacy';
        ccirj1.workJob=JO1;
        Boolean Error=true;
           //ccirj1.validateBeforeSave();
        //system.debug('workJob.userERPSystem***--'+ccirj1.userERPSystem);
        system.debug('workJob.isDealer***--'+ccirj1.isDealer);
        //ccirj1.ChkFieldBlank();
        //ccirj1.closeSession();
     
        
    }
       static testMethod void method8(){
         Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u1 = new User(Alias = 'standt11', Email='standarduser114@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser114@testorg.com',User_Location__c = 'location');
        insert u1;
       css_job_order__c JO1 = new CSS_Job_order__c();
        JO1.Shop_Work_Order__c='null';
        //JO1.Phone_Number__c = null;
        JO1.Customer_Name__c='Test';
        JO1.Phone_Number__c ='9999999999';
        JO1.Cstmr_Contacts_Phone__c='8888888888';
           jo1.Application_Desc__c = 'testa';
        insert JO1;
        system.debug('JO*****'+JO1);
        system.debug('JO.Shop_Work_Order__c*****'+JO1.Shop_Work_Order__c);
        system.debug('JO.Customer_Name__c***'+JO1.Customer_Name__c);
        CSS_Job_Order__c workJob12 = [Select Id,Name,Customer_Name__c,Account__r.ERP_System__c,AccessCode__c, Creator_Location__c,CreatedDate,Date_In__c,JobLocation__c,CSS_Job_Location_Code__c,Complaint_Type4_Desc__c, Primary_Segment__c,Failure_Date__c,Failure_Point__c,IsAppointment__c,
                   Customer_Code__c,First_Name__c,TSR_EscalateNumber__c,CSS_Bms_ContactBoolean__c ,CSS_Charge_Account_Status__c,Available_Credit__c, Amount_Due__c, Credit_Limit__c, BMS_Last_Name__c,Email_Address__c,Complaint_Type3_Desc__c, VIN_Flag__c,previousESN_MultiLoc__c,Location_Certification__c,
                   Email_check_box__c ,bmsCreateAccount__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Preventive_Maintenance__c,Complaint_Type2_Desc__c,Qsol_Engine_Family_Code__c,Warranty_Authorization_Flag__c,
                   CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                   Address__c,City__c,ZipCode__c,Country__c,Category2_Desc__c,SP_Country__c, Category3_Desc__c,Category4_Desc__c,Category5_Desc__c ,Sub_Type__c,Application__c, Region__c,Territory__c,Before_In_Service__c,Contact_ID__c,
                   Category_Desc__c ,Complaint_Type_Desc__c,Expedited_Service__c ,Unit_Number__c ,Application_Desc__c,Make__c,Repair_Location__c,CSS_State__c ,BMSStatus__c,ApplicationCode__c,SP_ClaimAllowedDays__c,   
                   Status__c,LastModifiedDate,Repeat_Or_Recent_Calc__c,Shop_Work_Order__c,ESN__c,Service_Model__c,Model__c,VIN__c,Mileage__c,CSS_Hours__c,Unit_Type__c,Sub_Status__c, SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,    
                   General_Symptoms__c,Warranty_Start_Date__c,Mileage_Measure__c,Failure_Point_Measure__c,ESN_Locked__c,PSN_Not_Available__c,Date_in_Shop__c,ESN_IA__c , Complaint_Type5_Desc__c, Complaint_Type5__c, 
                   (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC)
                   from CSS_Job_Order__c limit 1];
        ApexPages.CurrentPage().getParameters().put('id',workJob12.id);
       //string userERPSystem = (string) Cache.Session.put('BMS Legacy','One BMS');
        CG_CL_IntakeRJ ccirj1 = new CG_CL_IntakeRJ();
        ccirj1.isDealer = false;
        //ccirj1.userERPSystem='BMS Legacy';
        ccirj1.workJob=JO1;
        Boolean Error=true;
           //ccirj1.validateBeforeSave();
        //system.debug('workJob.userERPSystem***--'+ccirj1.userERPSystem);
        system.debug('workJob.isDealer***--'+ccirj1.isDealer);
        //ccirj1.ChkFieldBlank();
        //ccirj1.closeSession();
     
        
    }
    
      static testMethod void CG_CL_IntakeRJ_Test_TestMethod9() {        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
        JO.Customer_Name__c = 'Rajasekhar';
            JO.First_Name__c = 'hindu';
        JO.Application__c = 'Recreational Vehicle';
            JO.Model__c = 'RajTest';
            JO.Make__c = 'CSSTest';
            JO.Notes__c = 'CAMPCOMMENTS';
            JO.Failure_Point__c = 122;
            JO.Failure_Point_Measure__c = 'Miles';
            JO.VIN__c = '12345677890';
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.Before_In_Service__c = True;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = '12345';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.esn__c = '79464646';
            JO.Service_Model__c = 'model';
            JO.Unit_Type__c = 'type';
            JO.Sub_Type__c = 'sub type';
            Jo.Country__c = 'United States';
            Jo.CSS_State__c = 'Indiana';
            JO.Address__c = 'Bangalore';
            JO.ZipCode__c = '12345';
            JO.Primary_Segment__c = 'AG - AGRICULTURE';
            JO.CSS_Charge_Account_Status__c = 'charge';
            Jo.City__c = 'Columbus';
            JO.BMS_Last_Name__c = 'user';
            Jo.Customer_Code__c = '23456';
            Jo.EditComplaint__c = 'complaint';
            Jo.EditCoverage__c = 'coverage';
            Jo.EditCause__c = 'cause';
            Jo.EditCorrection__c = 'correction';
            JO.chevron_page__c = 'prt';
            JO.CSS_Resolution__c = 'Test';
            JO.DSID__c = 'VFD23';
            JO.Email_Address__c = 'prabhu@gmail.com';
            //JO.Sub_Status__c = 'Escalated';
            JO.Phone_Number__c = '9666666666';
            JO.Cstmr_Contacts_Phone__c = '8888888888';
            //JO.Previous_Status__c = 'intake';
            JO.Status__c = 'intake complete';
            JO.PSN_Not_Available__c = false;
            JO.Complaint_Type_Desc__c = 'null';
            JO.Category_Desc__c = 'test';
            JO.Contact_ID__c = 'wee';
            JO.Repair_Location__c = 'Mobile';
            JO.General_Symptoms__c = 'symptoms';
            JO.Shop_Work_Order__c = 'WO';
            JO.Mileage__c = 10.2;
            JO.Application_Desc__c = 'descrption';
            Jo.Category_Desc__c='TEST';
            Jo.Category2_Desc__c='TEST';
            Jo.Category3_Desc__c='TEST';
            Jo.Category4_Desc__c='TEST';
            Jo.Category5_Desc__c='TEST';
            JO.Complaint_Type2_Desc__c = 'ggg';
            JO.Complaint_Type2_Desc__c = 'ttyy';
            JO.Complaint_Type3_Desc__c = 'bbb';
            JO.Complaint_Type4_Desc__c = 'fffh';
            JO.Complaint_Type5_Desc__c = 'coml';
            JO.CSS_Job_Location_Code__c = '56271-56271';
            JO.Mileage_Measure__c = 'mileage';
            JO.Failure_Point_Measure__c = 'failure';
            JO.ESN_Locked__c = true;
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.bmsCreateAccount__c = true;
            JO.Application__c = 'Fire Truck';
            JO.Customer_Code__c = null;
             JO.Location_Certification__c = 'abcwer';
        insert JO;

        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        css_utility.validateEmail(JO.Email_Address__c);
        boolean Error = css_utility.CheckPhoneNoIsValid(JO.Phone_Number__c);
        boolean Error1 = css_utility.CheckPhoneNoIsValid(JO.Cstmr_Contacts_Phone__c);
        
        CG_CL_IntakeRJ ccirj = new CG_CL_IntakeRJ();
        ccirj.reqBooleanshop = false;
        ccirj.reqCusNumBoolean = false;
        ccirj.reqPhnnoBoolean = false;
        ccirj.reqPhnnototalchar = false;
        ccirj.reqFrstNamBoolean = false;
        ccirj.reqLastNamBoolean = false;
        ccirj.reqCstmrContactPhnBoolean = false;
        ccirj.reqCstmrContactPhntotalchar = false;
        ccirj.reqUNumBoolean = false;
        ccirj.reqAppBoolean = false;
        ccirj.reqMakeBoolean = false;
        ccirj.reqMdlBoolean = false;
        ccirj.reqCatBoolean = false;
        ccirj.reqComtypBoolean = false;
        ccirj.higherdateErrFlag = false;
        ccirj.reqBoolean = false;
     // ccirj.locationChangeValue = 'hhh';
       ccirj.userERPSystem = 'One BMS';
        ccirj.selectedLocation = '56271-56272';
        ccirj.selectedoldLocation = '56272-56271';  
        map<string,boolean> mapLocationBmsFlag11 = new map<string,boolean>() ;
        //mapLocationBmsFlag11.put(JO.Creator_Location__c, false);
        mapLocationBmsFlag11.put(JO.CSS_Job_Location_Code__c, true);
        mapLocationBmsFlag11.put(ccirj.selectedLocation, true);
        
        map<string,string> mapLocationBmsUrl2 = new map<string,string>();
        //mapLocationBmsUrl2.put('key', 'value');
        mapLocationBmsUrl2.put(JO.CSS_Job_Location_Code__c, JO.CSS_Job_Location_Code__c);
        ccirj.reqESNBoolean  = false;
        ccirj.locationChangeCounter = 0;
        ccirj.mapLocationBmsFlag = mapLocationBmsFlag11;
        ccirj.mapLocationBmsUrl = mapLocationBmsUrl2;
        //ccirj.selectedLocation = '56271-56271';
        ccirj.selectedoldLocation = 'hyddd';
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        ccirj.EmailAddress1 = 'xyz@cummins.com';
        ccirj.EmailAddress = 'zsss@cummins.com';
        ccirj.Cancel();
        ccirj.changeLocationOutcomes();
        ccirj.getLocationsName();
        ccirj.getApplication();
        ccirj.filterApplication = 'APPP';
        Test.setMock(HttpCalloutMock.class, new CSS_CustInboundMock());
        ccirj.bmsCustInbound();
        ccirj.userERPSystem = 'BMS Legacy';
        ccirj.reqEmailBoolean = true;
        ccirj.reqEmailBoolean = false;
        ccirj.reqEmailValidBoolean = false;
        ccirj.selectedSubStatusVal = 'escalated';
        ccirj.SubStatusPrevValue = 'intake';
        ccirj.locationChangeValue = 'hhh';
        ccirj.strBMSAccountMsg = 'msg';
        //ccirj.SubStatusPrevValue = 'intake';
        ccirj.reqUTBoolean = false;
        ccirj.reqSTBoolean = false;
        ccirj.reqEmailBoolean = false;
        ccirj.allFieldsValidate = false;
        ccirj.reqEmailValidBoolean = false;
        ccirj.disableAssignmentBtn = true;
        ccirj.bmsEnabled = true;
        ccirj.filterApplication = 'Application';
        ccirj.comm = 'body';
        ccirj.locationName = 'Bangalore';
         ccirj.getLocationsName();
        
        //CSS_WS_BMS.callUnitInbound(JO.Customer_Code__c,JO.Unit_Number__c,'unitDescription',JO.Model__c,JO.VIN__c,JO.Make__c,JO.Service_Model__c,JO.ESN__c,'engineFamily','applicationCode','miles','5678','60.0','4','21/02/2018','21/02/2018','application');
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        ccirj.callCreateWoAndUpdateComment();
        ccirj.BMSwarningMsg1 = 'warning';
        ccirj.BMSwarningMsg2 = 'warning';
     
        
        ccirj.Wid = Wid;
 
               
        
        Test.stopTest();
        
    }
   
         static testMethod void CG_CL_IntakeRJ_Test_TestMethod10() {        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
        JO.Customer_Name__c = 'Rajasekhar';
            JO.First_Name__c = 'hindu';
        JO.Application__c = 'Recreational Vehicle';
            JO.Model__c = 'RajTest';
            JO.Make__c = 'CSSTest';
            JO.Notes__c = 'CAMPCOMMENTS';
            JO.Failure_Point__c = 122;
            JO.Failure_Point_Measure__c = 'Miles';
            JO.VIN__c = '12345677890';
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.Before_In_Service__c = True;
            JO.Status__c = 'Repair Complete';
            //JO.Unit_Number__c = '12345';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.esn__c = '79464646';
            JO.Service_Model__c = 'model';
            JO.Unit_Type__c = 'type';
            JO.Sub_Type__c = 'sub type';
            Jo.Country__c = 'United States';
            Jo.CSS_State__c = 'Indiana';
            JO.Address__c = 'Bangalore';
            JO.ZipCode__c = '12345';
            JO.Primary_Segment__c = 'AG - AGRICULTURE';
            JO.CSS_Charge_Account_Status__c = 'charge';
            Jo.City__c = 'Columbus';
            JO.BMS_Last_Name__c = 'user';
            Jo.Customer_Code__c = '23456';
            Jo.EditComplaint__c = 'complaint';
            Jo.EditCoverage__c = 'coverage';
            Jo.EditCause__c = 'cause';
            Jo.EditCorrection__c = 'correction';
            JO.chevron_page__c = 'prt';
            JO.CSS_Resolution__c = 'Test';
            JO.DSID__c = 'VFD23';
            JO.Email_Address__c = 'prabhu@gmail.com';
            //JO.Sub_Status__c = 'Escalated';
            JO.Phone_Number__c = '9666666666';
            JO.Cstmr_Contacts_Phone__c = '8888888888';
            //JO.Previous_Status__c = 'intake';
            JO.Status__c = 'intake complete';
            JO.PSN_Not_Available__c = false;
            JO.Complaint_Type_Desc__c = 'null';
            JO.Category_Desc__c = 'test';
            JO.Contact_ID__c = 'wee';
            JO.Repair_Location__c = 'Mobile';
            JO.General_Symptoms__c = 'symptoms';
            JO.Shop_Work_Order__c = 'WO';
            JO.Mileage__c = 10.2;
            JO.Application_Desc__c = 'descrption';
            Jo.Category_Desc__c='TEST';
            Jo.Category2_Desc__c='TEST';
            Jo.Category3_Desc__c='TEST';
            Jo.Category4_Desc__c='TEST';
            Jo.Category5_Desc__c='TEST';
            JO.Complaint_Type2_Desc__c = 'ggg';
            JO.Complaint_Type2_Desc__c = 'ttyy';
            JO.Complaint_Type3_Desc__c = 'bbb';
            JO.Complaint_Type4_Desc__c = 'fffh';
            JO.Complaint_Type5_Desc__c = 'coml';
            JO.CSS_Job_Location_Code__c = '56270-56255';
            JO.Mileage_Measure__c = 'mileage';
            JO.Failure_Point_Measure__c = 'failure';
            JO.ESN_Locked__c = true;
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.bmsCreateAccount__c = true;
            JO.Application__c = 'Fire Truck';
            JO.Customer_Code__c = null;
            //JO.Creator_Location__c='56270-56255';
        //try{
          //  insert JO;
            //JO.Sub_Status__c = 'Estimate Needs Update';
            JO.Location_Certification__c = 'abcwer';
        insert JO;
       /*     //JO.Unit_Number__c = '1234567';
        //update JO;
      //  }
//catch(Exception e){}
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Service_Job__c = JO.id;
        solcomp.Status__c = 'Approved';
        solcomp.Type__c = 'Campaign';
        solcomp.Complete_Indicator__c = true;
        solcomp.Multiple_Times__c = true;
        insert solcomp;
        
        system.debug('init no.>>>>'+JO.Unit_Number__c);
        //Record for Country State Values
        CSS_CountryStateValues__c countryState = new CSS_CountryStateValues__c();
        countryState.Name = 'USIN';
        countryState.CountryCode__c = 'United States';
        countryState.CountryName__c = 'US';
        countryState.StateCode__c = 'Indiana';
        countryState.StateName__c = 'IN';
        insert countryState;
        //
        Note note = new Note();
        note.Title = 'CAMPCOMMENTS';
        note.ParentId = JO.Id;  
        note.Body = 'Bold';
        insert note;
        //
        list <CSS_CampTsbTrp__c> solutionList = new list < CSS_CampTsbTrp__c > ();
        CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                         Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false,
                                                         Performed_Review__c = false, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList.add(solRec);
        CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB14013368', URL__c = 'https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                          Type__c = 'TRP', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, 
                                                          Performed_Review__c = true, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList.add(solRec2);
        CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB1401689', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c = 'TSB', Doc_Title__c = 'xyzk', Cu_Language__c = 'xc', Performed__c = true, 
                                                          Performed_Review__c = false, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList.add(solRec1);
        CSS_CampTsbTrp__c solRec7 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB1401689', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c = 'ATC', Doc_Title__c = 'xyzk', Cu_Language__c = 'xc', Performed__c = true, 
                                                          Performed_Review__c = false, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList.add(solRec7);
        
        insert solutionList;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        CSS_JobEventTemporary__c je = CSS_TestData.createJobEventTempObj(false);
        String json = '{'+
            '  \"Details\": {'+
            '    \"ApplicationCode\": \"12345\",'+
            '    \"Description\": \"testing\",'+
            '    \"BusinessUnit\": \"GetAssessData\",'+
            '    \"AutomotiveFlag\": \"Fault Details Data sent successfully\",'+
            '    \"MarineFlag\": \"Fault Details Data sent successfully\",'+   
            '    \"ActiveFlag\": \"Y\",'+    
            '    \"DefaultUom\": \"Fault Details Data sent successfully\"'+     
            '  },'+
            '  \"Header\": {'+   
            '        \"ReturnCodeDescription\": \"Test\",'+
            '        \"Status\": \"completed\"'+
            '      }'+
            '}'; 
        String jsonCategory = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        string jsonResponse='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        je.Reason__c =  json;
        je.attribute1__c = 'ApplicationCodes';      
        insert je;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
list<account> lstAcc = new list<Account>();
            list<CSS_UserLocation__c> lstUsrLoc =new list<CSS_UserLocation__c>();
             Account a= new Account();
               a.name='Rtest';
               a.CSS_DistributorCode__c='56270';
               a.IAM_Service_Provider_Code__c='56270';
               a.BMS_Enabled__c = true;
            lstAcc.add(a);
            Account a1= new Account();
               a1.name='Rtest';
               a1.CSS_DistributorCode__c='56271';
               a1.IAM_Service_Provider_Code__c='56271';
               a1.BMS_Enabled__c = true;
            lstAcc.add(a1);
             Account a2= new Account();
               a2.name='Rtest';
               a2.CSS_DistributorCode__c='56272';
               a2.IAM_Service_Provider_Code__c='56272';
               a2.BMS_Enabled__c = false;
            lstAcc.add(a2);
               insert lstAcc;
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=lstAcc[0].id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='56270-56270');
CSS_UserLocation__c userLocation1 = new CSS_UserLocation__c(AccountId__c=lstAcc[1].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56271-56271');
            CSS_UserLocation__c userLocation2 = new CSS_UserLocation__c(AccountId__c=lstAcc[2].id,isActive__c=true,isPrimary__c=false,UserId__c=u.Id,Location_code__c='56272-56272');
lstUsrLoc.add(userLocation);
            lstUsrLoc.add(userLocation1);
            lstUsrLoc.add(userLocation2);
            insert lstUsrLoc;
        /
        //css_utility.setSessionVariables(JO.Creator_Location__c);
       // css_utility.setSessionVariables(JO.CSS_Job_Location_Code__c);
        
        
        
        
        
        CSS_JobEventTemporary__c jeCategory = CSS_TestData.createJobEventTempObj(false);
        jeCategory.Reason__c =  jsonCategory;
        jeCategory.attribute1__c = 'CategoryComplaintCodes';      
        insert jeCategory;
        string scode3=css_utility.getCodes('Application Code','Fire Truck',null,null);
        CSS_DataExchange_Parent__c de = CSS_TestData.createDataExchangeParentRecords(true);
        //string scode3=css_utility.getCodes('Application Code','Fire Truck',null,null);
        
        */
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        css_utility.validateEmail(JO.Email_Address__c);
        boolean Error = css_utility.CheckPhoneNoIsValid(JO.Phone_Number__c);
        boolean Error1 = css_utility.CheckPhoneNoIsValid(JO.Cstmr_Contacts_Phone__c);
        
        CG_CL_IntakeRJ ccirj = new CG_CL_IntakeRJ();
        ccirj.reqBooleanshop = false;
        ccirj.reqCusNumBoolean = false;
        ccirj.reqPhnnoBoolean = false;
        ccirj.reqPhnnototalchar = false;
        ccirj.reqFrstNamBoolean = false;
        ccirj.reqLastNamBoolean = false;
        ccirj.reqCstmrContactPhnBoolean = false;
        ccirj.reqCstmrContactPhntotalchar = false;
        ccirj.reqUNumBoolean = false;
        ccirj.reqAppBoolean = false;
        ccirj.reqMakeBoolean = false;
        ccirj.reqMdlBoolean = false;
        ccirj.reqCatBoolean = false;
        ccirj.reqComtypBoolean = false;
        ccirj.higherdateErrFlag = false;
        ccirj.reqBoolean = false;
     // ccirj.locationChangeValue = 'hhh';
       ccirj.userERPSystem = 'One BMS';
        ccirj.selectedLocation = '56271-56271';
        map<string,boolean> mapLocationBmsFlag11 = new map<string,boolean>() ;
        //mapLocationBmsFlag11.put(JO.Creator_Location__c, false);
        mapLocationBmsFlag11.put(JO.CSS_Job_Location_Code__c, true);
        mapLocationBmsFlag11.put(ccirj.selectedLocation, false);
        
        map<string,string> mapLocationBmsUrl2 = new map<string,string>();
        mapLocationBmsUrl2.put('key', 'value');
        ccirj.reqESNBoolean  = false;
        ccirj.locationChangeCounter = 0;
        ccirj.mapLocationBmsFlag = mapLocationBmsFlag11;
        ccirj.mapLocationBmsUrl = mapLocationBmsUrl2;
        //ccirj.selectedLocation = '56271-56271';
        ccirj.selectedoldLocation = 'hyddd';
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        ccirj.EmailAddress1 = 'xyz@cummins.com';
        ccirj.EmailAddress = 'zsss@cummins.com';
        ccirj.Cancel();
        ccirj.changeLocationOutcomes();
        ccirj.getLocationsName();
        ccirj.getApplication();
        ccirj.filterApplication = 'APPP';
        Test.setMock(HttpCalloutMock.class, new CSS_CustInboundMock());
        ccirj.bmsCustInbound();
        ccirj.userERPSystem = 'BMS Legacy';
        ccirj.reqEmailBoolean = true;
        ccirj.reqEmailBoolean = false;
        ccirj.reqEmailValidBoolean = false;
        ccirj.selectedSubStatusVal = 'escalated';
        ccirj.SubStatusPrevValue = 'intake';
        ccirj.locationChangeValue = 'hhh';
        ccirj.strBMSAccountMsg = 'msg';
        //ccirj.SubStatusPrevValue = 'intake';
        ccirj.reqUTBoolean = false;
        ccirj.reqSTBoolean = false;
        ccirj.reqEmailBoolean = false;
        ccirj.allFieldsValidate = false;
        ccirj.reqEmailValidBoolean = false;
        ccirj.disableAssignmentBtn = true;
        ccirj.bmsEnabled = true;
        ccirj.filterApplication = 'Application';
        ccirj.comm = 'body';
        ccirj.locationName = 'Bangalore';
         ccirj.getLocationsName();
        
        //CSS_WS_BMS.callUnitInbound(JO.Customer_Code__c,JO.Unit_Number__c,'unitDescription',JO.Model__c,JO.VIN__c,JO.Make__c,JO.Service_Model__c,JO.ESN__c,'engineFamily','applicationCode','miles','5678','60.0','4','21/02/2018','21/02/2018','application');
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        ccirj.callCreateWoAndUpdateComment();
        ccirj.BMSwarningMsg1 = 'warning';
        ccirj.BMSwarningMsg2 = 'warning';
     
        
        ccirj.Wid = Wid;
 
               
        
        Test.stopTest();
        
    } 
    
         static testMethod void CG_CL_IntakeRJ_Test_TestMethod11() {        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
        JO.Customer_Name__c = 'Rajasekhar';
            JO.First_Name__c = 'hindu';
        JO.Application__c = 'Recreational Vehicle';
            JO.Model__c = 'RajTest';
            JO.Make__c = 'CSSTest';
            JO.Notes__c = 'CAMPCOMMENTS';
            JO.Failure_Point__c = 122;
            JO.Failure_Point_Measure__c = 'Miles';
            JO.VIN__c = '12345677890';
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.Before_In_Service__c = True;
            JO.Status__c = 'Repair Complete';
            //JO.Unit_Number__c = '12345';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.esn__c = '79464646';
            JO.Service_Model__c = 'model';
            JO.Unit_Type__c = 'type';
            JO.Sub_Type__c = 'sub type';
            Jo.Country__c = 'United States';
            Jo.CSS_State__c = 'Indiana';
            JO.Address__c = 'Bangalore';
            JO.ZipCode__c = '12345';
            JO.Primary_Segment__c = 'AG - AGRICULTURE';
            JO.CSS_Charge_Account_Status__c = 'charge';
            Jo.City__c = 'Columbus';
            JO.BMS_Last_Name__c = 'user';
            Jo.Customer_Code__c = '23456';
            Jo.EditComplaint__c = 'complaint';
            Jo.EditCoverage__c = 'coverage';
            Jo.EditCause__c = 'cause';
            Jo.EditCorrection__c = 'correction';
            JO.chevron_page__c = 'prt';
            JO.CSS_Resolution__c = 'Test';
            JO.DSID__c = 'VFD23';
            JO.Email_Address__c = 'prabhu@gmail.com';
            //JO.Sub_Status__c = 'Escalated';
            JO.Phone_Number__c = '9666666666';
            JO.Cstmr_Contacts_Phone__c = '8888888888';
            //JO.Previous_Status__c = 'intake';
            JO.Status__c = 'intake complete';
            JO.PSN_Not_Available__c = false;
            JO.Complaint_Type_Desc__c = 'null';
            JO.Category_Desc__c = 'test';
            JO.Contact_ID__c = 'wee';
            JO.Repair_Location__c = 'Mobile';
            JO.General_Symptoms__c = 'symptoms';
            JO.Shop_Work_Order__c = 'WO';
            JO.Mileage__c = 10.2;
            JO.Application_Desc__c = 'null';
            Jo.Category_Desc__c='TEST';
            Jo.Category2_Desc__c='TEST';
            Jo.Category3_Desc__c='TEST';
            Jo.Category4_Desc__c='TEST';
            Jo.Category5_Desc__c='TEST';
            JO.Complaint_Type2_Desc__c = 'ggg';
            JO.Complaint_Type2_Desc__c = 'ttyy';
            JO.Complaint_Type3_Desc__c = 'bbb';
            JO.Complaint_Type4_Desc__c = 'fffh';
            JO.Complaint_Type5_Desc__c = 'coml';
            JO.CSS_Job_Location_Code__c = '56271-56271';
            JO.Mileage_Measure__c = 'mileage';
            JO.Failure_Point_Measure__c = 'failure';
            JO.ESN_Locked__c = true;
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.bmsCreateAccount__c = true;
            JO.Application__c = 'Fire Truck';
            JO.Customer_Code__c = null;
             JO.Location_Certification__c = 'abcwer';
        insert JO;

        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        css_utility.validateEmail(JO.Email_Address__c);
        boolean Error = css_utility.CheckPhoneNoIsValid(JO.Phone_Number__c);
        boolean Error1 = css_utility.CheckPhoneNoIsValid(JO.Cstmr_Contacts_Phone__c);
        
        CG_CL_IntakeRJ ccirj = new CG_CL_IntakeRJ();
        ccirj.reqBooleanshop = false;
        ccirj.reqCusNumBoolean = false;
        ccirj.reqPhnnoBoolean = false;
        ccirj.reqPhnnototalchar = false;
        ccirj.reqFrstNamBoolean = false;
        ccirj.reqLastNamBoolean = false;
        ccirj.reqCstmrContactPhnBoolean = false;
        ccirj.reqCstmrContactPhntotalchar = false;
        ccirj.reqUNumBoolean = false;
        ccirj.reqAppBoolean = false;
        ccirj.reqMakeBoolean = false;
        ccirj.reqMdlBoolean = false;
        ccirj.reqCatBoolean = false;
        ccirj.reqComtypBoolean = false;
        ccirj.higherdateErrFlag = false;
        ccirj.reqBoolean = false;
     // ccirj.locationChangeValue = 'hhh';
       ccirj.userERPSystem = 'One BMS';
        ccirj.selectedLocation = '56271-56271';
       ccirj.selectedoldLocation = '56272-56271';
             system.debug('ccirj.selectedoldLocation***'+ccirj.selectedoldLocation);
        map<string,boolean> mapLocationBmsFlag11 = new map<string,boolean>() ;
        //mapLocationBmsFlag11.put(JO.Creator_Location__c, false);
        mapLocationBmsFlag11.put(ccirj.selectedoldLocation, true);
        mapLocationBmsFlag11.put(ccirj.selectedLocation, true);
        
        map<string,string> mapLocationBmsUrl2 = new map<string,string>();
        mapLocationBmsUrl2.put(ccirj.selectedLocation, ccirj.selectedLocation);
             
        ccirj.reqESNBoolean  = false;
        ccirj.locationChangeCounter = 1;
        ccirj.mapLocationBmsFlag = mapLocationBmsFlag11;
        ccirj.mapLocationBmsUrl = mapLocationBmsUrl2;
             ccirj.changeLocationOutcomes();
        //ccirj.selectedLocation = '56271-56271';
        //ccirj.selectedoldLocation = 'hyddd';
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        ccirj.EmailAddress1 = 'xyz@cummins.com';
        ccirj.EmailAddress = 'zsss@cummins.com';
        ccirj.Cancel();
        //ccirj.changeLocationOutcomes();
        ccirj.getLocationsName();
        ccirj.getApplication();
        ccirj.filterApplication = 'APPP';
        Test.setMock(HttpCalloutMock.class, new CSS_CustInboundMock());
        ccirj.bmsCustInbound();
        ccirj.userERPSystem = 'BMS Legacy';
        ccirj.reqEmailBoolean = true;
        ccirj.reqEmailBoolean = false;
        ccirj.reqEmailValidBoolean = false;
        ccirj.selectedSubStatusVal = 'escalated';
        ccirj.SubStatusPrevValue = 'intake';
        ccirj.locationChangeValue = 'hhh';
        ccirj.strBMSAccountMsg = 'msg';
        //ccirj.SubStatusPrevValue = 'intake';
        ccirj.reqUTBoolean = false;
        ccirj.reqSTBoolean = false;
        ccirj.reqEmailBoolean = false;
        ccirj.allFieldsValidate = false;
        ccirj.reqEmailValidBoolean = false;
        ccirj.disableAssignmentBtn = true;
        ccirj.bmsEnabled = true;
        ccirj.filterApplication = 'Application';
        ccirj.comm = 'body';
        ccirj.locationName = 'Bangalore';
         ccirj.getLocationsName();
        
        //CSS_WS_BMS.callUnitInbound(JO.Customer_Code__c,JO.Unit_Number__c,'unitDescription',JO.Model__c,JO.VIN__c,JO.Make__c,JO.Service_Model__c,JO.ESN__c,'engineFamily','applicationCode','miles','5678','60.0','4','21/02/2018','21/02/2018','application');
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        ccirj.callCreateWoAndUpdateComment();
        ccirj.BMSwarningMsg1 = 'warning';
        ccirj.BMSwarningMsg2 = 'warning';
     
        
        ccirj.Wid = Wid;
 
               
        
        Test.stopTest();
        
    }
   
             static testMethod void CG_CL_IntakeRJ_Test_TestMethod12() {        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
        JO.Customer_Name__c = 'Rajasekhar';
            JO.First_Name__c = 'hindu';
        JO.Application__c = 'Recreational Vehicle';
            JO.Model__c = 'RajTest';
            JO.Make__c = 'CSSTest';
            JO.Notes__c = 'CAMPCOMMENTS';
            JO.Failure_Point__c = 122;
            JO.Failure_Point_Measure__c = 'Miles';
            JO.VIN__c = '12345677890';
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.Before_In_Service__c = True;
            JO.Status__c = 'Repair Complete';
            //JO.Unit_Number__c = '12345';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.esn__c = '79464646';
            JO.Service_Model__c = 'model';
            JO.Unit_Type__c = 'type';
            JO.Sub_Type__c = 'sub type';
            Jo.Country__c = 'United States';
            Jo.CSS_State__c = 'Indiana';
            JO.Address__c = 'Bangalore';
            JO.ZipCode__c = '12345';
            JO.Primary_Segment__c = 'AG - AGRICULTURE';
            JO.CSS_Charge_Account_Status__c = 'charge';
            Jo.City__c = 'Columbus';
            JO.BMS_Last_Name__c = 'user';
            Jo.Customer_Code__c = '23456';
            Jo.EditComplaint__c = 'complaint';
            Jo.EditCoverage__c = 'coverage';
            Jo.EditCause__c = 'cause';
            Jo.EditCorrection__c = 'correction';
            JO.chevron_page__c = 'prt';
            JO.CSS_Resolution__c = 'Test';
            JO.DSID__c = 'VFD23';
            JO.Email_Address__c = 'prabhu@gmail.com';
            //JO.Sub_Status__c = 'Escalated';
            JO.Phone_Number__c = '9666666666';
            JO.Cstmr_Contacts_Phone__c = '8888888888';
            //JO.Previous_Status__c = 'intake';
            JO.Status__c = 'intake complete';
            JO.PSN_Not_Available__c = false;
            JO.Complaint_Type_Desc__c = 'null';
            JO.Category_Desc__c = 'test';
            JO.Contact_ID__c = 'wee';
            JO.Repair_Location__c = 'Mobile';
            JO.General_Symptoms__c = 'symptoms';
            JO.Shop_Work_Order__c = 'WO';
            JO.Mileage__c = 10.2;
            JO.Application_Desc__c = 'Test1325';
            Jo.Category_Desc__c='TEST';
            Jo.Category2_Desc__c='TEST';
            Jo.Category3_Desc__c='TEST';
            Jo.Category4_Desc__c='TEST';
            Jo.Category5_Desc__c='TEST';
            JO.Complaint_Type2_Desc__c = 'ggg';
            JO.Complaint_Type2_Desc__c = 'ttyy';
            JO.Complaint_Type3_Desc__c = 'bbb';
            JO.Complaint_Type4_Desc__c = 'fffh';
            JO.Complaint_Type5_Desc__c = 'coml';
            JO.CSS_Job_Location_Code__c = '56271-56271';
            JO.Mileage_Measure__c = 'mileage';
            JO.Failure_Point_Measure__c = 'failure';
            JO.ESN_Locked__c = true;
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.bmsCreateAccount__c = true;
            JO.Application__c = 'Fire Truck';
            JO.Customer_Code__c = null;
             JO.Location_Certification__c = 'abcwer';
        insert JO;

        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        css_utility.validateEmail(JO.Email_Address__c);
        boolean Error = css_utility.CheckPhoneNoIsValid(JO.Phone_Number__c);
        boolean Error1 = css_utility.CheckPhoneNoIsValid(JO.Cstmr_Contacts_Phone__c);
        
        CG_CL_IntakeRJ ccirj = new CG_CL_IntakeRJ();
        ccirj.reqBooleanshop = false;
        ccirj.reqCusNumBoolean = false;
        ccirj.reqPhnnoBoolean = false;
        ccirj.reqPhnnototalchar = false;
        ccirj.reqFrstNamBoolean = false;
        ccirj.reqLastNamBoolean = false;
        ccirj.reqCstmrContactPhnBoolean = false;
        ccirj.reqCstmrContactPhntotalchar = false;
        ccirj.reqUNumBoolean = false;
        ccirj.reqAppBoolean = false;
        ccirj.reqMakeBoolean = false;
        ccirj.reqMdlBoolean = false;
        ccirj.reqCatBoolean = false;
        ccirj.reqComtypBoolean = false;
        ccirj.higherdateErrFlag = false;
        ccirj.reqBoolean = false;
     // ccirj.locationChangeValue = 'hhh';
       ccirj.userERPSystem = 'One BMS';
        ccirj.selectedLocation = '56271-56271';
       ccirj.selectedoldLocation = '56272-56271';
             system.debug('ccirj.selectedoldLocation***'+ccirj.selectedoldLocation);
        map<string,boolean> mapLocationBmsFlag11 = new map<string,boolean>() ;
        //mapLocationBmsFlag11.put(JO.Creator_Location__c, false);
        mapLocationBmsFlag11.put(ccirj.selectedoldLocation, false);
        mapLocationBmsFlag11.put(ccirj.selectedLocation, true);
        
        map<string,string> mapLocationBmsUrl2 = new map<string,string>();
        mapLocationBmsUrl2.put(ccirj.selectedLocation, ccirj.selectedLocation);
             
        ccirj.reqESNBoolean  = false;
        ccirj.locationChangeCounter = 1;
        ccirj.mapLocationBmsFlag = mapLocationBmsFlag11;
        ccirj.mapLocationBmsUrl = mapLocationBmsUrl2;
             ccirj.changeLocationOutcomes();
        //ccirj.selectedLocation = '56271-56271';
        //ccirj.selectedoldLocation = 'hyddd';
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        ccirj.EmailAddress1 = 'xyz@cummins.com';
        ccirj.EmailAddress = 'zsss@cummins.com';
        ccirj.Cancel();
        //ccirj.changeLocationOutcomes();
        ccirj.getLocationsName();
        ccirj.getApplication();
        ccirj.filterApplication = 'APPP';
        Test.setMock(HttpCalloutMock.class, new CSS_CustInboundMock());
        ccirj.bmsCustInbound();
        ccirj.userERPSystem = 'BMS Legacy';
        ccirj.reqEmailBoolean = true;
        ccirj.reqEmailBoolean = false;
        ccirj.reqEmailValidBoolean = false;
        ccirj.selectedSubStatusVal = 'escalated';
        ccirj.SubStatusPrevValue = 'intake';
        ccirj.locationChangeValue = 'hhh';
        ccirj.strBMSAccountMsg = 'msg';
        //ccirj.SubStatusPrevValue = 'intake';
        ccirj.reqUTBoolean = false;
        ccirj.reqSTBoolean = false;
        ccirj.reqEmailBoolean = false;
        ccirj.allFieldsValidate = false;
        ccirj.reqEmailValidBoolean = false;
        ccirj.disableAssignmentBtn = true;
        ccirj.bmsEnabled = true;
        ccirj.filterApplication = 'Application';
        ccirj.comm = 'body';
        ccirj.locationName = 'Bangalore';
         ccirj.getLocationsName();
        
        //CSS_WS_BMS.callUnitInbound(JO.Customer_Code__c,JO.Unit_Number__c,'unitDescription',JO.Model__c,JO.VIN__c,JO.Make__c,JO.Service_Model__c,JO.ESN__c,'engineFamily','applicationCode','miles','5678','60.0','4','21/02/2018','21/02/2018','application');
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        ccirj.callCreateWoAndUpdateComment();
        ccirj.BMSwarningMsg1 = 'warning';
        ccirj.BMSwarningMsg2 = 'warning';
     
        
        ccirj.Wid = Wid;
 
               
        
        Test.stopTest();
        
    }
   
                 static testMethod void CG_CL_IntakeRJ_Test_TestMethod13() {        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Unit_Number__c = '123456';
        JO.Customer_Name__c = 'Rajasekhar';
            JO.First_Name__c = 'hindu';
        JO.Application__c = 'Recreational Vehicle';
            JO.Model__c = 'RajTest';
            JO.Make__c = 'CSSTest';
            JO.Notes__c = 'CAMPCOMMENTS';
            JO.Failure_Point__c = 122;
            JO.Failure_Point_Measure__c = 'Miles';
            JO.VIN__c = '12345677890';
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.Before_In_Service__c = True;
            JO.Status__c = 'Repair Complete';
            //JO.Unit_Number__c = '12345';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.esn__c = '79464646';
            JO.Service_Model__c = 'model';
            JO.Unit_Type__c = 'type';
            JO.Sub_Type__c = 'sub type';
            Jo.Country__c = 'United States';
            Jo.CSS_State__c = 'Indiana';
            JO.Address__c = 'Bangalore';
            JO.ZipCode__c = '12345';
            JO.Primary_Segment__c = 'AG - AGRICULTURE';
            JO.CSS_Charge_Account_Status__c = 'charge';
            Jo.City__c = 'Columbus';
            JO.BMS_Last_Name__c = 'user';
            Jo.Customer_Code__c = '23456';
            Jo.EditComplaint__c = 'complaint';
            Jo.EditCoverage__c = 'coverage';
            Jo.EditCause__c = 'cause';
            Jo.EditCorrection__c = 'correction';
            JO.chevron_page__c = 'prt';
            JO.CSS_Resolution__c = 'Test';
            JO.DSID__c = 'VFD23';
            JO.Email_Address__c = 'prabhu@gmail.com';
            //JO.Sub_Status__c = 'Escalated';
            JO.Phone_Number__c = '9666666666';
            JO.Cstmr_Contacts_Phone__c = '8888888888';
            //JO.Previous_Status__c = 'intake';
            JO.Status__c = 'intake complete';
            JO.PSN_Not_Available__c = false;
            JO.Complaint_Type_Desc__c = 'null';
            JO.Category_Desc__c = 'test';
            JO.Contact_ID__c = 'wee';
            JO.Repair_Location__c = 'Mobile';
            JO.General_Symptoms__c = 'symptoms';
            JO.Shop_Work_Order__c = 'WO';
            JO.Mileage__c = 10.2;
            JO.Application_Desc__c = 'test1494';
            Jo.Category_Desc__c='TEST';
            Jo.Category2_Desc__c='TEST';
            Jo.Category3_Desc__c='TEST';
            Jo.Category4_Desc__c='TEST';
            Jo.Category5_Desc__c='TEST';
            JO.Complaint_Type2_Desc__c = 'ggg';
            JO.Complaint_Type2_Desc__c = 'ttyy';
            JO.Complaint_Type3_Desc__c = 'bbb';
            JO.Complaint_Type4_Desc__c = 'fffh';
            JO.Complaint_Type5_Desc__c = 'coml';
            JO.CSS_Job_Location_Code__c = '56271-56271';
            JO.Mileage_Measure__c = 'mileage';
            JO.Failure_Point_Measure__c = 'failure';
            JO.ESN_Locked__c = true;
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 365;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = 'abc';
            JO.bmsCreateAccount__c = true;
            JO.Application__c = 'Fire Truck';
            JO.Customer_Code__c = null;
             JO.Location_Certification__c = 'abcwer';
        insert JO;

        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        Id Wid=ApexPages.CurrentPage().getParameters().get('id');
        css_utility.validateEmail(JO.Email_Address__c);
        boolean Error = css_utility.CheckPhoneNoIsValid(JO.Phone_Number__c);
        boolean Error1 = css_utility.CheckPhoneNoIsValid(JO.Cstmr_Contacts_Phone__c);
        
        CG_CL_IntakeRJ ccirj = new CG_CL_IntakeRJ();
        ccirj.reqBooleanshop = false;
        ccirj.reqCusNumBoolean = false;
        ccirj.reqPhnnoBoolean = false;
        ccirj.reqPhnnototalchar = false;
        ccirj.reqFrstNamBoolean = false;
        ccirj.reqLastNamBoolean = false;
        ccirj.reqCstmrContactPhnBoolean = false;
        ccirj.reqCstmrContactPhntotalchar = false;
        ccirj.reqUNumBoolean = false;
        ccirj.reqAppBoolean = false;
        ccirj.reqMakeBoolean = false;
        ccirj.reqMdlBoolean = false;
        ccirj.reqCatBoolean = false;
        ccirj.reqComtypBoolean = false;
        ccirj.higherdateErrFlag = false;
        ccirj.reqBoolean = false;
     // ccirj.locationChangeValue = 'hhh';
       ccirj.userERPSystem = 'One BMS';
        ccirj.selectedLocation = '56271-56271';
       ccirj.selectedoldLocation = '56272-56271';
             system.debug('ccirj.selectedoldLocation***'+ccirj.selectedoldLocation);
        map<string,boolean> mapLocationBmsFlag11 = new map<string,boolean>() ;
        //mapLocationBmsFlag11.put(JO.Creator_Location__c, false);
        mapLocationBmsFlag11.put(ccirj.selectedoldLocation, true);
        mapLocationBmsFlag11.put(ccirj.selectedLocation, false);
        
        map<string,string> mapLocationBmsUrl2 = new map<string,string>();
        mapLocationBmsUrl2.put(ccirj.selectedLocation, ccirj.selectedLocation);
             
        ccirj.reqESNBoolean  = false;
        ccirj.locationChangeCounter = 1;
        ccirj.mapLocationBmsFlag = mapLocationBmsFlag11;
        ccirj.mapLocationBmsUrl = mapLocationBmsUrl2;
             ccirj.changeLocationOutcomes();
 
        ccirj.Wid = Wid;
 
               
        
        Test.stopTest();
        
    }
  
}