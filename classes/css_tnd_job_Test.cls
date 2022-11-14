/*
----------------------------------------------------------
    Author: Roopa G
    Created Date:15/1/2016  
    Updated by: Roopa G 
    Updated on: 30/1/2016
    Description: Intake Audit Trail Controller
    Change Description:
-----------------------------------------------------------
 */

@IsTest
public class css_tnd_job_Test{
      
        public static CSS_Job_Order__c JO;
        public static CSS_Fault_Code__c faultCode;
        public static List<CSS_Solution_Component__c> addSolComList;
        public static CSS_Solution_Component__c AddsolComp;
        public static Attachment attach;
        public static CSS_Solutions__c cssSol;
        public static css_srt__c cssSRT;
        public static List<css_srt__c> listCssSRT;
        public static CSS_CampTsbTrp__c cssTrp;
        
        //Method to create test Data 
       public static void TestData(){
            
             Account acc=CSS_TestData.createAccountObj(false);
            acc.Name = 'Akanksha';
            acc.CSS_DistributorCode__c ='56270';
            acc.CSS_DealerCode__c = '56270';
            acc.Region__c ='North America';
            acc.CSS_DBCode__c='33333';
            acc.Type = 'Customer';
            insert acc;
            
            JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'RoopaTnD';
            JO.CSS_Job_Location_Code__c = '03742-02991';
            JO.Model__c = null;
            JO.Make__c = null;
            JO.Category_Desc__c = 'testing';
            JO.Complaint_Type_Desc__c = 'test';
            JO.Application__c='Automotive'; 
            JO.Date_In__c= Date.today();
            JO.Account__c = acc.ID;
            JO.INSITE_UpdateTimeStamp__c= Date.today();
            JO.Service_Model__c='ff';
            JO.General_Symptoms__c='ttrtrtrt';
            JO.ESN__c='123';
            JO.Email_Address__c = 'cummins@cummins.com';
            // JO.Mileage__c=23;
            JO.Category__c='Leak';
            JO.Failure_Date__c= Date.Today();
            JO.Failure_Point_Measure__c ='sss';
            JO.RPV_Email_Address__c='test@test.com';
            JO.RPV_Email_Has_Sent__c=false;
            JO.RPVControlNumber__c='NoInput';
            JO.DSID_Creation_Timestamp__c=Date.Today();
            JO.DSID_Status__c='open';
            JO.Shop_Work_Order__c = 'test';
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'test1234';
            Jo.DSID_WorkGroup__c = '1234';
            Jo.RPV_SecondWebserviceCall__c = true;
            Jo.RPV_Notification_Flag__c ='OFF';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.AccessCode__c = '12';
            Jo.BMSStatus__c='UI0';
            Jo.DSID__c='12345';
            insert(JO);
            CSS_Make_Model_Access__c MakeList = new CSS_Make_Model_Access__c();
            CSS_Make_Model_Access__c mk = new CSS_Make_Model_Access__c();
          //  mk.Name = '100-EQ6423-32-E';       
            mk.Access__c = 'D';
           // mk.EngineFamily__c = '32';
            mk.EquipmentId__c = 'EQ6423';
            mk.Make__c = 'DRESSER';
            mk.Model__c = '100';
            insert mk;
            
            CSS_Fault_Code_Master__c  faultCodeMaster = new CSS_Fault_Code_Master__c();
            faultCodeMaster.Name ='Test';
            insert faultCodeMaster;
            
              faultCode= new CSS_Fault_Code__c ();
            faultCode.Fault_Code_Type__c ='BPD';
            faultCode.Sequence__c = 1;
            faultCode.Job_Order__c=Jo.id;
            faultCode.Fault_Code__c =faultCodeMaster.Id;
            insert faultCode;
            
            
            ApexPages.CurrentPage().getParameters().put('id',Jo.id);
            
             
            cssSol = new CSS_Solutions__c();
            cssSol.Name = 'Test Solution';
            cssSol.service_job__c = JO.id;
            cssSol.Out_Of_Order__c = true;
            cssSol.Repair_Response__c = 'Repair Successful';
            cssSol.Diagnostic_Response__c = 'Most likely the solution';
            insert cssSol;
            
             addSolComList = new List<CSS_Solution_Component__c>();
            AddsolComp = new CSS_Solution_Component__c();
            AddsolComp.Service_Job__c = JO.ID;
            AddsolComp.Action__c = 'Repair';
            AddsolComp.Solutions__c = cssSol.id;
            AddsolComp.Quantity__c = 4;
            AddsolComp.type__c='CAM';
            AddsolComp.Selected_Component__c = True;
            AddsolComp.AccountCode__c = 'Test-AccountCode';
            AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
            AddsolComp.CoveredPartsQty__c = null;
            AddsolComp.AccountCodeType__c='ASAS';
            AddsolComp.Charlength__c = true;
            insert AddsolComp;
            addSolComList.add(AddsolComp);
            
            listCssSRT = new List<css_srt__c>();
            cssSRT = new css_srt__c();
            cssSRT.Name = 'Test';
            cssSRT.Job_Order__c = Jo.id;
            cssSRT.Type__c = 'Diagnosis';
            cssSRT.Solution_Number__c = cssSol.id;
            cssSRT.Assignment__c = 'Primary';
            cssSRT.isPerformed__c = true;
            cssSRT.Extended_Hours__c = 1.20;
            cssSRT.Component_Id__c = AddsolComp.id;
            cssSRT.SRT_Time__c = 6;
            insert cssSRT;
            listCssSRT.add(cssSRT);
            
            CSS_Integration_Details__c CID = new CSS_Integration_Details__c();
            CID.name = 'sample';
            CID.ApplicationName__c = 'QSOL';
            CID.End_Point__c='https://qsolpilot.cummins.com/csswebservices/qsol';
            CID.IsActive__c = true;
            CID.Key__c='Rv++7jk31axoHDVpTvA3bgbFQFnJ7d4t9GGFfxtox6g=';
            CID.Passcode__c='gTqnM27bVy+M3A/Fmc3s0C6ZJorDI//NobXZXB6wNOU=';
            CID.Username__c = 'Ke/SFT1NcHvb0XlJXmnBeMvno2u23G8m5ju56+YHSbQ=';
            insert CID;
            
           
            
            CSS_Accreditation__c accreditation = new CSS_Accreditation__c();
            accreditation.Account__c =acc.Id;
            accreditation.Service_Model_Name__c ='Test';
            insert accreditation;
            
            CSS_accountLanguage__c lang = CSS_TestData.createAccountLanguage(true);
            
            Id AdminProfile = [select Id from Profile where Name='System Administrator'].Id;
            User testUser = new User(firstname='TestUser', Username='testemailid'+Math.random()*Math.random()+'@testemailprovider.com',Alias='P0044',Email='user@gmail.com',LastName='SA',ProfileId=AdminProfile,
                                     TimeZoneSidKey='America/Chicago',LanguageLocaleKey='en_US',LocaleSidKey='en_US',User_Location__c = '03742-02991');
            System.AssertEquals(testUser.Firstname, 'TestUser');
            
            CSS_CampTsbTrp__c ct = new CSS_CampTsbTrp__c();
            ct.name = 'CAM';
            ct.name = 'TRP';
            ct.name = 'TSB';
            list<CSS_CampTsbTrp__c> solutionList = new list<CSS_CampTsbTrp__c>();
            CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c( Doc_Num__c='TSB140168',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                             Type__c='CAM',Doc_Title__c='xyz' ,Performed__c= false,Cu_Language__c = 'Hindi',
                                                             Performed_Review__c= false,Reviewed__c= false , esn__c = '73695829',Job_Order__c =Jo.id);
            solutionList.add(solRec);
            CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB14013368',URL__c='https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                              Type__c='TRP',Doc_Title__c='xyz' ,Performed__c= false,
                                                              Performed_Review__c= true,Reviewed__c= false , esn__c = '1234',Job_Order__c =Jo.id);
            solutionList.add(solRec2); 
            CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB1401689',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                              Type__c='TSB',Doc_Title__c='xyzk' ,Performed__c= true,
                                                              Performed_Review__c= false,Reviewed__c= false , esn__c = '1234',Job_Order__c =Jo.id);
            solutionList.add(solRec1);
            CSS_CampTsbTrp__c solRec3 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB1401689',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                              Type__c='ATC',Doc_Title__c='xyzk' ,Performed__c= true,
                                                              Performed_Review__c= false,Reviewed__c= false , esn__c = '1234',Job_Order__c =Jo.id);
            solutionList.add(solRec3);
            insert solutionList;
            
            
           
             cssTrp = new CSS_CampTsbTrp__c();
            cssTrp.Name = 'Test Trp';
            cssTrp.Job_Order__c = JO.id;
            cssTrp.performed_review__c = true;
            cssTrp.performed__c = false;
            cssTrp.Cu_Language__c = 'Hindi';
            cssTrp.Type__c='TSB';
            insert cssTrp;
            
            // Add Test Attachment fileattach1=new Attachment();
            
            attach=new Attachment(); 
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=jo.id;
            insert attach;
            
            css_tnd_job x = new css_tnd_job();
            x.updatenotes();
            
           
        }  

       public static  User  createBMSUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced'];
            User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, user_Location__c = '56270-56270',
                TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser1@testorg.com');
            insert u;
             System.runAs(u) {
              account at = new account();
              at.name = 'TEst'+math.random();
              at.CSS_DealerCode__c = '56270';
              at.CSS_DistributorCode__c = '56720';
              at.CSS_DBCode__c='33333';
              at.Type = 'Customer';
              insert at;
              }
             return u;
         } 
        
       static testMethod void css_tnd_job_Test_Method1(){   
            TestData();
            JO.ShipDate__c = Date.Today()+1;
            JO.Before_In_Service__c = false;
            JO.Warranty_Start_Date__c = Date.today()+2;
            JO.ESN__c = null;
            JO.Complaint_Type_Desc__c = null;
            JO.Category_Desc__c = null;
            JO.Make__c = null;
            JO.Model__c = null;
            JO.Status__c = 'Repair';
            JO.Sub_Status__c = 'test';
            update JO;
            
            cssSRT.Solution_Number__c = null;
            update cssSRT;
            
            CSS_accountLanguage__c lang = CSS_TestData.createAccountLanguage(true);
            system.assertNotEquals(null, lang);
            cssTrp.ESN__c = '123';
            update cssTrp;
            CSS_JobEventTemporary__c jobEvent =CSS_TestData.createJobEventTempObj(false);
            jobEvent.attribute1__c ='ApplicationCodes';
            jobEvent.Reason__c='{"DataArea":{"Details":[{"Description":"AUTOMOTIVE (C-OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"120","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"130","MarineFlag":"N","DefaultUom":""},{"Description":"BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"200","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"210","MarineFlag":"N","DefaultUom":""},{"Description":"SCHOOL BUS (US & CANADA)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"220","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"300","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"400","MarineFlag":"N","DefaultUom":""},{"Description":"FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"410","MarineFlag":"N","DefaultUom":""},{"Description":"OBSOLETE - TEMP VALUE ONLY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"420","MarineFlag":"N","DefaultUom":""},{"Description":"INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"500","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"600","MarineFlag":"Y","DefaultUom":""},{"Description":"OBSOLETE-TEMP VALUE ONLY(0605)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"605","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE - RECREATIONAL(ALL ENG)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"610","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (INTERMITTENT DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"620","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE DIVISION OF BRUNSWICK","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"625","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0645)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"645","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE(MEDIUM CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"650","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (HEAVY DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"655","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"665","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"700","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0710)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"710","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"OBSOLETE-TEMP VALUE ONLY(0720)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"720","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"800","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"G-Drive Engine Standby","BusinessUnit":"CMI","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"810","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"G-Drive Engine Prime","BusinessUnit":"CMI","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"820","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"830","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"840","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"900","MarineFlag":"N","DefaultUom":""},{"Description":"BRADLEY FIGHTING VEHICLE, LVTP71, OR M9A","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"910","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"920","MarineFlag":"N","DefaultUom":""},{"Description":"AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"930","MarineFlag":"N","DefaultUom":""},{"Description":"5 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"940","MarineFlag":"N","DefaultUom":""},{"Description":"NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"950","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"960","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"10","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"11","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (C--OVER 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"12","MarineFlag":"N","DefaultUom":""},{"Description":"0AUTOMOTIVE (OTHER THAN C-SERIES)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"13","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"20","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (INTERCITY COACH, SHUTTLE AND TRANS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"21","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (SCHOOL BUS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"22","MarineFlag":"N","DefaultUom":""},{"Description":"0BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"23","MarineFlag":"N","DefaultUom":""},{"Description":"0RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"30","MarineFlag":"N","DefaultUom":""},{"Description":"1RECREATIONAL VEHICLE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"31","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"40","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (STANDARD COVERAGE)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"41","MarineFlag":"N","DefaultUom":""},{"Description":"0FIRE TRUCK (SPECIAL PARTS-ONLY COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"42","MarineFlag":"N","DefaultUom":""},{"Description":"0INDUSTRIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"50","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0INDUSTRIAL (EXC. MARINE, AG, GEN DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"51","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"5MARINE - DIAMOND EDITION ENGINES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"60","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"0MARINE (RECR./LT DUTY COMMERCIAL - PERS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"61","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (HIGH OUTPUT RATING","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"62","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-RECREATIONAL (RECREATIONAL RATIN","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"63","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (INTERMITTENT RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"64","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (MEDIUM CONTINUOUS RA","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"65","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"5MARINE-COMMERCIAL (CONTINUOUS RATING)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"66","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"0AGRICULTURE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"70","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MOBILE FARM EQUIPMENT / IRRIGATION PUMP","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"71","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0FARM EQUIPMENT (NON MOBILE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"72","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"80","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"81","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (UNLIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"82","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"83","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"84","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"0MILITARY PACKAGES","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"90","MarineFlag":"N","DefaultUom":""},{"Description":"0BRADLEY FIGHTING VEHICLE, LVTP71, OR M9","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"91","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"92","MarineFlag":"N","DefaultUom":""},{"Description":"0AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"93","MarineFlag":"N","DefaultUom":""},{"Description":"05 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"94","MarineFlag":"N","DefaultUom":""},{"Description":"0NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"95","MarineFlag":"N","DefaultUom":""},{"Description":"0TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"96","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"AUTOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"100","MarineFlag":"N","DefaultUom":""},{"Description":"AUTOMOTIVE (C-UP TO 225 HP)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"110","MarineFlag":"N","DefaultUom":""},{"Description":"BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"230","MarineFlag":"N","DefaultUom":""},{"Description":"RECREATIONAL VEHICLE","BusinessUnit":"CMI","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"310","MarineFlag":"N","DefaultUom":""},{"Description":"WORLDWIDE OFF-HIGHWAY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"510","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (PRIME/CONTINUOS PRIME POWER)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"635","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (CONTINUOUS DUTY)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"660","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"FORD GRAY AUTO","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"140","MarineFlag":"N","DefaultUom":""},{"Description":"FORD GRAY BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"240","MarineFlag":"N","DefaultUom":""},{"Description":"ISC-SERIES","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"150","MarineFlag":"N","DefaultUom":""},{"Description":"CMD NONQUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"621","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"651","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"656","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD NONQUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"661","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"RECREATIONAL VEHICLE AD","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"Y","ApplicationCode":"320","MarineFlag":"N","DefaultUom":""},{"Description":"KA91 MARINE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"890","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - RECREATIONAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"670","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - INTERMITTENT","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"675","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - GOVERNMENT SERVICE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"680","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"685","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - HEAVY DUTY","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"690","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"CMD QUANTUM - CONTINUOUS","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"695","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"KA91 GENERATOR DRIVE GENERIC","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"891","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"WORLDWIDE WELDER COVERAGE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"520","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"G-Drive (HHP Lean-Burn Gas)","BusinessUnit":"CMI","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"850","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"THOMAS BUILT BUS","BusinessUnit":"EBU","AutomotiveFlag":"Y","ActiveFlag":"N","ApplicationCode":"250","MarineFlag":"N","DefaultUom":""},{"Description":"CMD QUANTUM - LIGHT COMMERCIAL","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"N","ApplicationCode":"699","MarineFlag":"N","DefaultUom":"Hours"},{"Description":"MARINE (LIGHT COMMERCIAL)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"662","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"MARINE (GOVERNMENT SERVICE)","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"663","MarineFlag":"Y","DefaultUom":"Hours"},{"Description":"QSK95 T4 LOCOMOTIVE","BusinessUnit":"EBU","AutomotiveFlag":"N","ActiveFlag":"Y","ApplicationCode":"530","MarineFlag":"N","DefaultUom":"Hours"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"';
            jobEvent.Reason__c ='{'+
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
           insert jobEvent;
            CSS_JobEventTemporary__c jobEvent1 =CSS_TestData.createJobEventTempObj(false);
            jobEvent1.attribute1__c ='CategoryComplaintCodes';
            jobEvent1.Reason__c = '{'+    
    '  \"Header\": {'+
    '    \"ReturnCodeDescription\": \"test\",'+
    '    \"Status\": \"completed\"'+
    '      },'+
    '\"DataArea\": {'+
    '\"Details\": ['+
    '{'+
    '\"ComplaintCode\": \"1117\",'+
    '\"Description\": \"21319736\",'+
    
            '\"BusinessUnit\": \"inactive\",'+
    '\"Category\": \"1\"'+
    '},'+
    '{'+
    '\"ComplaintCode\": \"1117\",'+
    '\"Description\": \"21319736\",'+
    '\"BusinessUnit\": \"inactive\",'+
            
    '\"Category\"    : \"1\"'+
    '},'+
            '{'+
    '\"ComplaintCode\": \"1117\",'+
    '\"Description\": \"21319736\",'+
    
            '\"BusinessUnit\": \"inactive\",'+
    '\"Category\"    : \"1\"'+
    '},'+
            '{'+
    '\"ComplaintCode\": \"1117\",'+
    '\"Description\": \"21319736\",'+
    
            '\"BusinessUnit\": \"inactive\",'+
    '\"Category\"    : \"1\"'+
    '}'+
                
    ']'+
            '}'+
    '}';
           insert jobEvent1;
            //added to increase the coverage for contact lookup method 
            test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
            // Add test data for creating service job record
            Test.startTest();        
           
            // Add test data for TnD page
            css_tnd_job TriageJob= new css_tnd_job ();
            TriageJob.sEngineFamilyCode='878';
            ApexPages.currentPage().getParameters().put('id',jo.Id); 
            
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',jo.Id); 
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.newQuoteStr = 'Sample';
            TriageJob1.showRepairErrorMessage = true;
            TriageJob1.displayBMSuserClosePopup = true;
            TriageJob1.workJob = JO;
            TriageJob1.timeinMinutes = 10;
            TriageJob1.timeinhours = 20;
            TriageJob1.fcid = 'a';        
            TriageJob1.atthId=attach.id;
            TriageJob1.fileBody =Blob.valueOf('Unit Test Attachment Body');
            TriageJob1.fileBody2 =Blob.valueOf('Unit Test Attachment Body');
            TriageJob1.fileBody3 =Blob.valueOf('Unit Test Attachment Body');
            TriageJob1.editAttachment();
            string x=TriageJob1.getmil_measure();
            TriageJob1.setmil_measure(x);
            TriageJob1.getfail_measure();
            TriageJob1.setfail_measure(x);
            TriageJob1.getItems();
            //TriageJob1.getDSID();
            TriageJob1.tnd_jo();
            TriageJob1.selectedContactID = '213897';
            TriageJob1.sServiceModel = 'a';
            TriageJob1.InperformBoolean = true;
            TriageJob1.dsidStatus = true;
            TriageJob1.isPrioritized = true;
            //TriageJob1.DSID = 'DSBDT4760';
            TriageJob1.InsiteTimeStr = 'abc'; 
            TriageJob1.wr_btn_cls = 'we';
            TriageJob1.wr_chv_sts = 'we';
            TriageJob1.wr_txt_sts = 'we';
            TriageJob1.wr_txt_val = 'we';
            TriageJob1.HHSPSMNFlg = true;
            TriageJob1.HHSPACCSFlg = true;
            TriageJob1.displaycertPopup = true;
            TriageJob1.displaySrvModPopup = true;
            TriageJob1.displaySrvModPopup1 = true;
            TriageJob1.editTriage = true;
            TriageJob1.showViewEdit = true;
            TriageJob1.show_wr_pnl = true;
            TriageJob1.rowcount = 5;
            TriageJob1.getLocations();
            //TriageJob1.SolID = 'abc';
            TriageJob1.getfilterMake();
            TriageJob1.setfilterMake(X);
            TriageJob1.getfilterModel();
            TriageJob1.setfilterModel(x);
            TriageJob1.fetchModelRecords();
            TriageJob1.RPVcallSecWebService();
            TriageJob1.css_redirect();
             TriageJob1.reqUNumBoolean=true;
            TriageJob1.reqCusNumBoolean=true;
            TriageJob1.reqFrstNamBoolean=true;
            TriageJob1.reqLastNamBoolean=true;
            TriageJob1.reqCstmrContactPhnBoolean=true;
            TriageJob1.reqUTBoolean=true;
            TriageJob1.allFieldsValidate=true;
            TriageJob1.validateBeforeSave();
            TriageJob1.getCategoryList();
            TriageJob1.getComplaintTypeList();
            TriageJob1.getComplaintTypeList2();
            TriageJob1.getComplaintTypeList3();
            TriageJob1.getComplaintTypeList4();
            TriageJob1.getComplaintTypeList5();
            TriageJob1.getApplication();
            TriageJob1.updateproductappcode();
            TriageJob1.getSubStatus();
            TriageJob1.closeBMSContDetails();
            TriageJob1.selectedContactDetails();
            TriageJob1.selectedContactID = 'ert';
            TriageJob1.ContactLookup();
            TriageJob1.bmsContacterrorMessage = 'ESN';
            TriageJob1.contactshowOutageError= False;
            TriageJob1.selectedBMSCustCode();
            TriageJob1.closeBMSCustDetails();
            TriageJob1.selectedCustDetails();
            TriageJob1.getBMSCustDetails();
            TriageJob1.bmscustErrorMessage ='true';
            TriageJob1.strCntryState='true';
            TriageJob1.strCntry='true';
            TriageJob1.getfilterCategory();
            TriageJOb1.setfilterCategory('test');
            TriageJob1.getfilterCategory2();
            TriageJob1.setfilterCategory2('test');
            TriageJob1.getfilterCategory3();
            TriageJob1.setfilterCategory3('test');
            TriageJob1.getfilterCategory4();
            TriageJob1.setfilterCategory4('test');
            TriageJob1.getfilterCategory5();
            TriageJob1.setfilterCategory5('test');
            TriageJob1.getfilterComplaintType();
            TriageJob1.setfilterComplaintType('test');
            TriageJob1.getfilterComplaintType2();
            TriageJob1.setfilterComplaintType2('test');
            TriageJob1.getfilterComplaintType3();
            TriageJob1.setfilterComplaintType3('test');
             TriageJob1.getfilterComplaintType4();
            TriageJob1.setfilterComplaintType4('test');
            TriageJob1.getfilterComplaintType5();
             TriageJob1.setfilterComplaintType5('test');
            TriageJob1.ShowSubStatuspopup2=true;
            //TriageJob1.getCampaignDetails();
            TriageJob1.getFailureDate();
            TriageJob1.selectedESNnUnitDetails();
            //commented since onshore team commented method in apex class
            //TriageJob1.getInsiteTimeStr();
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            //
            TriageJob1.sOrgType = 'DLR';
            TriageJob1.rpvcontinue();
            TriageJob1.getControlNum();
            TriageJob1.setControlNum(X);
            TriageJob1.tnd_vh();
            TriageJob1.getModel();
            TriageJob1.workjob.Make__c='Test';
            TriageJob1.workjob.Complaint_Type__c='AIR LEAK';
            TriageJob1.accountlang = lang;
            //mocking the quick serve one service method call since it is callen fron the qsollanguage.
            //Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
            TriageJob1.qsollanguage();
            //updating the language to cover the varios condition in qsollanguage() method.
            //cssTrp.Cu_Language__c='English';
            //update cssTrp;
            //TriageJob1.qsollanguage();
            TriageJob1.pgSaveAssign();
           
            Test.stopTest();
        }
        
       static testMethod void css_tnd_job_Test_Methodtest(){
             TestData();
            JO.ShipDate__c = Date.Today()-1;
            JO.Unit_Type__c = 'testing';
            update JO;
            
            cssSRT.type__c = 'Repair';
            cssSRT.Solution_Number__c = null;
            update cssSRT;
            CSS_accountLanguage__c lang = CSS_TestData.createAccountLanguage(true);
            system.assertNotEquals(null, lang);
            cssTrp.ESN__c = '123';
            update cssTrp;
            //added to increas the coverage 
            
            CSS_Integration_Details__c ci = css_TestData.createIntegrationDetails(false);
            ci.ApplicationName__c = 'InsiteImage';
            ci.name = 'InsiteImage';
            ci.End_Point__c = 'https://connectedsolutions-stg.cummins.com/INSITEImage/v98/imagefile';
            insert ci;
            Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
            Test.startTest();
            css_tnd_job TriageJob= new css_tnd_job ();
            TriageJob.sEngineFamilyCode='878';
            ApexPages.currentPage().getParameters().put('id',jo.Id); 
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',jo.Id);
            ApexPages.currentPage().getParameters().put('fileName','fileName');
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.accountlang = lang;
          //Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
            TriageJob1.qsollanguage();
            TriageJob1.getFile();
            TriageJob1.getCampaignDetails();
            TriageJob1.updateproductappcode();
            //TriageJob1.createAttachment(Blob.valueOf('Unit Test Attachment Body'));
            // TriageJob1.updateNotes();
            Test.stopTest();
        }
      
       static testMethod void css_tnd_job_Test_Method2(){
            TestData();
            JO.Application_Desc__c = 'AUTOMOTIVE';
            JO.Email_check_box__c = true;
            JO.Warranty_Start_Date__c = system.today();
            JO.warranty_start_date__c = null;
            update JO;        
            
            faultCode.Fault_Code_Type__c = 'ADP-R';
            update faultCode;
            
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',jo.Id);
            
            Test.startTest();         
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.sEngineFamilyCode = 'testing';
            TriageJob1.atthId=attach.id;
            TriageJob1.dsidIndi = 'O';
            TriageJob1.getFaultCodes();
            TriageJob1.getMake();
            TriageJob1.getModel();
            TriageJob1.tnd_vi();
            TriageJob1.tnd_ts();
            TriageJob1.tnd_rj();
            TriageJob1.Cancel();
            TriageJob1.pgsave();
            TriageJob1.pgSaveFinish();
            TriageJob1.pgCustSave();
            TriageJob1.pgUISave();
            TriageJob1.pgCompSave();
            
            TriageJob1.getViewHistory();
            //TriageJob1.ChkFieldBlank();
            TriageJob1.workjob.Make__c='';
            TriageJob1.pgSaveAssign();
            //TriageJob1.updateproductappcode();
            Test.stopTest();
        }
        
       static testMethod void css_tnd_job_Test_Method8(){
            TestData();
            JO.Email_check_box__c = false;
            JO.Make__c = null;
            update JO;
            
          cssSol.Repair_Response__c = 'Repair Successful';
          update cssSol;
            
             AddsolComp.Selected_Component__c = True;
            update AddsolComp;
            
            cssSRT.Type__c = 'Repair'; 
            cssSRT.isPerformed__c = true;
            cssSRT.Component_Id__c = AddsolComp.id;
            cssSRT.Solution_Number__c = cssSol.id;
            cssSRT.Assignment__c = 'Primary';
            update cssSRT;
            
    
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',jo.Id);
            
           // css_tnd_job.CSS_JobOrderWrapper jobWrap = new css_tnd_job.CSS_JobOrderWrapper(JO.id,'filterMake','filterModel','mil_measure','fail_measure','filterCountry','filterState',true,'EmailAddress','EmailAddress1',false)
            
            Test.startTest();
            css_tnd_job TriageJob4 = new css_tnd_job();
            TriageJob4.strEDSCodes = 'test' ;
            TriageJob4.ShowSubStatuspopup = 'true';
            TriageJob4.workjob.Category__c='';
            TriageJob4.validateBeforeSave();
            TriageJob4.jobClosePopup();
            TriageJob4.pgSaveAssign();
            TriageJob4.pgCustSave();
            TriageJob4.pgSave();
            TriageJob4.updateproductappcode();
            Test.stopTest();
        }
        
       static testMethod void css_tnd_job_Test_Method9(){
            TestData();
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',jo.Id);
            String QId = 'abc';
            Test.startTest();
            css_tnd_job TriageJob5 = new css_tnd_job ();
            TriageJob5.recconFlag = true;
            TriageJob5.workjob.Complaint_Type_Desc__c='';
            //TriageJob5.workjob.Complaint_Type__c='';
            TriageJob5.pgSaveAssign();
            TriageJob5.updateproductappcode();
            TriageJob5.getApplicationCodes();
            Test.stopTest();
        }
        
       static testMethod void css_tnd_job_Test_Method10(){
           
            TestData();
            
            Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;

            //Update Job order
            JO.BMSStatus__c = 'WC1';
            Jo.Account__c = acc.id;
            update JO;
            
            CSS_Solutions__c sol = CSS_TestData.createSolutions(true,jo.id);
    
            CSS_Claims__c claims = new CSS_Claims__c();
            claims.CSS_Job__c=jo.id;
            claims.Account__C = acc.id;
            insert claims;
        
            CSS_SRT__c srt= CSS_TestData.createSRT_New(true,'Diagnosis',sol.id,jo.id,claims.id);
            
            
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',jo.Id);
            Test.startTest();
            css_tnd_job TriageJob6 = new css_tnd_job ();
            //TriageJob6.workjob.Application__c='';
            TriageJob6.workjob.Application_Desc__c='';
            TriageJob6.pgSaveAssign();
            TriageJob6.bmsEnabled = true;
            TriageJob6.tndverification();
            Test.stopTest();
        }
        
       static testMethod void css_tnd_job_Test_Method7(){
            TestData();
            JO.Status__c = 'Triage & Diagnosis';
            JO.Warranty_Start_Date__c = date.today()+1;
            update JO;
            
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',jo.Id);
            Test.startTest();
            css_tnd_job TriageJob3 = new css_tnd_job ();
            TriageJob3.atthId=attach.id;
            TriageJob3.delAttachment();
            Id i = TriageJob3.VMore_JobId=jo.id;
            TriageJob3.fileBody = Blob.valueOf('Unit Test Attachment Body');
            TriageJob3.fileBody2 = Blob.valueOf('Unit Test Attachment Body');
            TriageJob3.fileBody3 = Blob.valueOf('Unit Test Attachment Body');
            TriageJob3.fileName = 'sample File';
            TriageJob3.fileName2 = 'sample File2';
            TriageJob3.fileName3 = 'sample File3';
            TriageJob3.processUpload();
            TriageJob3.workjob.ESN__c='';
            TriageJob3.pgSaveAssign();
            TriageJob3.gettoken();
            Test.stopTest();
        }
        
       static testMethod void css_tnd_job_Test_Method6(){
            TestData();
            JO.Customer_Name__c = null;
            JO.Shop_Work_Order__c = null;
            JO.Unit_number__c = null;
            JO.Mileage__c = null;
            JO.ESN__c = null;
            JO.General_Symptoms__c = null;
            JO.Sub_Status__c = 'test';
            update JO;
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',jo.Id);
            Test.startTest();        
            css_tnd_job TriageJob2 = new css_tnd_job ();
            //TriageJob2.ChkFieldBlank();
            TriageJob2.workjob.Model__c='';
            TriageJob2.pgSaveAssign();
            Test.stopTest();
        }  
        
       static testMethod void css_tnd_job_Test_Method3(){  
            Test.startTest(); 
            TestData();
            JO.Model__c = null;
            update JO;
            
            CSS_accountLanguage__c lang = CSS_TestData.createAccountLanguage(true);
            cssTrp.ESN__c = '123';
            update cssTrp; 
           
            //mocking the quick serve one service method call since it is callen fron the qsollanguage.
           // Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());       
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',jo.Id); 
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.atthId=attach.id;
            TriageJob1.accountlang = lang;
            Test.setMock(HttpCalloutMock.class, new CSS_Exit_Test());
            CSS_EDSAuthentication.exitDSID('1234-5678','DSBDT4780'); 
            TriageJob1.dsidIndi = 'O';
            TriageJob1.showPopup();
            TriageJob1.showTnDBlocks(false,false,false, false, false);
            //TriageJob1.showTnDBlocks(false,false,true, false, false);
            TriageJob1.closePopup();
            //TriageJob1.closeSubStatusPopup();
            TriageJob1.closeSrvModPopup();
            TriageJob1.closeSrvModPopup1();
         //ED Cuncomment   TriageJob1.getAtcs();
            TriageJob1.redirectPopup();
            TriageJob1.showPopup1();
          //  TriageJob1.SolCompToBMS = 'abc';
          //  TriageJob1.SolResponse = 'abc';
          //  TriageJob1.BMSFailureID = 'cde';
         //   TriageJob1.NestSolCompToBMS = 'ded';
         //   TriageJob1.NestSolResponse = 'abc';
         //   TriageJob1.NestBMSFailureID = 'dasd';
            TriageJob1.getFaultCodes();
            TriageJob1.closePopup1();
            TriageJob1.showPopup4();
            TriageJob1.closePopup4();
            TriageJob1.showPopup5();
            TriageJob1.closePopup5();
            TriageJob1.showPopup6();
            TriageJob1.showPopup7();
            TriageJob1.closePopup7();
            TriageJob1.showPopup8();
            TriageJob1.closePopup8();
            
            TriageJob1.getRepair();
            TriageJob1.processUpload();
            TriageJob1.popupSave();
            TriageJob1.DeleteFile();
            Test.setMock(HttpCalloutMock.class, new CSS_RPVSecMock_Test());
           
            TriageJob1.getALLRecords();
            TriageJob1.closePopup6();
            TriageJob1.getCamps();
            TriageJob1.getTrps();
            TriageJob1.getTsbs();
            TriageJob1.getAtcs();
            //TriageJob1.saveCheckBox();
            TriageJob1.getRepair();
            Test.setMock(HttpCalloutMock.class, new CSS_CreateDSID_Test());
            TriageJob1.createDSID();
            
            delete cssSol;
           TriageJob1.bmsEnabled = true;
            JO.Customer_Code__c = null;
            TriageJob1.closeSession();
            JO.First_Name__c = null;
            TriageJob1.validateBeforeSave();
            TriageJob1.showRepairs = false;
            TriageJob1.showResolutionWithRepair = true;
            TriageJob1.saveAndCloseJob();
            //Date d = system.today();
            string QSOLDate = '15-11-2016';
            Date parseQSOLDate = TriageJob1.parseQSOLDate(QSOLDate);
            
            CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
            cid.name = 'CSS_SPDataLookup';
            cid.ApplicationName__c = 'CSS_SPDataLookup';
            cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdataTest';
            insert cid;
            
            Test.setMock(HttpCalloutMock.class , new CG_getServiceProviderDataIntakemock_test());
             
              
        
            
            TriageJob1.startRequestBMS();
            TriageJob1.getBMSUnitDetails();
            TriageJob1.selectedBMSUnitNumber();
            TriageJob1.getBMSUnitDetails();
            TriageJob1.selectedUnitDetails();
            TriageJob1.closeBMSUnitDetails();
            cssSol = new CSS_Solutions__c();
            cssSol.Name = 'Test Solution';
            cssSol.service_job__c = JO.id;
            cssSol.Out_Of_Order__c = true;
            cssSol.Diagnostic_Response__c = 'Most likely the solution';
            insert cssSol;
           // TriageJob1.cause();
            string serviceModelName = 'Test';
          //  TriageJob1.getCertificationStatus(serviceModelName);
          Test.stopTest();  
            
        } 
        
       static testMethod void css_tnd_job_Test_Method4(){
            Test.startTest(); 
            TestData();
            Jo.ESN__c = '123.00';
            update Jo;
            
            CSS_TestData.createIntegrationDetails(true);
            Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
            Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
             CSS_Job_Order__c job1 =CSS_TestData.createJobOrder(true);
            //job1.ESN__c = '123.00';
            //update job1;
            
            PageReference pref;
            pref = new PageReference('/'+Jo.id);
            pref.getParameters().put('id',Jo.id);
            Test.setCurrentPage(pref);
            
           
            CSS_Solutions__c sol =CSS_TestData.createSolutions(true,Jo.Id);
            
            List<CSS_Recon_Engine_Ranges__c> listRecEngRange = new List<CSS_Recon_Engine_Ranges__c>();
            CSS_Recon_Engine_Ranges__c RecEngRange = new CSS_Recon_Engine_Ranges__c();
            //RecEngRange.IsDeleted = true;
            RecEngRange.Name ='test';
            RecEngRange.Max_Value__c = 124.00;
            /*LastModifiedDate=2017-12-20 15:01:46, IsDeleted=false, Min_Value__c=2.9100101E7, CreatedById=00561000002FQqWAAW, CreatedDate=2017-12-20 15:01:46, Max_Value__c=2.9999999E7, Id=a1d610000013OJSAA2, LastModifiedById=00561000002FQqWAAW, SetupOwnerId=00D29000000ES7REAW, Name=Range4, SystemModstamp=2017-12-20 15:01:46}, CSS_Recon_Engine_Ranges__c:{LastModifiedDate=2017-12-20 15:01:46, IsDeleted=false, Min_Value__c=6.7100101E7, CreatedById=00561000002FQqWAAW, CreatedDate=2017-12-20 15:01:46, Max_Value__c=6.7999999E7, Id=a1d610000013OJTAA2, LastModifiedById=00561000002FQqWAAW, SetupOwnerId=00D29000000ES7REAW, Name=Range6, SystemModstamp=2017-12-20 15:01:46}, CSS_Recon_Engine_Ranges__c:{LastModifiedDate=2017-12-20 15:01:46, IsDeleted=false, Min_Value__c=6.1100101E7, CreatedById=00561000002FQqWAAW, CreatedDate=2017-12-20 15:01:46, Max_Value__c=6.1999996E7, Id=a1d610000013OJUAA2, LastModifiedById=00561000002FQqWAAW, SetupOwnerId=00D29000000ES7REAW, Name=Range1, SystemModstamp=2017-12-20 15:01:46}, CSS_Recon_Engine_Ranges__c:{LastModifiedDate=2017-12-20 15:01:46, IsDeleted=false, Min_Value__c=4.8100101E7, CreatedById=00561000002FQqWAAW, CreatedDate=2017-12-20 15:01:46, Max_Value__c=4.8999999E7, Id=a1d610000013OJVAA2, LastModifiedById=00561000002FQqWAAW, SetupOwnerId=00D29000000ES7REAW, Name=Range5, SystemModstamp=2017-12-20 15:01:46}, CSS_Recon_Engine_Ranges__c:{LastModifiedDate=2017-12-20 15:01:46, IsDeleted=false, Min_Value__c=2.7100101E7, CreatedById=00561000002FQqWAAW, CreatedDate=2017-12-20 15:01:46, Max_Value__c=2.7999999E7, Id=a1d610000013OJWAA2, LastModifiedById=00561000002FQqWAAW, SetupOwnerId=00D29000000ES7REAW, Name=Range3, SystemModstamp=2017-12-20 15:01:46}, CSS_Recon_Engine_Ranges__c:{LastModifiedDate=2017-12-20 15:01:46, IsDeleted=false, Min_Value__c=6.0100101E7, CreatedById=00561000002FQqWAAW, CreatedDate=2017-12-20 15:01:46, Max_Value__c=6.0999999E7, Id=a1d610000013OJXAA2, LastModifiedById=00561000002FQqWAAW, SetupOwnerId=00D29000000ES7REAW, Name=Range2, SystemModstamp=2017-12-20 15:01:46*/       
            RecEngRange.Min_Value__c = 122.00;
            //RecEngRange.SystemModstamp = System.now();
            //RecEngRange.Id = '123';
            insert RecEngRange;
            listRecEngRange.add(RecEngRange);
              
            
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.accountlang = css_TestData.createAccountLanguage(true);
            TriageJob1.showResolutionWithRepair = false;
            TriageJob1.showRepairs = true;
            TriageJob1.showResolution = true;
            TriageJob1.pgCustSave();
            TriageJob1.jobClosePopup();
            TriageJob1.closeSession_close();
            TriageJob1.closeSession();
            TriageJob1.getTsbsRecords();
            delete cssTrp;
            TriageJob1.getBMSUnitDetails();
            TriageJob1.getBMSUnitDetailsfromUnitNumber();
            TriageJob1.selectedUnitDetails();
            TriageJob1.closeBMSUnitDetails();
           // TriageJob1.getCertificationStatus(JO.Service_Model__c);
            TriageJob1.processUpload();
            TriageJob1.Wid=null;
            TriageJob1.Cancel();
            TriageJob1.updateproductappcode();
            //TriageJOb1.startRequest();  
            Test.stopTest();
        } 
        
       static testMethod void css_tnd_job_Test_Method5(){
                    
            TestData();
            JO.Before_In_Service__c = true;
            JO.Mileage__c = 1.02;
            JO.Warranty_Start_Date__c = system.today();
            JO.Application_Desc__c = 'WORLDWIDE OFF-HIGHWAY';
            
            update JO;
            
            Test.startTest();
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.recconFlag = true;
            TriageJob1.warrantyDate = system.today() + 1;
            TriageJob1.atthId = null;
            //TriageJob1.saveCheckBox();
            TriageJob1.delAttachment();
            TriageJob1.editAttachment();
            TriageJob1.CompareDates();
            TriageJob1.pgCustSave();
            TriageJob1.closeSession();
            TriageJob1.getMake();
            TriageJob1.getModel();
            TriageJob1.rpvContinue();
            //TriageJob1.getAttachment('abc');
            TriageJob1.RPVcallSecWebService();
            //TriageJob1.pgSave();
           
            Test.stopTest();
        } 
        
       static testMethod void css_tnd_job_Test_Method13(){
            
            TestData();
            
            
            JO.Customer_Name__c = null;
            JO.Shop_Work_Order__c = null;
            JO.Unit_number__c = null;
            JO.Mileage__c = null;
            JO.ESN__c = null;
            JO.Customer_Name__c = null;
            JO.Shop_Work_Order__c = null;
            JO.General_Symptoms__c = null;
            JO.Repair_Location__c = 'Mobile';
            JO.BMSStatus__c = 'test';
            update JO;
            
            faultCode.Fault_Code_Type__c ='APD-P';
            update faultCode;
            
            Test.startTest();        
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.filterApplication = null;
            TriageJob1.getFaultCodes();
            TriageJob1.tnd_jo();
            TriageJob1.tnd_vh();
            TriageJob1.tnd_rj();
            TriageJob1.pgSave();
            //TriageJob1.ChkFieldBlank();
            TriageJob1.pgUISave();
            TriageJob1.callCreateWoAndUpdateComment();
            Test.stopTest();
            
        }  
        
       static testMethod void css_tnd_job_Test_Method11(){
            
            TestData();
            JO.Customer_Name__c = null;
            JO.Shop_Work_Order__c = null;
            JO.Application_Desc__c = null;
            JO.Warranty_Start_Date__c = system.today();
            update JO;
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',jo.Id);
            Test.startTest();
            css_tnd_job TriageJob1 = new css_tnd_job ();
            TriageJob1.workjob.Repair_Location__c = 'Mobile';
             Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
            TriageJob1.callCreateWoAndUpdateComment();
            Test.stopTest();
    
        } 
        
       static testMethod void engineDataSiebel(){ 
            
            Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
            Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
            
            CSS_Job_Order__c JOsr= new CSS_Job_Order__c ();
            JOsr.ESN__c='79384192'; 
            insert JOsr;
            
            CSS_List_Of_Values__c CLV = new CSS_List_Of_Values__c();
            CLV.Picklist_Values_1__c = 'AUTOMOTIVE';
            CLV.type__c = 'Application Code';
            CLV.Name = 'getEngine';
           // CLV.code__C = '1';
            insert CLV;
            
            
            
            Test.startTest();
            css_tnd_job IntakeJobRstartReq = new css_tnd_job ();
            IntakeJobRstartReq.workJob=JOsr;
            CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
            CSS_getEngineDataResponseJ2A  engineData;
            CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
            jidi.ESN =JOsr.ESN__c;
            wrapobj.DataArea = jidi;
           
            
           // engineData = CSS_WS_SBL.getEngineData(wrapobj);
         
            IntakeJobRstartReq.siebAppCode = 'testing';
            IntakeJobRstartReq.jobClosePopup();
           //IntakeJobRstartReq.startRequest();
            IntakeJobRstartReq.Cancel();
            IntakeJobRstartReq.getALLRecords_old();
            
            Test.stopTest();
        }
        
       static testMethod void engineDataSiebelESNull(){ 
            
            Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());
            Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
            
            css_tnd_job IntakeJobRstartReq = new css_tnd_job ();
            CSS_Job_Order__c JOsr= new CSS_Job_Order__c ();
            JOsr.ESN__c= null; 
            insert JOsr;
            
            Test.startTest();
            IntakeJobRstartReq.workJob=JOsr;
            CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
            CSS_getEngineDataResponseJ2A  engineData;
            CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
            jidi.ESN =JOsr.ESN__c;
            wrapobj.DataArea = jidi;
           
            
            engineData = CSS_WS_SBL.getEngineData(wrapobj);
         
            
          //intakeJobRstartReq.startRequest();
            
            Test.stopTest();
        }
        
       static testMethod void engineDataSiebel1(){ 
            
            Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel2_Test());
            //Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test()); 
            
            CSS_Job_Order__c JOsr= new CSS_Job_Order__c ();
            JOsr.ESN__c='79384192'; 
            insert JOsr;
            
            CSS_List_Of_Values__c CLV = new CSS_List_Of_Values__c();
            CLV.Picklist_Values_1__c = 'AUTOMOTIVE';
            CLV.type__c = 'Application Code';
            CLV.Name = 'getEngine';
           // CLV.code__C = '1';
            insert CLV;
            
            
            
            Test.startTest();
            css_tnd_job IntakeJobRstartReq = new css_tnd_job ();
            IntakeJobRstartReq.workJob=JOsr;
            CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
            CSS_getEngineDataResponseJ2A  engineData;
            CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
            jidi.ESN =JOsr.ESN__c;
            wrapobj.DataArea = jidi;
           
            
           // engineData = CSS_WS_SBL.getEngineData(wrapobj);
         
            IntakeJobRstartReq.siebAppCode = 'testing';
            IntakeJobRstartReq.jobClosePopup();
            //IntakeJobRstartReq.startRequest();
            IntakeJobRstartReq.Cancel();
            IntakeJobRstartReq.getALLRecords_old();
            IntakeJobRstartReq.getControlNum();
            IntakeJobRstartReq.setControlNum('test');
            
            Test.stopTest();
        }
        
       static testMethod void css_tnd_job_Test_Method12(){
                  
            TestData();
            
            
            JO.Service_Model__c = null;
            JO.ESN__c = '1234';
            JO.Mileage_Measure__c = '12';
            JO.Failure_Point_Measure__c = null;
            JO.Failure_Date__c = null;
            JO.Category_Desc__c = 'testing';
            JO.Category2_Desc__c = 'testing1';
            JO.Category3_Desc__c = 'testing2';
            JO.Category4_Desc__c = 'testing1';
            JO.Category5_Desc__c = 'testing1';
            JO.Complaint_Type_Desc__c = 'test';
            JO.Complaint_Type2_Desc__c = 'test';
            JO.Complaint_Type3_Desc__c = 'test';
            JO.Complaint_Type4_Desc__c = 'test';
            JO.Complaint_Type5_Desc__c = 'test';
            update JO;
            
            cssSRT.Type__c = 'Repair';
            cssSRT.srt_time__c = 12.3;
            cssSRT.isPerformed__c = true;
            cssSRT.Assignment__c ='Primary';
            update cssSRT;
            
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.updateNotes();
            CSS_TestData.createIntegrationDetails(true);
            Test.startTest(); 
            Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
            TriageJob1.getQSOLDocs();
            //TriageJOb1.startRequest();
            TriageJob1.getLocCode();
            Test.stopTest();
            
        }  
        
        static testMethod void css_tnd_job_Test_Method14(){
                  
           // TestData();
           PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
           ApexPages.currentPage().getParameters().put('rjHistory','RJ');
           CSS_Job_Order__c job1 =CSS_TestData.createJobOrder(false);
            job1.CSS_Hours__c = 1;
            insert job1;
            CSS_Solutions__c sol =CSS_TestData.createSolutions(true,job1.Id);
            sol.Repair_Response__c = 'Repair Successful';
            
            CSS_JobEventTemporary__c jobEvent =CSS_TestData.createJobEventTempObj(false);
            jobEvent.attribute1__c ='SubType';
            jobEvent.Key__c='56270-56270';
            jobEvent.Reason__c='{"Header":{"Status":"success","ReturnCodeDescription":"Parts Updated successfully","Location":{"LocationID":"02400-02394"}}}';
            insert jobEvent;
            CSS_JobEventTemporary__c jobEvent1 =CSS_TestData.createJobEventTempObj(false);
            jobEvent1.attribute1__c ='UnitTypes';
            jobEvent1.Key__c='56270-56270';
            jobEvent1.Reason__c='{"Header":{"Status":"success","ReturnCodeDescription":"Parts Updated successfully","Location":{"LocationID":"02400-02394"}}}';
            insert jobEvent1;
            ApexPages.CurrentPage().getParameters().put('id',Job1.id);
            css_tnd_job TriageJob1= new css_tnd_job ();
            Test.startTest(); 
            //TriageJob1.jobClosePopup();
            TriageJob1.jobClosePopup();
            TriageJob1.closeSession();
            TriageJob1.getUnitType();
            TriageJob1.getSubType();
            Test.stopTest();
            
        }  
        
        static testMethod void css_tnd_job_Test_Method15(){
            Test.startTest(); 
           
            CSS_Job_Order__c job =CSS_TestData.createJobOrder(true);
            job.ESN__c = 'testing';
            update Job;
            
            CSS_Solutions__c solAdd = new CSS_Solutions__c();
            solAdd.Service_Job__c = job.Id;
            solAdd.Case_Name__c = 'Additional SRTS';
            solAdd.Solution_Title__c='Additional SRTS';
            solAdd.Diagnostic_Response__c = 'Most Likely the Solution';
           
            insert solAdd;
            
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
             ApexPages.currentPage().getParameters().put('id',job.Id);
            
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.jobClosePopup();
            TriageJob1.closeSession_close();
            TriageJob1.closeSession();
            Test.stopTest();
        }  
        
        static testMethod void css_tnd_job_Test_Method51(){
            Test.startTest(); 
            
            CSS_Job_Order__c job =CSS_TestData.createJobOrder(true);
            job.ESN__c = 'testing';
            update Job;
            
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',job.Id);
            
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.jobClosePopup();
            TriageJob1.closeSession_close();
            TriageJob1.closeSession();
    
            Test.stopTest();
        }
        
        static testMethod void css_tnd_job_Test_Method16(){
            CSS_Job_Order__c job =CSS_TestData.createJobOrder(false);
            job.Customer_Name__c = null;
            job.PSN_Not_Available__c = false;
            
            PageReference p=Page.CSS_JobTnDRj; 
            Test.setCurrentPage(p);  
            ApexPages.currentPage().getParameters().put('id',job.Id); 
            Test.startTest();        
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.workJob = job;
            TriageJob1.filterApplication = '';
            //TriageJob1.pgCustSave();
            TriageJob1.validateBeforeSave();
            TriageJob1.getLocations();
            TriageJob1.tnd_jo();
            TriageJob1.Wid=null;
            TriageJob1.tnd_vh();
            TriageJob1.Wid=null;
            TriageJob1.tnd_rj();
            TriageJob1.Wid=null;
            TriageJob1.pgSave();
           
            TriageJob1.Wid=null;
            TriageJob1.pgSaveFinish();
            TriageJob1.Wid=null;
            TriageJob1.popupSave();
           
            Test.stopTest();
        } 
        
        static testMethod void css_tnd_job_Test_Method17(){
            css_tnd_job TriageJob1= new css_tnd_job ();
            TriageJob1.getLocCode();
            TriageJob1.NoUnitNumberResponse = true;
            List<Note> a = new List<Note>();
            TriageJob1.workJob1 = a;
            List<CSS_CampTsbTrp__c> b = new List<CSS_CampTsbTrp__c>();
            TriageJob1.lstTRP = b;
    TriageJob1.lstATC = b;
    TriageJob1.SolID = null;
            list<CSS_Service_Notes_Log__c> c = new list<CSS_Service_Notes_Log__c>();
    TriageJob1.noteLogListDispl = c;
      list<CSS_Solutions__c> c1 = new list<CSS_Solutions__c>();
            
    TriageJob1.solutions = c1;
     TriageJob1.jobId = null;
           // CSS_Job_Order__c d = new CSS_Job_Order__c();
        //TriageJob1.Job_Order =d; 
            CSS_unitInboundJSON2Apex e = new CSS_unitInboundJSON2Apex();
    TriageJob1.UIResp = e;
    TriageJob1.showcancelpopup();
            TriageJob1.cancelModPopup();
            TriageJob1.getUnitType();
            TriageJob1.getSubType();
        }
        
         static testmethod void compareDates1(){
            Test.startTest();
            css_job_order__C jo = CSS_TestData.createJobOrder(false);
            jo.Customer_Name__c='Gopal';
            jo.Customer_Code__c='123';
            jo.Warranty_Start_Date__c=system.today();
            insert jo;
            apexpages.currentPage().getparameters().put('id',jo.id);
            css_tnd_job b = new css_tnd_job();
           
            b.higherdateErrFlag=false;
            
            b.warrantyDate = Date.Today()-1;
          
            b.CompareDates();
            Test.stopTest();
        }
        static testmethod void improveCoverage() {
            CSS_Integration_Details__c CID = new CSS_Integration_Details__c();
            CID.name = 'QSOL';
            CID.ApplicationName__c = 'QSOL';
            CID.End_Point__c='https://qsolpilot.cummins.com/csswebservices/qsol';
            CID.IsActive__c = true;
            CID.Key__c='Rv++7jk31axoHDVpTvA3bgbFQFnJ7d4t9GGFfxtox6g=';
            CID.Passcode__c='gTqnM27bVy+M3A/Fmc3s0C6ZJorDI//NobXZXB6wNOU=';
            CID.Username__c = 'Ke/SFT1NcHvb0XlJXmnBeMvno2u23G8m5ju56+YHSbQ=';
            insert CID;
            
            //css_job_order__c jo = CSS_TestData.createJobOrder(false);
            
            TestData();
            JO.Customer_Name__c='Kr';
            JO.Customer_Code__c='123';
            JO.Warranty_Start_Date__c=system.today();
            JO.Email_Address__c = 'nkm@gmail.com';
            update JO;
            css_job_order__C jo1 = [select Id, Account__c from css_job_order__C where id = : JO.Id];
            apexpages.currentPage().getparameters().put('id',JO.id);
            CSS_accountLanguage__c lang = CSS_TestData.createAccountLanguage(true);
            Account acc=CSS_TestData.createAccountObj(false);
            acc.CSS_DistributorCode__c ='56270';
            acc.CSS_DealerCode__c = '56270';
            acc.Enable_Claims__c = true;
            acc.Id = jo1.Account__c;
            acc.Region__c = 'North America';
            acc.CSS_DBCode__c='33333';
            acc.Type = 'Customer';
            acc.Name = 'Akanksha';
            upsert acc;
            
            css_job_order__C jo22 = new css_job_order__C();
            jo22.Account__c = acc.Id;
            jo22.Id = jo.Id;
            update jo1;
            
            list<Note> ln = new list<Note>();
            Note n = new Note();
            n.parentId = jo.Id;
            n.Title = 'Bold';
            n.body = 'sfsafsaifasf';
            ln.add(n);//insert n;
            
            Note n1 = new Note();
            n1.parentId = jo.Id;
            n1.Title = 'Bold';
            ln.add(n1);
            
            Note n12 = new Note();
            n12.parentId = jo.Id;
            n12.Title = 'CAMPCOMMENTS';
            ln.add(n12);
            
            insert ln;
            
            CSS_UserLocation__c userl = new CSS_UserLocation__c();
            userl.UserId__c= Userinfo.getUserId();
            userl.AccountId__c = acc.Id;
            userl.isActive__c = true;
            insert userl;
            Test.startTest();
             Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
            css_tnd_job b = new css_tnd_job();
            b.pgUISave();
            b.higherdateErrFlag=false;
            b.testBId = true;
            b.region = 'sfsaf';
            b.dispDTime = 'xfs';
            b.NewdigTime = 11.0;
            b.NewrepTime = 1.0;
            b.dispRepTime = 'sfsdf';
            b.NewrepMin = 100;
            b.NewdigMin = 120;
            b.errorMessage = 'asf';
            b.selectedBMSESN = 'safasf';
            b.reqSTBoolean =true;
        b.reqEmailBoolean = true;
            b.reqEmailInvalidBoolean= true;
            b.ReadonlyWSD = true;
            b.searchConfigUnit();
            b.onChangeBIS();
            jo.Warranty_Start_Date__c = null;
            jo.Before_In_Service__c = true;
            b.workjob = jo;
            b.onChangeBIS();
           jo.Customer_Code__c = '';
           b.workjob = jo;
            b.blankUnitonCustCodeChange();
            b.concatenateStrings();
            b.accountlang=lang;
            b.getQSOLDocs_old();
            b.validateBeforeSave();
          
            
            Test.stopTest();
           
           
            
        }
        static testmethod void improveCoverage22() {
            CSS_Integration_Details__c CID = new CSS_Integration_Details__c();
            CID.name = 'QSOL';
            CID.ApplicationName__c = 'QSOL';
            CID.End_Point__c='https://qsolpilot.cummins.com/csswebservices/qsol';
            CID.IsActive__c = true;
            CID.Key__c='Rv++7jk31axoHDVpTvA3bgbFQFnJ7d4t9GGFfxtox6g=';
            CID.Passcode__c='gTqnM27bVy+M3A/Fmc3s0C6ZJorDI//NobXZXB6wNOU=';
            CID.Username__c = 'Ke/SFT1NcHvb0XlJXmnBeMvno2u23G8m5ju56+YHSbQ=';
            insert CID;
            
            //css_job_order__c jo = CSS_TestData.createJobOrder(false);
            
            TestData();
            JO.Customer_Name__c='Kr';
            JO.Customer_Code__c='123';
            JO.Warranty_Start_Date__c=system.today();
            JO.Email_Address__c = 'nkm@gmail.com';
            update JO;
            css_job_order__C jo1 = [select Id, Account__c from css_job_order__C where id = : JO.Id];
            apexpages.currentPage().getparameters().put('id',JO.id);
            CSS_accountLanguage__c lang = CSS_TestData.createAccountLanguage(true);
            Account acc=CSS_TestData.createAccountObj(false);
            acc.CSS_DistributorCode__c ='56270';
            acc.CSS_DealerCode__c = '56270';
            acc.Enable_Claims__c = true;
            acc.Id = jo1.Account__c;
            acc.Region__c = 'North America';
            acc.CSS_DBCode__c='33333';
            acc.Type = 'Customer';
            acc.Name = 'Akanksha';
            upsert acc;
            
            css_job_order__C jo22 = new css_job_order__C();
            jo22.Account__c = acc.Id;
            jo22.Id = jo.Id;
            update jo1;
            
            list<Note> ln = new list<Note>();
            Note n = new Note();
            n.parentId = jo.Id;
            n.Title = 'Bold';
            n.body = 'sfsafsaifasf';
            ln.add(n);//insert n;
            
            Note n1 = new Note();
            n1.parentId = jo.Id;
            n1.Title = 'Bold';
            ln.add(n1);
            
            Note n12 = new Note();
            n12.parentId = jo.Id;
            n12.Title = 'CAMPCOMMENTS';
            ln.add(n12);
            
            insert ln;
            
            CSS_UserLocation__c userl = new CSS_UserLocation__c();
            userl.UserId__c= Userinfo.getUserId();
            userl.AccountId__c = acc.Id;
            userl.isActive__c = true;
            insert userl;
            Test.startTest();
             Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
            css_tnd_job b = new css_tnd_job();
          
            b.higherdateErrFlag=false;
            b.testBId = true;
            b.region = 'sfsaf';
            b.dispDTime = 'xfs';
            b.NewdigTime = 11.0;
            b.NewrepTime = 1.0;
            b.dispRepTime = 'sfsdf';
            b.NewrepMin = 100;
            b.NewdigMin = 120;
            b.errorMessage = 'asf';
            b.selectedBMSESN = 'safasf';
            b.reqSTBoolean =true;
        b.reqEmailBoolean = true;
            b.reqEmailInvalidBoolean= true;
            b.ReadonlyWSD = true;
            
            jo.Warranty_Start_Date__c = null;
            jo.Before_In_Service__c = true;
            b.workjob = jo;
           
           jo.Customer_Code__c = '';
           b.workjob = jo;
         
            b.accountlang=lang;
            b.getQSOLDocs_old();
          
          
            
            Test.stopTest();
           
           
            
        }
       
        static testmethod void testingMethod(){
            
            CSS_Job_Order__c job1 =CSS_TestData.createJobOrder(false);
            job1.Customer_Name__c = null;
            job1.Application_Desc__c = null;
            job1.Unit_number__c = null;
            job1.Mileage__c = null;
            job1.ESN__c = null;
            job1.Customer_Name__c = null;
            job1.PSN_Not_Available__c = false;
            job1.General_Symptoms__c = null;
            job1.DSID_WorkGroup__c = 'hhh'; 
            job1.DSID__c= 'sgsd';
            job1.Category_Desc__c = 'test';
            css_tnd_job b = new css_tnd_job();
            
            b.bmsEnabled = true;
            b.workJob = job1;
            
            test.startTest();
            b.validateBeforeSave();
            job1.Customer_Name__c = 'kk';
            job1.PSN_Not_Available__c = true;
            job1.Shop_Work_Order__c = '34567';
            
            css_tnd_job c = new css_tnd_job();
             c.isDealer = false;
            c.workJob = job1;
            c.validateBeforeSave();
            c.popupSave();
            
            job1.Shop_Work_Order__c = null;
            c.isDealer = true;
            c.workJob = job1;
            c.validateBeforeSave();
            
            css_tnd_job d = new css_tnd_job();
            job1.Customer_Code__c = null;
            job1.PSN_Not_Available__c = false;
            d.bmsEnabled = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            job1.Actual_Technician_Time__c = null;
            job1.Shop_Work_Order__c = '234';
            d.isdealer = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            job1.Actual_Technician_Time__c = 23.0;
            job1.Shop_Work_Order__c = '234';
            job1.Customer_Code__c = '234';
            d.bmsEnabled = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            job1.Actual_Technician_Time__c = 23.0;
            job1.Shop_Work_Order__c = '234';
            job1.Customer_Code__c = '234';
            job1.Phone_Number__c = '56567';
            d.bmsEnabled = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            job1.Actual_Technician_Time__c = 23.0;
            job1.Shop_Work_Order__c = '234';
            job1.Customer_Code__c = '234';
            job1.Phone_Number__c = '6672874287';
            job1.BMS_Last_Name__c = null;
            job1.First_Name__c = 'Anirudh';
            d.bmsEnabled = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            job1.Actual_Technician_Time__c = 23.0;
            job1.Shop_Work_Order__c = '234';
            job1.Customer_Code__c = '234';
            job1.Phone_Number__c = '6672874287';
            job1.BMS_Last_Name__c = 'Reddy';
            job1.First_Name__c = null;
            d.bmsEnabled = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            job1.Actual_Technician_Time__c = 23.0;
            job1.Shop_Work_Order__c = '234';
            job1.Customer_Code__c = '234';
            job1.Phone_Number__c = '6672874287';
            job1.BMS_Last_Name__c = 'Reddy';
            job1.First_Name__c = 'Anirudh';
            d.bmsEnabled = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            job1.Actual_Technician_Time__c = 23.0;
            job1.Shop_Work_Order__c = '234';
            job1.Customer_Code__c = '234';
            job1.Phone_Number__c = '6672874287';
            job1.BMS_Last_Name__c = 'Reddy';
            job1.First_Name__c = 'Anirudh';
            job1.Cstmr_Contacts_Phone__c ='32432';
            d.bmsEnabled = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            job1.Actual_Technician_Time__c = 23.0;
            job1.Shop_Work_Order__c = '234';
            job1.Customer_Code__c = '234';
            job1.Phone_Number__c = '6672874287';
            job1.BMS_Last_Name__c = 'Reddy';
            job1.First_Name__c = 'Anirudh';
            job1.Cstmr_Contacts_Phone__c ='2563748926';
            d.bmsEnabled = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            job1.Actual_Technician_Time__c = 23.0;
            job1.Shop_Work_Order__c = '234';
            job1.Customer_Code__c = '234';
            job1.Phone_Number__c = '6672874287';
            job1.BMS_Last_Name__c = 'Reddy';
            job1.First_Name__c = 'Anirudh';
            job1.Cstmr_Contacts_Phone__c ='2563748926';
            job1.Email_Address__c = 'anirudh@gmail.com';
            d.bmsEnabled = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            job1.Actual_Technician_Time__c = 23.0;
            job1.Shop_Work_Order__c = '234';
            job1.Customer_Code__c = '234';
            job1.Phone_Number__c = '6672874287';
            job1.BMS_Last_Name__c = 'Reddy';
            job1.First_Name__c = 'Anirudh';
            job1.Cstmr_Contacts_Phone__c ='2563748926';
            job1.Email_Address__c = 'anirudh';
            job1.Application_Desc__c = 'test';
            job1.Unit_Number__c = '23';
            d.bmsEnabled = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            job1.Actual_Technician_Time__c = 23.0;
            job1.Shop_Work_Order__c = '234';
            job1.Customer_Code__c = '234';
            job1.Phone_Number__c = '6672874287';
            job1.BMS_Last_Name__c = 'Reddy';
            job1.First_Name__c = 'Anirudh';
            job1.Cstmr_Contacts_Phone__c ='2563748926';
            job1.Email_Address__c = 'anirudh@gmail.com';
            job1.Application_Desc__c = 'test';
            job1.Unit_Number__c = '23';
            d.bmsEnabled = true;
            d.workJob = job1;
            d.validateBeforeSave();
            
            
            
            job1.Actual_Technician_Time__c = 23.0;
            
            Test.stopTest();
        }
        
        static testmethod void testmethod5()
    {
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Test';
        JO.DSID__c = 'DS455';
        JO.EditComplaint__c = 'RB';
        JO.EditCoverage__c = 'AS';
        JO.EditCorrection__c = 'AK';
        JO.chevron_page__c = 'war';
        Jo.CSS_Resolution__c = 'changed valve';
        insert JO;
        
        List<CSS_Solutions__c> CSLst = new List<CSS_Solutions__c>();
        CSS_Solutions__c CS = new CSS_Solutions__c();
        CS.Service_Job__c = Jo.Id;
        CS.Repair_Response__c = 'unsuccessful';
        CsLst.add(CS);
        
        CSS_Solutions__c CS1 = new CSS_Solutions__c();
        CS1.Service_Job__c = Jo.Id;
        CS1.Repair_Response__c = 'Successful';
        CsLst.add(CS1);
        
        CSS_Solutions__c CS2 = new CSS_Solutions__c();
        CS2.Service_Job__c = Jo.Id;
        CS2.Repair_Response__c = 'null';
        CsLst.add(CS2);
        
        CSS_Solutions__c CS3 = new CSS_Solutions__c();
        CS3.Service_Job__c = Jo.Id;
        CsLst.add(CS3);
        insert CSLst;
        
        CSS_CampTsbTrp__c x1 = new CSS_CampTsbTrp__c();
        x1.Job_order__c = JO.Id;
        x1.performed_review__c = true;
        x1.performed__c =false;
        X1.Type__c = 'CAM';
        insert x1;
        
        CG_cancelServiceJobWrapper cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        cancelSJWrapperObj1.errorFlag = true;
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        css_tnd_job jobPlan= new css_tnd_job();
        jobPlan.cancelSJWrapperObj1 = cancelSJWrapperObj1;
        jobplan.showResolutionWithRepair = null;
        jobplan.showRepairs = true;
        jobplan.showResolution = false;
        jobplan.responseValues = CSLst;
        jobplan.saveAndCloseJob();
        
    }
    
    static testmethod void testmethodNew(){
        
        
          Account acc=CSS_TestData.createAccountObj(false);
            acc.Name = 'TestAccount';
            acc.CSS_DistributorCode__c ='56270';
            acc.CSS_DealerCode__c = '56270';
            acc.Region__c ='North America';
            acc.CSS_DBCode__c='33333';
            acc.Type = 'Customer';
            insert acc;
            
            JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'RoopaTnD';
            JO.Model__c = null;
            JO.Make__c = null;
            JO.Category_Desc__c = 'testing';
            JO.Complaint_Type_Desc__c = 'test';
            JO.Application__c='Automotive'; 
            JO.Date_In__c= Date.today();
            JO.Account__c = acc.ID;
            JO.INSITE_UpdateTimeStamp__c= Date.today();
            JO.Service_Model__c='ff';
            JO.General_Symptoms__c='ttrtrtrt';
            JO.ESN__c='79464646';
            JO.Email_Address__c = 'cummins@cummins.com';
            JO.Category__c='Leak';
            JO.Failure_Date__c= Date.Today();
            JO.Failure_Point_Measure__c ='sss';
            JO.RPV_Email_Address__c='test@test.com';
            JO.RPV_Email_Has_Sent__c=false;
            JO.RPVControlNumber__c='NoInput';
            JO.DSID_Creation_Timestamp__c=Date.Today();
            JO.DSID_Status__c='open';
            JO.Shop_Work_Order__c = 'test';
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'test1234';
            Jo.DSID_WorkGroup__c = '1234';
            Jo.RPV_SecondWebserviceCall__c = true;
            Jo.RPV_Notification_Flag__c ='OFF';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.AccessCode__c = '12';
            Jo.BMSStatus__c='UI0';
            Jo.DSID__c='12345';
            insert(JO);
            
            CSS_JobEventTemporary__c jobEvent =CSS_TestData.createJobEventTempObj(false);
            jobEvent.attribute1__c ='ApplicationCodes';
            jobEvent.Key__c='56270-56270';
            jobEvent.Reason__c='{"DataArea":{"Details":[{"MarineFlag":"N","Description":"AUTOMOTIVE (C-OVER 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"120","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"130","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"200","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"WORLDWIDE BUS(EXC.US & CANADA SCHOOL BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"210","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"SCHOOL BUS (US & CANADA)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"220","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"300","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"400","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"410","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"OBSOLETE - TEMP VALUE ONLY","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"420","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"INDUSTRIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"500","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"600","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0605)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"605","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE - RECREATIONAL(ALL ENG)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"610","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (INTERMITTENT DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"620","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE DIVISION OF BRUNSWICK","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"625","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0645)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"645","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE(MEDIUM CONTINUOUS DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"650","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (HEAVY DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"655","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (CONTINUOUS POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"665","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"AGRICULTURE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"700","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0710)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"710","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"OBSOLETE-TEMP VALUE ONLY(0720)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"720","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"800","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive Engine Standby","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"810","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive Engine Prime","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"820","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"830","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"840","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"MILITARY PACKAGES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"900","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"BRADLEY FIGHTING VEHICLE, LVTP71, OR M9A","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"910","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"5 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"920","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"930","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"5 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"940","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"950","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"960","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"10","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (C--UP TO 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"11","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (C--OVER 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"12","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0AUTOMOTIVE (OTHER THAN C-SERIES)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"13","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"20","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (INTERCITY COACH, SHUTTLE AND TRANS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"21","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (SCHOOL BUS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"22","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"23","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"30","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"1RECREATIONAL VEHICLE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"31","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"40","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK (STANDARD COVERAGE)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"41","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0FIRE TRUCK (SPECIAL PARTS-ONLY COVERAGE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"42","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"0INDUSTRIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"50","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0INDUSTRIAL (EXC. MARINE, AG, GEN DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"51","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE - DIAMOND EDITION ENGINES","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"60","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"0MARINE (RECR./LT DUTY COMMERCIAL - PERS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"61","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-RECREATIONAL (HIGH OUTPUT RATING","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"62","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-RECREATIONAL (RECREATIONAL RATIN","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"63","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (INTERMITTENT RATING)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"64","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (MEDIUM CONTINUOUS RA","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"65","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"5MARINE-COMMERCIAL (CONTINUOUS RATING)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"66","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AGRICULTURE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"70","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0MOBILE FARM EQUIPMENT / IRRIGATION PUMP","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"71","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0FARM EQUIPMENT (NON MOBILE)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"72","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"80","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (STANDBY POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"81","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (UNLIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"82","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (LIMITED PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"83","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0GENERATOR DRIVE (CONTINUOUS/BASE POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"84","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0MILITARY PACKAGES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"90","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0BRADLEY FIGHTING VEHICLE, LVTP71, OR M9","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"91","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"05 TON ARMY TRUCK (M939) (NHC250)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"92","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0AIR FORCE R11 FUEL TANKER","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"93","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"05 TON ARMY TRUCK (M939A2) (6CTA 8.3)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"94","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0NTTA-855-P40 PETRO PUMP ENGINE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"95","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"0TRAKS MILITARY FORKLIFT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"96","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"AUTOMOTIVE","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"100","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"AUTOMOTIVE (C-UP TO 225 HP)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"110","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"BUS (COMPRESSED OR NATURAL GAS)","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"230","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE","BusinessUnit":"CMI","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"310","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"WORLDWIDE OFF-HIGHWAY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"510","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (PRIME/CONTINUOS PRIME POWER)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"635","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (CONTINUOUS DUTY)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"660","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"FORD GRAY AUTO","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"140","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"FORD GRAY BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"240","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"ISC-SERIES","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"150","AutomotiveFlag":"Y"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - INTERMITTENT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"621","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"651","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - HEAVY DUTY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"656","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD NONQUANTUM - CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"661","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"RECREATIONAL VEHICLE AD","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"Y","ApplicationCode":"320","AutomotiveFlag":"Y"},{"MarineFlag":"Y","Description":"KA91 MARINE GENERIC","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"890","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - RECREATIONAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"670","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - INTERMITTENT","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"675","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - GOVERNMENT SERVICE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"680","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - MEDIUM CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"685","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - HEAVY DUTY","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"690","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"CMD QUANTUM - CONTINUOUS","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"695","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"KA91 GENERATOR DRIVE GENERIC","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"891","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"WORLDWIDE WELDER COVERAGE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"520","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"G-Drive (HHP Lean-Burn Gas)","BusinessUnit":"CMI","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"850","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"THOMAS BUILT BUS","BusinessUnit":"EBU","DefaultUom":"","ActiveFlag":"N","ApplicationCode":"250","AutomotiveFlag":"Y"},{"MarineFlag":"N","Description":"CMD QUANTUM - LIGHT COMMERCIAL","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"N","ApplicationCode":"699","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (LIGHT COMMERCIAL)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"662","AutomotiveFlag":"N"},{"MarineFlag":"Y","Description":"MARINE (GOVERNMENT SERVICE)","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"663","AutomotiveFlag":"N"},{"MarineFlag":"N","Description":"QSK95 T4 LOCOMOTIVE","BusinessUnit":"EBU","DefaultUom":"Hours","ActiveFlag":"Y","ApplicationCode":"530","AutomotiveFlag":"N"}]},"Header":{"Status":"Success","ReturnCodeDescription":""}}';
            insert jobEvent;
            
            List<CSS_Solution_Component__c> solLst = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c SC = new CSS_Solution_Component__c();
            SC.Type__c = 'ATC';
            SC.Service_Job__c = jo.id;
            SC.Status__c = 'Approved';
            Sc.Complete_Indicator__c=true;
            Sc.Multiple_Times__c=true;
            solLst.add(SC);
            insert solLst;
            
            List<css_srt__c> SrtList = new List<css_srt__c>();
            css_srt__c SRT = new  css_srt__c();
            SRT.Job_Order__c = jo.id;
            SRT.Type__c = 'ATC';
            SRT.SRT_Category__c = 'ATC';
            SRT.FailCode__c = 'ATC-1234';
            SrtList.add(SRT);
            Insert SRTList;
            
        String json = '{'+
        '  \"Details\": {'+
        '    \"ApplicationCode\": \"12345\",'+
        '    \"Description\": \"testing\",'+
        '    \"BusinessUnit\": \"GetAssessData\",'+
        '    \"AutomotiveFlag\": \"Fault Details Data sent successfully\",'+
        '    \"MarineFlag\": \"Fault Details Data sent successfully\",'+   
        '    \"ActiveFlag\": \"Fault Details Data sent successfully\",'+    
        '    \"DefaultUom\": \"Fault Details Data sent successfully\"'+     
        '  },'+
        '  \"Header\": {'+   
        '        \"ReturnCodeDescription\": \"Test\",'+
        '        \"Status\": \"completed\"'+
        '      }'+
            '}';
    
        
        
        
        ApexPages.CurrentPage().getParameters().put('id',jo.id);
        
        Test.startTest();
        css_tnd_job job = new css_tnd_job();
        CSS_WPR_SBL_ApplicationResJSON obj = CSS_WPR_SBL_ApplicationResJSON.parse(json);
        job.filterApplication = 'AUTOMOTIVE';
        job.updateproductappcode();
        job.solCompCTTP = solLst;
        job.showFieldActionPopup();
        job.showFieldActionPopupNew();
        job.saveCheckBoxComp_New();
        Test.stopTest();
        
        
        
    }
        }