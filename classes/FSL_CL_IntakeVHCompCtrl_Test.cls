//Adding Comment to detect the changes for code coverage ---- Sriprada Sesham - 02/28/2022
//Adding Comment to detect the changes for code coverage ---- 02/06/2022 Murali Seelam
//Adding Comment to detect the changes for code coverage ---- 04/25/2022 Piyush
//test class modified by Naveen -----Naveen  26/08/2022
//Test class Modified by Ghanshyam---09082022
@isTest
public class FSL_CL_IntakeVHCompCtrl_Test
{
    @testSetup
    public static void setupMethod(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt1',Email='test12@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test12newUser@gmail.com');
        insert newUser;  
        
    } 
    
    @isTest
    public static void testM1()
    {
        FSL_CL_IntakeVHCompCtrl obj = new FSL_CL_IntakeVHCompCtrl();
        string sCustomerName;
        string sCSSJobNum;
        string sShopsWorkOrder;
        string sServiceModel;
        string sLocation;
        string sWorkSummary;
        string sFaultcodeSymp;
        Decimal sMileage = 123456.45;
        string sRecent_Visit;
        string sCreated_Time_Zone;
        string sCreated_Time_sort;
        string sMeter;
        Boolean sRepeat_Visit;
        Id sjobId;
        
        obj.ServiceHistList = 'Sample';
        FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
        FSL_CL_IntakeVHCompCtrl.dtCreated=system.now();
        FSL_CL_IntakeVHCompCtrl.strJobNum = '79704393';
        FSL_CL_IntakeVHCompCtrl.strLocation = 'Cummins Brisbane';
        FSL_CL_IntakeVHCompCtrl.strLocationCode = '05340-05351';
        /*Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;   */   
        User userObj = [SELECT Id FROM User WHERE Alias = 'standt1'];
        System.runAs(userObj)
        {        
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
            
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.IAM_Service_Provider_Code__c = '29550';
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.MobilePhone='9899909890';
            con.Email='test@test.com';
            con.AccountId=acc.id;
            insert con;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
             
            ServiceTerritory sT= new ServiceTerritory();
            sT.name = 'TEST ST Mobile';
            sT.OperatingHoursId=oh.id;
            sT.Location_Code__c='03250-02851';
            sT.FSL_Service_Territory_Code__c = '02851';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            sT.IsActive=true;
            insert sT;
            
            FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
            insert lm;
            
            
            Asset asst = new Asset();
            asst.Labor_Multiplier__c = lm.id;
            asst.Name = '79704393';
            asst.AccountId=acc.Id;
            asst.Safety_Requirement__c=True;
            asst.Type__c='Engines';
            asst.Type_PSN__c='Engines-79644334';
            asst.Application_Code__c='234';
            asst.Individual__c ='';
            insert asst;
            
            WorkType wt=new WorkType();
            wt = TestUtility.newWorkType();
            
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            WorkOrder wo = new WorkOrder();
            Id woRecId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
            
            wo.AssetId=asst.id;
            wo.ServiceTerritoryId=sT.id;
            wo.Available_for_Service__c=datetime.now()+3;
            wo.SelectedSolution__c='abc';
            wo.createdDate=system.now().addDays(-10);
            wo.Process_Step__c = '';
            wo.Status = 'Repair';
            wo.Type__c = 'Dealer';
            wo.RecordTypeId = woRecId;
            wo.CSS_Hours__c =  1000;
            wo.Category1__c = 'Leak';
            wo.Complaint_Type1__c='Air Leak';
            wo.Mileage__c = 234569.29;
            wo.Mileage_Measure__c = 'MILES'; 
            wo.ESN__c = '79704393';
            wo.Dealer_Shop_Work_Order__c = '13121';
            wo.EVL_DX_SONumber__c=true;
            wo.WorkTypeId =wt.id;
            
            WorkOrderList.add(wo);
            
            WorkOrder wo1 = new WorkOrder();
            wo1.AssetId=asst.id;
            wo1.Category1__c = 'Leak';
            wo1.Complaint_Type1__c='Air Leak';
            wo1.Available_for_Service__c=datetime.now()+3;
            wo1.SelectedSolution__c='abc';
            wo1.Process_Step__c = '';
            wo1.Dealer_Shop_Work_Order__c = 'test';
            wo1.Mileage__c = 2232.21;
            wo1.CSS_Hours__c = 202;
            wo1.Mileage_Measure__c = 'MILES';
            wo1.Service_Model__c = 'New';
            wo1.EVL_DX_SONumber__c=true;
            wo1.Type__c= 'Dealer';
            WorkOrderList.add(wo1);
            
            
            insert WorkOrderList;
             Test.startTest(); 
            List<case> lstcs=new List<case>();
            case cs=new case();
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=asst.id;
            cs.Description='test symptoms';
            cs.Service_Territory__c=st.id;
            cs.BusinessHoursId=bhs.id;
            
            cs.ServiceJob__c = wo.id;
            cs.Assigned_to__c = string.valueof(userObj.id) + ','+string.valueof(userinfo.getuserid());
            insert cs;
            lstcs.add(cs);
            
            ServiceResource sr=new ServiceResource();
            sr = TestUtility.createServiceResource(userObj.id, 'service resourse', true, true);
            
            List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO = TestUtility.newJobOrder();
            JO.createddate = system.now().addDays(-10);
            
            CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            CSS_Job_Order__c cjo2 = new CSS_Job_Order__c();
            
            cjo = TestUtility.createJobOrder(userObj.Id, 'Closed');
            cjo.createddate = system.now().addDays(-10);
            jobOrderList.add(cjo);  
            
            cjo2 = TestUtility.createJobOrder(userObj.Id, 'Intake');
            cjo2.createddate = system.now().addDays(-10);
            jobOrderList.add(cjo2);
            
            insert jobOrderList;
            
            FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
            cfc.Cummins_Fault_Code__c = '123';            
            insert cfc;
            
            FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
            spnfc.SPN__c ='3597-2';
            insert spnfc;
            
            FSL_PCode__c pfc= new FSL_PCode__c();
            pfc.CDS_ID__c='p008';
            insert pfc; 
            
            List<CSS_Fault_Code__c> faultCodeList = new List<CSS_Fault_Code__c>();
            CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
            fcode.Name=cfc.name;
            fcode.Type__c = 'Fault';
            fcode.Fault_Code_Type__c = '1';
            fcode.Service_Order__c = wo.id;
            fcode.extfield__c = cfc.id+' '+wo.id;
            faultCodeList.add(fcode);
            
            CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
            fcObj = TestUtility.newFaultCodeObj(wo.Id, cjo.Id);
            fcObj.createddate = system.now().addDays(-10);
            fcObj.Job_Order__c = cjo.id;
            faultCodeList.add(fcObj);
            
            CSS_Fault_Code__c fcObj2 = new CSS_Fault_Code__c();
            fcObj2 = TestUtility.newFaultCodeObj2(wo.Id, cjo.Id);
            fcObj2.Job_Order__c = cjo2.id;
            fcObj2.createddate = system.now().addDays(-10);
            faultCodeList.add(fcObj2);
            
            insert faultCodeList;
            
            List<CSS_SymptomQA__c> SymptomQAList = new List<CSS_SymptomQA__c>();
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym = TestUtility.newSymWithWO(wo.Id);
            sym.createddate = system.now().addDays(-10);
            sym.Job_Order__c = cjo.id;
            SymptomQAList.add(sym);
            
            CSS_SymptomQA__c sym2=new CSS_SymptomQA__c();
            sym2 = TestUtility.newSym(cjo.id);
            sym2.createddate = system.now().addDays(-10);
            sym2.Job_Order__c = cjo2.id;
            SymptomQAList.add(sym2);
            
            insert SymptomQAList;
            
            List<CSS_Solutions__c> SolList = new List<CSS_Solutions__c>();
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol.FSL_Solution_Position__c='1';
            sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol.Repair_Response__c='Repair not performed.';//Repair Successful.';
            sol.Repair_Notes__c='Test';
            sol.FSL_Service_Job__c=wo.Id;
            sol.FaultCode__c=fcObj.Id;
            sol.createdDate=system.now().addDays(-10);        
            SolList.add(sol);
            
            CSS_Solutions__c sol2=new CSS_Solutions__c();
            sol2.Case_Name__c='test';
            sol2.Name = 'S00000758';
            sol2.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol2.FSL_Solution_Position__c='1';
            sol2.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol2.Repair_Response__c='Repair Successful.';
            sol2.Repair_Notes__c='Test';
            sol2.Symptom__c=sym.id;
            sol2.FSL_Service_Job__c = wo.Id;
            sol2.Service_Job__c=cjo.id;
            sol2.FaultCode__c=fcObj2.Id;
            sol2.createdDate=system.now().addDays(-10);
            SolList.add(sol2);
            
         
            insert SolList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c();
            solCmp.Solutions__c = sol.Id;
            solCmp.Name = 'Turbo';
            solCmp.Component_Code__c = 'AV';
            solCmp.System_Code__c = 'FH';
            solCmp.Performed_Review__c = true;
            solCmp.FSL_FA_Service_Order__c = wo.Id;
            solCmp.FSL_Service_Job__c = wo.Id;
            solCmp.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp);
            
            CSS_Solution_Component__c solCmp2 = new CSS_Solution_Component__c();
            solCmp2.Solutions__c = sol.Id;
            solCmp2.Name = 'Turbo';
            solCmp2.Component_Code__c = 'AV';
            solCmp2.System_Code__c = 'FH';
            solCmp2.Performed_Review__c = false;
            solCmp2.FSL_FA_Service_Order__c = wo.Id;
            solCmp2.FSL_Service_Job__c = wo.Id;
            solCmp2.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp2);
            
            insert solCompList;
            
            List<FSL_SRT__c> SRTList = new List<FSL_SRT__c>();
            FSL_SRT__c srtVar = new FSL_SRT__c();
            srtVar.Service_Order__c = wo.id;
            srtVar.SRT_AccessiblityCheck__c=True;
            srtVar.Access_Code_A__c = 65;
            srtVar.name = 'Test'+Math.random();
            srtVar.Type__c = 'typ';
            srtVar.Repair_SRTs__c =sol.FSL_Service_Job__c;
            srtVar.isPerformed__c =True;
            SRTList.add(srtVar);
            
            FSL_SRT__c srtVar2 = new FSL_SRT__c();
            srtVar.Solution_Number__c = sol.Id;
            srtVar2.Service_Order__c = wo.Id;
            srtVar2.SRT_AccessiblityCheck__c=True;
            srtVar2.Access_Code_A__c = 65;
            srtVar2.name = 'Test'+Math.random();
            srtVar2.Type__c = 'Repair';
            srtVar2.isPerformed__c =True;
            srtVar2.Repair_SRTs__c =sol.FSL_Service_Job__c;
            SRTList.add(srtVar2);
            
            insert SRTList; 
            
            
            
            List<CSS_JobEventTemporary__c> jobEventList = new List<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je2=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je3=new CSS_JobEventTemporary__c();
            String jsonstring = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            EVL_DX_SORequestWrapper wrapperdtAr = new EVL_DX_SORequestWrapper();
            
            EVL_DX_SORequestWrapper.DataArea DataAreaDetails = new EVL_DX_SORequestWrapper.DataArea();
            wrapperdtAr.setDataArea(DataAreaDetails);
            
            wrapperdtAr  = (EVL_DX_SORequestWrapper) System.JSON.deserialize(jsonstring, EVL_DX_SORequestWrapper.class);
            
            EVL_DX_SORequestWrapper.DataArea dtAr =  wrapperdtAr.getDataArea();
            
            if(dtAr.SERVICEHIST != null){
                for(integer i=0;i<dtAr.SERVICEHIST.size();i++)
                { 
                    String servLoc = dtAr.SERVICEHIST[i].ServiceLocation;
                    system.debug('ServLoc>>>>'+servLoc);
                    String accLocation = servLoc.substringAfter('-');
                    system.debug('SubServLoc>>>>'+accLocation);
                    String timeStamp;
                    DateTime acceptableDateTime;
                    if(dtAr.SERVICEHIST[i].JobDate != null){
                        dtAr.SERVICEHIST[i].JobDate =String.valueof(system.today().adddays(-1));
                    }
                }
            }
            jsonstring=JSON.serialize(wrapperdtAr);
            workorder so = [select id,WorkOrderNumber from workorder where id=:wo.id];
            String JobNumber = 'Dealer_DataExchange - 79704393' ;
            List<CSS_JobEventTemporary__c> Histlstjob2 = new List<CSS_JobEventTemporary__c>();
            je.key__c=JobNumber;
            je.ESN__c='79704393';
            je.JSONResponse__c=jsonstring;
            je.Attribute1__c = 'Att1'; 
            je.Attribute2__c = 'Att2';
            je.Attribute3__c = 'Att3';
            je.Attribute4__c = 'Att4';
            je.Attribute5__c = 'Att5';
            je.Attribute6__c = 'Att6';
            je.Attribute7__c = 'Att7';
            je.Attribute8__c = 'Att8';
            je.Attribute9__c = 'MI';
            je.Attribute14__c = '9182';
            je.Attribute13__c = system.now().addDays(-10);     
            jobEventList.add(je);
            Histlstjob2.add(je);
            
            je2.key__c=JobNumber;
            je2.ESN__c='79704393';
            je2.JSONResponse__c=jsonstring;
            je2.Attribute1__c = 'Att1'; 
            je2.Attribute2__c = 'Att2';
            je2.Attribute3__c = 'Att3';
            je2.Attribute4__c = 'Att4';
            je2.Attribute5__c = 'Att5';
            je2.Attribute6__c = 'Att6';
            je2.Attribute7__c = 'Att7';
            je2.Attribute8__c = 'Att8';
            je2.Attribute9__c = 'KM';
            je2.Attribute14__c = '15000';
            je2.Attribute13__c = system.now().addDays(-10);     
            jobEventList.add(je2);
            Histlstjob2.add(je2);
            
            je3.key__c=JobNumber;
            je3.ESN__c='79704393';
            je3.JSONResponse__c=jsonstring;
            je3.Attribute1__c = 'Att1'; 
            je3.Attribute2__c = 'Att2';
            je3.Attribute3__c = 'Att3';
            je3.Attribute4__c = 'Att4';
            je3.Attribute5__c = 'Att5';
            je3.Attribute6__c = 'Att6';
            je3.Attribute7__c = 'Att7';
            je3.Attribute8__c = 'Att8';
            je3.Attribute9__c = 'HR';
            je3.Attribute14__c = '134';
            je3.Attribute13__c = system.now().addDays(-10);     
            jobEventList.add(je3);
            Histlstjob2.add(je3);
            insert jobEventList;
            
            List<CSS_Integration_Details__c> IntegrationList = new List<CSS_Integration_Details__c>();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.name= 'FSL_MoveX_ServiceHistory';
            conDetails.End_Point__c= 'https://test.Com/getServiceHistory';
            conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
            conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
            conDetails.IsActive__c = true;
            conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
            IntegrationList.add(conDetails);
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/gettoken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'OAGOAuth';
            IntegrationList.add(conDetails1);
            insert IntegrationList;
            
            
            List<serviceappointment> serviceappointmentList = new List<serviceappointment>();
            serviceappointment sa= new serviceappointment();
            sa.parentrecordId = wo.Id;
            sa.Status = 'None';
            sa.EarliestStartTime = datetime.now().addDays(2);
            sa.DueDate = System.now().addDays(30);
            sa.SchedStartTime=datetime.now().addDays(3);
            sa.SchedEndTime = datetime.now().addDays(4);
            sa.Service_Order__c= wo1.id;
            sa.Formatted_Scheduled_Start__c='FSS';
            sa.Assigned_ServiceResource__c = sr.Id;
            sa.Is_a_Tech_Appointment__c=true;
            sa.user__c = userObj.id;
            sa.Service_Order__c = wo1.id;
            serviceappointmentList.add(sa);
            
            serviceappointment sa1= new serviceappointment();
            sa1.parentrecordId = wo.Id;
            sa1.Status = 'None';
            sa1.EarliestStartTime = datetime.now().addDays(2);
            sa1.DueDate = System.now().addDays(30);
            sa1.SchedStartTime=datetime.now().addDays(3);
            sa1.SchedEndTime = datetime.now().addDays(4);
            sa1.Service_Order__c= wo.id;
            sa1.Formatted_Scheduled_Start__c='populateResourceDetails';
            sa1.Is_a_Tech_Appointment__c=true;
            //serviceappointmentList.add(sa1);
            insert serviceappointmentList;
            
            sa.Status = 'Scheduled';
            //  update sa;       
            
            
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
            FSL_CL_IntakeVHCompCtrl.strWOId = WorkOrderList[0].id;
            FSL_CL_IntakeVHCompCtrl.dtCreated = System.now();
            DateTime lastDate = System.now().addDays(-30);
            FSL_CL_IntakeVHCompCtrl.getRecentHistJobs();
            FSL_CL_IntakeVHCompCtrl.getHistJobs();
            Test.stopTest(); 
        }
    }
    
    
    @isTest
    public static void testM2()
    {
        FSL_CL_IntakeVHCompCtrl obj = new FSL_CL_IntakeVHCompCtrl();
        string sCustomerName;
        string sCSSJobNum;
        string sShopsWorkOrder;
        string sServiceModel;
        string sLocation;
        string sWorkSummary;
        string sFaultcodeSymp;
        Decimal sMileage = 123456.45;
        string sRecent_Visit;
        string sCreated_Time_Zone;
        string sCreated_Time_sort;
        string sMeter;
        Boolean sRepeat_Visit;
        Id sjobId;
        
        obj.ServiceHistList = 'Sample';
        FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
        FSL_CL_IntakeVHCompCtrl.dtCreated=system.now();
        FSL_CL_IntakeVHCompCtrl.strJobNum = '79704393';
        FSL_CL_IntakeVHCompCtrl.strLocation = 'Cummins Brisbane';
        FSL_CL_IntakeVHCompCtrl.strLocationCode = '05340-05351';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com',ERP__c='BMS');
        
        User newUser2A = new User(Alias = 'standt2A', Email='test2A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing2A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p2.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test12AQnewUser@gmail.com');
        insert newUser; 
        insert newUser2A;
        
        System.runAs(newUser)
        {                        
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
            
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.IAM_Service_Provider_Code__c = '29550';
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.MobilePhone='9899909890';
            con.Email='test@test.com';
            con.AccountId=acc.id;
            insert con;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            ServiceTerritory sT= new ServiceTerritory();
            sT.name = 'TEST ST Mobile';
            sT.OperatingHoursId=oh.id;
            sT.Location_Code__c='03250-02851';
            sT.FSL_Service_Territory_Code__c = '02851';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            sT.IsActive=true;
            insert sT;
            
            FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
            insert lm;
            
            
            Asset asst = new Asset();
            asst.Labor_Multiplier__c = lm.id;
            asst.Name = '79704393';
            asst.AccountId=acc.Id;
            asst.Safety_Requirement__c=True;
            asst.Type__c='Engines';
            asst.Type_PSN__c='Engines-79644334';
            asst.Application_Code__c='234';
            asst.Individual__c ='';
            insert asst;
            
            WorkType wt=new WorkType();
            wt = TestUtility.newWorkType();
            
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            WorkOrder wo = new WorkOrder();
            Id woRecId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
            
            wo.AssetId=asst.id;
            wo.ServiceTerritoryId=sT.id;
            wo.Available_for_Service__c=datetime.now()+3;
            wo.SelectedSolution__c='abc';
            wo.createdDate=system.now().addDays(-10);
            wo.Process_Step__c = '';
            wo.Status = 'Repair';
            wo.Type__c = 'Dealer';
            wo.RecordTypeId = woRecId;
            wo.CSS_Hours__c =  1000;
            wo.Category1__c = 'Leak';
            wo.Complaint_Type1__c='Air Leak';
            wo.Mileage__c = 234569.29;
            wo.Mileage_Measure__c = 'MILES'; 
            wo.ESN__c = '79704393';
            wo.Dealer_Shop_Work_Order__c = '13121';
            wo.EVL_DX_SONumber__c=true;
            wo.WorkTypeId =wt.id;
            
            WorkOrderList.add(wo);
            
            WorkOrder wo1 = new WorkOrder();
            wo1.AssetId=asst.id;
            wo1.Category1__c = 'Leak';
            wo1.Complaint_Type1__c='Air Leak';
            wo1.Available_for_Service__c=datetime.now()+3;
            wo1.SelectedSolution__c='abc';
            wo1.Process_Step__c = '';
            wo1.Dealer_Shop_Work_Order__c = 'test';
            wo1.Mileage__c = 2232.21;
            wo1.CSS_Hours__c = 202;
            wo1.Mileage_Measure__c = 'MILES';
            wo1.Service_Model__c = 'New';
            wo1.EVL_DX_SONumber__c=true;
            wo1.Type__c= 'Dealer';
            WorkOrderList.add(wo1);
            
            
            insert WorkOrderList;
            
            List<case> lstcs=new List<case>();
            case cs=new case();
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=asst.id;
            cs.Description='test symptoms';
            cs.Service_Territory__c=st.id;
            cs.BusinessHoursId=bhs.id;
            
            cs.ServiceJob__c = wo.id;
            cs.Assigned_to__c = string.valueof(newUser.id) + ','+string.valueof(userinfo.getuserid());
            insert cs;
            lstcs.add(cs);
            
            ServiceResource sr=new ServiceResource();
            sr = TestUtility.createServiceResource(newUser.id, 'service resourse', true, true);
            
            List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO = TestUtility.newJobOrder();
            JO.createddate = system.now().addDays(-10);
            
            CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            CSS_Job_Order__c cjo2 = new CSS_Job_Order__c();
            
            cjo = TestUtility.createJobOrder(newUser.Id, 'Closed');
            cjo.createddate = system.now().addDays(-10);
            jobOrderList.add(cjo);  
            
            cjo2 = TestUtility.createJobOrder(newUser.Id, 'Intake');
            cjo2.createddate = system.now().addDays(-10);
            jobOrderList.add(cjo2);
            
            insert jobOrderList;
            
            FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
            cfc.Cummins_Fault_Code__c = '123';            
            insert cfc;
            
            FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
            spnfc.SPN__c ='3597-2';
            insert spnfc;
            
            FSL_PCode__c pfc= new FSL_PCode__c();
            pfc.CDS_ID__c='p008';
            insert pfc; 
            
            List<CSS_Fault_Code__c> faultCodeList = new List<CSS_Fault_Code__c>();
            CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
            fcode.Name=cfc.name;
            fcode.Type__c = 'Fault';
            fcode.Fault_Code_Type__c = '1';
            fcode.Service_Order__c = wo.id;
            fcode.extfield__c = cfc.id+' '+wo.id;
            faultCodeList.add(fcode);
            
            CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
            fcObj = TestUtility.newFaultCodeObj(wo.Id, cjo.Id);
            fcObj.createddate = system.now().addDays(-10);
            fcObj.Job_Order__c = cjo.id;
            faultCodeList.add(fcObj);
            
            CSS_Fault_Code__c fcObj2 = new CSS_Fault_Code__c();
            fcObj2 = TestUtility.newFaultCodeObj2(wo.Id, cjo.Id);
            fcObj2.createddate = system.now().addDays(-10);
            fcObj2.Job_Order__c = cjo2.id;
            faultCodeList.add(fcObj2);
            
            Test.startTest();
            insert faultCodeList;
            
            List<CSS_SymptomQA__c> SymptomQAList = new List<CSS_SymptomQA__c>();
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym = TestUtility.newSymWithWO(wo.Id);
            sym.createddate = system.now().addDays(-10);
            sym.Job_Order__c = cjo.id;
            SymptomQAList.add(sym);
            
            CSS_SymptomQA__c sym2=new CSS_SymptomQA__c();
            sym2 = TestUtility.newSym(cjo.id);
            sym.createddate = system.now().addDays(-10);
            sym.Job_Order__c = cjo.id;
            SymptomQAList.add(sym2);
            
            insert SymptomQAList;
            
            List<CSS_Solutions__c> SolList = new List<CSS_Solutions__c>();
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol.FSL_Solution_Position__c='1';
            sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol.Repair_Response__c='Repair not performed.';//Repair Successful.';
            sol.Repair_Notes__c='Test';
            sol.FSL_Service_Job__c=wo.Id;
            sol.createdDate=system.now().addDays(-10);        
            SolList.add(sol);
            
            CSS_Solutions__c sol2=new CSS_Solutions__c();
            sol2.Case_Name__c='test';
            sol2.Name = 'S00000758';
            sol2.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol2.FSL_Solution_Position__c='1';
            sol2.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol2.Repair_Response__c='Repair Successful.';
            sol2.Repair_Notes__c='Test';
            sol2.Symptom__c=sym.id;
            sol2.FSL_Service_Job__c = wo.Id;
            sol2.Service_Job__c=cjo.id;
            sol2.FaultCode__c=fcObj2.Id;
            sol2.createdDate=system.now().addDays(-10);
            SolList.add(sol2);
            
            
            insert SolList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c();
            solCmp.Solutions__c = sol.Id;
            solCmp.Name = 'Turbo';
            solCmp.Component_Code__c = 'AV';
            solCmp.System_Code__c = 'FH';
            solCmp.Performed_Review__c = true;
            solCmp.FSL_FA_Service_Order__c = wo.Id;
            solCmp.FSL_Service_Job__c = wo.Id;
            solCmp.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp);
            
            CSS_Solution_Component__c solCmp2 = new CSS_Solution_Component__c();
            solCmp2.Solutions__c = sol.Id;
            solCmp2.Name = 'Turbo';
            solCmp2.Component_Code__c = 'AV';
            solCmp2.System_Code__c = 'FH';
            solCmp2.Performed_Review__c = false;
            solCmp2.FSL_FA_Service_Order__c = wo.Id;
            solCmp2.FSL_Service_Job__c = wo.Id;
            solCmp2.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp2);
            
            insert solCompList;
            
            List<FSL_SRT__c> SRTList = new List<FSL_SRT__c>();
            FSL_SRT__c srtVar = new FSL_SRT__c();
            srtVar.Service_Order__c = wo.id;
            srtVar.SRT_AccessiblityCheck__c=True;
            srtVar.Access_Code_A__c = 65;
            srtVar.name = 'Test'+Math.random();
            srtVar.Type__c = 'typ';
            srtVar.Repair_SRTs__c =sol.FSL_Service_Job__c;
            srtVar.isPerformed__c =True;
            SRTList.add(srtVar);
            
            FSL_SRT__c srtVar2 = new FSL_SRT__c();
            srtVar.Solution_Number__c = sol.Id;
            srtVar2.Service_Order__c = wo.Id;
            srtVar2.SRT_AccessiblityCheck__c=True;
            srtVar2.Access_Code_A__c = 65;
            srtVar2.name = 'Test'+Math.random();
            srtVar2.Type__c = 'Repair';
            srtVar2.isPerformed__c =True;
            srtVar2.Repair_SRTs__c =sol.FSL_Service_Job__c;
            SRTList.add(srtVar2);
            
            insert SRTList; 
            
            
            
            List<CSS_JobEventTemporary__c> jobEventList = new List<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je2=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je3=new CSS_JobEventTemporary__c();
            String jsonstring = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            EVL_DX_SORequestWrapper wrapperdtAr = new EVL_DX_SORequestWrapper();
            
            EVL_DX_SORequestWrapper.DataArea DataAreaDetails = new EVL_DX_SORequestWrapper.DataArea();
            wrapperdtAr.setDataArea(DataAreaDetails);
            
            wrapperdtAr  = (EVL_DX_SORequestWrapper) System.JSON.deserialize(jsonstring, EVL_DX_SORequestWrapper.class);
            
            EVL_DX_SORequestWrapper.DataArea dtAr =  wrapperdtAr.getDataArea();
            
            if(dtAr.SERVICEHIST != null){
                for(integer i=0;i<dtAr.SERVICEHIST.size();i++)
                { 
                    String servLoc = dtAr.SERVICEHIST[i].ServiceLocation;
                    system.debug('ServLoc>>>>'+servLoc);
                    String accLocation = servLoc.substringAfter('-');
                    system.debug('SubServLoc>>>>'+accLocation);
                    String timeStamp;
                    DateTime acceptableDateTime;
                    if(dtAr.SERVICEHIST[i].JobDate != null){
                        dtAr.SERVICEHIST[i].JobDate =String.valueof(system.today().adddays(-1));
                    }
                }
            }
            jsonstring=JSON.serialize(wrapperdtAr);
            workorder so = [select id,WorkOrderNumber from workorder where id=:wo.id];
            String JobNumber = 'Dealer_DataExchange - 79704393' ;
            List<CSS_JobEventTemporary__c> Histlstjob2 = new List<CSS_JobEventTemporary__c>();
            je.key__c=JobNumber;
            je.ESN__c='79704393';
            je.JSONResponse__c=jsonstring;
            je.Attribute1__c = 'Att1'; 
            je.Attribute2__c = 'Att2';
            je.Attribute3__c = 'Att3';
            je.Attribute4__c = 'Att4';
            je.Attribute5__c = 'Att5';
            je.Attribute6__c = 'Att6';
            je.Attribute7__c = 'Att7';
            je.Attribute8__c = 'Att8';
            je.Attribute9__c = 'MI';
            je.Attribute14__c = '9182';
            je.Attribute13__c = system.now().addDays(-10);     
            jobEventList.add(je);
            Histlstjob2.add(je);
            
            je2.key__c=JobNumber;
            je2.ESN__c='79704393';
            je2.JSONResponse__c=jsonstring;
            je2.Attribute1__c = 'Att1'; 
            je2.Attribute2__c = 'Att2';
            je2.Attribute3__c = 'Att3';
            je2.Attribute4__c = 'Att4';
            je2.Attribute5__c = 'Att5';
            je2.Attribute6__c = 'Att6';
            je2.Attribute7__c = 'Att7';
            je2.Attribute8__c = 'Att8';
            je2.Attribute9__c = 'KM';
            je2.Attribute14__c = '15000';
            je2.Attribute13__c = system.now().addDays(-10);     
            jobEventList.add(je2);
            Histlstjob2.add(je2);
            
            je3.key__c=JobNumber;
            je3.ESN__c='79704393';
            je3.JSONResponse__c=jsonstring;
            je3.Attribute1__c = 'Att1'; 
            je3.Attribute2__c = 'Att2';
            je3.Attribute3__c = 'Att3';
            je3.Attribute4__c = 'Att4';
            je3.Attribute5__c = 'Att5';
            je3.Attribute6__c = 'Att6';
            je3.Attribute7__c = 'Att7';
            je3.Attribute8__c = 'Att8';
            je3.Attribute9__c = 'HR';
            je3.Attribute14__c = '134';
            je3.Attribute13__c = system.now().addDays(-10);     
            jobEventList.add(je3);
            Histlstjob2.add(je3);
            insert jobEventList;
            
            List<CSS_Integration_Details__c> IntegrationList = new List<CSS_Integration_Details__c>();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.name= 'FSL_MoveX_ServiceHistory';
            conDetails.End_Point__c= 'https://test.Com/getServiceHistory';
            conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
            conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
            conDetails.IsActive__c = true;
            conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
            IntegrationList.add(conDetails);
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/gettoken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'OAGOAuth';
            IntegrationList.add(conDetails1);
            insert IntegrationList;
            
            
            List<serviceappointment> serviceappointmentList = new List<serviceappointment>();
            serviceappointment sa= new serviceappointment();
            sa.parentrecordId = wo.Id;
            sa.Status = 'None';
            sa.EarliestStartTime = datetime.now().addDays(2);
            sa.DueDate = System.now().addDays(30);
            sa.SchedStartTime=datetime.now().addDays(3);
            sa.SchedEndTime = datetime.now().addDays(4);
            sa.Service_Order__c= wo.id;
            sa.Formatted_Scheduled_Start__c='FSS';
            sa.Assigned_ServiceResource__c = sr.Id;
            sa.Is_a_Tech_Appointment__c=true;
            sa.user__c = newUser.id;
            sa.Service_Order__c = wo.id;
            serviceappointmentList.add(sa);
            
            serviceappointment sa1= new serviceappointment();
            sa1.parentrecordId = wo1.Id;
            sa1.Status = 'None';
            sa1.EarliestStartTime = datetime.now().addDays(2);
            sa1.DueDate = System.now().addDays(30);
            sa1.SchedStartTime=datetime.now().addDays(3);
            sa1.SchedEndTime = datetime.now().addDays(4);
            sa1.Service_Order__c= wo1.id;
            sa1.Formatted_Scheduled_Start__c='populateResourceDetails';
            sa1.Is_a_Tech_Appointment__c=true;
            //serviceappointmentList.add(sa1);
            insert serviceappointmentList;
            
            sa.Status = 'Scheduled';
            //  update sa;       
            
            
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
            FSL_CL_IntakeVHCompCtrl.strWOId = WorkOrderList[0].id;
            FSL_CL_IntakeVHCompCtrl.dtCreated = System.now();
            DateTime lastDate = System.now().addDays(-30);
            FSL_CL_IntakeVHCompCtrl.getRecentHistJobs();
            FSL_CL_IntakeVHCompCtrl.getHistJobs();
            Test.stopTest(); 
        }
     FSL_CL_IntakeVHCompCtrl obj2 = new FSL_CL_IntakeVHCompCtrl();
        System.assert(obj2 != null);
    }
    @isTest
    public static void testM3()
    {
        FSL_CL_IntakeVHCompCtrl obj = new FSL_CL_IntakeVHCompCtrl();
        string sCustomerName;
        string sCSSJobNum;
        string sShopsWorkOrder;
        string sServiceModel;
        string sLocation;
        string sWorkSummary;
        string sFaultcodeSymp;
        Decimal sMileage = 123456.45;
        string sRecent_Visit;
        string sCreated_Time_Zone;
        string sCreated_Time_sort;
        string sMeter;
        Boolean sRepeat_Visit;
        Id sjobId;
        
        obj.ServiceHistList = 'Sample';
        FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
        FSL_CL_IntakeVHCompCtrl.dtCreated=system.now();
        FSL_CL_IntakeVHCompCtrl.strJobNum = '79704393';
        FSL_CL_IntakeVHCompCtrl.strLocation = 'Cummins Brisbane';
        FSL_CL_IntakeVHCompCtrl.strLocationCode = '05340-05351';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;                                
        System.runAs(newUser)
        {        
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
            
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.IAM_Service_Provider_Code__c = '29550';
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.MobilePhone='9899909890';
            con.Email='test@test.com';
            con.AccountId=acc.id;
            insert con;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            ServiceTerritory sT= new ServiceTerritory();
            sT.name = 'TEST ST Mobile';
            sT.OperatingHoursId=oh.id;
            sT.Location_Code__c='03250-02851';
            sT.FSL_Service_Territory_Code__c = '02851';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            sT.IsActive=true;
            insert sT;
            
            FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
            insert lm;
            
            
            Asset asst = new Asset();
            asst.Labor_Multiplier__c = lm.id;
            asst.Name = '79704393';
            asst.AccountId=acc.Id;
            asst.Safety_Requirement__c=True;
            asst.Type__c='Engines';
            asst.Type_PSN__c='Engines-79644334';
            asst.Application_Code__c='234';
            asst.Individual__c ='';
            insert asst;
            
            WorkType wt=new WorkType();
            wt = TestUtility.newWorkType();
            
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            WorkOrder wo = new WorkOrder();
            Id woRecId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
            
            wo.AssetId=asst.id;
            wo.ServiceTerritoryId=sT.id;
            wo.Available_for_Service__c=datetime.now()+3;
            wo.SelectedSolution__c='abc';
            wo.createdDate=system.now().addDays(-109);
            wo.Process_Step__c = 'Repair';
            wo.Status = 'Repair';
            wo.Type__c = 'Internal';
            wo.RecordTypeId = woRecId;
            wo.CSS_Hours__c =  1000;
            wo.Category1__c = 'Leak';
            wo.Complaint_Type1__c='Air Leak';
            wo.Mileage__c = 234569.29;
            wo.Mileage_Measure__c = 'MILES'; 
            wo.ESN__c = '79704393';
            wo.Dealer_Shop_Work_Order__c = '13121';
            wo.EVL_DX_SONumber__c=true;
            wo.WorkTypeId =wt.id;
            
            WorkOrderList.add(wo);
            
            WorkOrder wo1 = new WorkOrder();
            wo1.AssetId=asst.id;
            wo1.Category1__c = 'Leak';
            wo1.Complaint_Type1__c='Air Leak';
            wo1.Available_for_Service__c=datetime.now()+3;
            wo1.SelectedSolution__c='abc';
            wo1.Process_Step__c = '';
            wo1.Dealer_Shop_Work_Order__c = 'test';
            wo1.Mileage__c = 2232.21;
            wo1.CSS_Hours__c = 202;
            wo1.Mileage_Measure__c = 'MILES';
            wo1.Service_Model__c = 'New';
            wo1.EVL_DX_SONumber__c=true;
            wo1.Type__c= 'Dealer';
            WorkOrderList.add(wo1);
            
            
            insert WorkOrderList;
            
            List<case> lstcs=new List<case>();
            case cs=new case();
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=asst.id;
            cs.Description='test symptoms';
            cs.Service_Territory__c=st.id;
            cs.BusinessHoursId=bhs.id;
            
            cs.ServiceJob__c = wo.id;
            cs.Assigned_to__c = string.valueof(newUser.id) + ','+string.valueof(userinfo.getuserid());
            
            Test.startTest();
            insert cs;
            lstcs.add(cs);
            
            ServiceResource sr=new ServiceResource();
            sr = TestUtility.createServiceResource(newUser.id, 'service resourse', true, true);
            
            List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO = TestUtility.newJobOrder();
            JO.createddate = system.now().addDays(-109);
            
            CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            CSS_Job_Order__c cjo2 = new CSS_Job_Order__c();
            
            cjo = TestUtility.createJobOrder(newUser.Id, 'Closed');
            cjo.createddate = system.now().addDays(-109);
            jobOrderList.add(cjo);  
            
            cjo2 = TestUtility.createJobOrder(newUser.Id, 'Intake');
            cjo2.createddate = system.now().addDays(-109);
            jobOrderList.add(cjo2);
            
            insert jobOrderList;
            
            FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
            cfc.Cummins_Fault_Code__c = '123';            
            insert cfc;
            
            FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
            spnfc.SPN__c ='3597-2';
            insert spnfc;
            
            FSL_PCode__c pfc= new FSL_PCode__c();
            pfc.CDS_ID__c='p008';
            insert pfc; 
            
            List<CSS_Fault_Code__c> faultCodeList = new List<CSS_Fault_Code__c>();
            CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
            fcode.Name=cfc.name;
            fcode.Type__c = 'Fault';
            fcode.Fault_Code_Type__c = '1';
            fcode.Service_Order__c = wo.id;
            fcode.extfield__c = cfc.id+' '+wo.id;
            faultCodeList.add(fcode);
            
            CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
            fcObj = TestUtility.newFaultCodeObj(wo.Id, cjo.Id);
            fcObj.createddate = system.now().addDays(-109);
            fcObj.Job_Order__c = cjo.id;
            faultCodeList.add(fcObj);
            
            CSS_Fault_Code__c fcObj2 = new CSS_Fault_Code__c();
            fcObj2 = TestUtility.newFaultCodeObj2(wo.Id, cjo.Id);
            fcObj2.Job_Order__c = cjo2.id;
            fcObj2.createddate = system.now().addDays(-109);
            faultCodeList.add(fcObj2);
            
            insert faultCodeList;
            
            List<CSS_SymptomQA__c> SymptomQAList = new List<CSS_SymptomQA__c>();
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym = TestUtility.newSymWithWO(wo.Id);
            sym.createddate = system.now().addDays(-109);
            sym.Job_Order__c = cjo.id;
            SymptomQAList.add(sym);
            
            CSS_SymptomQA__c sym2=new CSS_SymptomQA__c();
            sym2 = TestUtility.newSym(cjo.id);
            sym2.createddate = system.now().addDays(-109);
            sym2.Job_Order__c = cjo2.id;
            SymptomQAList.add(sym2);
            
            insert SymptomQAList;
            
            List<CSS_Solutions__c> SolList = new List<CSS_Solutions__c>();
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol.FSL_Solution_Position__c='1';
            sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol.Repair_Response__c='Repair not performed.';//Repair Successful.';
            sol.Repair_Notes__c='Test';
            sol.FSL_Service_Job__c=wo.Id;
            sol.FaultCode__c=fcObj.Id;
            sol.createdDate=system.now().addDays(-109);        
            SolList.add(sol);
            
            CSS_Solutions__c sol2=new CSS_Solutions__c();
            sol2.Case_Name__c='test';
            sol2.Name = 'S00000758';
            sol2.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol2.FSL_Solution_Position__c='1';
            sol2.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol2.Repair_Response__c='Repair Successful.';
            sol2.Repair_Notes__c='Test';
            sol2.Symptom__c=sym.id;
            sol2.FSL_Service_Job__c = wo.Id;
            sol2.Service_Job__c=cjo.id;
            sol2.FaultCode__c=fcObj2.Id;
            sol2.createdDate=system.now().addDays(-109);
            SolList.add(sol2);
            
            
            insert SolList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c();
            solCmp.Solutions__c = sol.Id;
            solCmp.Name = 'Turbo';
            solCmp.Component_Code__c = 'AV';
            solCmp.System_Code__c = 'FH';
            solCmp.Performed_Review__c = true;
            solCmp.FSL_FA_Service_Order__c = wo.Id;
            solCmp.FSL_Service_Job__c = wo.Id;
            solCmp.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp);
            
            CSS_Solution_Component__c solCmp2 = new CSS_Solution_Component__c();
            solCmp2.Solutions__c = sol.Id;
            solCmp2.Name = 'Turbo';
            solCmp2.Component_Code__c = 'AV';
            solCmp2.System_Code__c = 'FH';
            solCmp2.Performed_Review__c = false;
            solCmp2.FSL_FA_Service_Order__c = wo.Id;
            solCmp2.FSL_Service_Job__c = wo.Id;
            solCmp2.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp2);
            
            insert solCompList;
            
            List<FSL_SRT__c> SRTList = new List<FSL_SRT__c>();
            FSL_SRT__c srtVar = new FSL_SRT__c();
            srtVar.Service_Order__c = wo.id;
            srtVar.SRT_AccessiblityCheck__c=True;
            srtVar.Access_Code_A__c = 65;
            srtVar.name = 'Test'+Math.random();
            srtVar.Type__c = 'typ';
            srtVar.Repair_SRTs__c =sol.FSL_Service_Job__c;
            srtVar.isPerformed__c =True;
            SRTList.add(srtVar);
            
            FSL_SRT__c srtVar2 = new FSL_SRT__c();
            srtVar.Solution_Number__c = sol.Id;
            srtVar2.Service_Order__c = wo.Id;
            srtVar2.SRT_AccessiblityCheck__c=True;
            srtVar2.Access_Code_A__c = 65;
            srtVar2.name = 'Test'+Math.random();
            srtVar2.Type__c = 'Repair';
            srtVar2.isPerformed__c =True;
            srtVar2.Repair_SRTs__c =sol.FSL_Service_Job__c;
            SRTList.add(srtVar2);
            
            insert SRTList; 
            
            
            
            List<CSS_JobEventTemporary__c> jobEventList = new List<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je2=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je3=new CSS_JobEventTemporary__c();
            String jsonstring = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            EVL_DX_SORequestWrapper wrapperdtAr = new EVL_DX_SORequestWrapper();
            
            EVL_DX_SORequestWrapper.DataArea DataAreaDetails = new EVL_DX_SORequestWrapper.DataArea();
            wrapperdtAr.setDataArea(DataAreaDetails);
            
            wrapperdtAr  = (EVL_DX_SORequestWrapper) System.JSON.deserialize(jsonstring, EVL_DX_SORequestWrapper.class);
            
            EVL_DX_SORequestWrapper.DataArea dtAr =  wrapperdtAr.getDataArea();
            
            if(dtAr.SERVICEHIST != null){
                for(integer i=0;i<dtAr.SERVICEHIST.size();i++)
                { 
                    String servLoc = dtAr.SERVICEHIST[i].ServiceLocation;
                    system.debug('ServLoc>>>>'+servLoc);
                    String accLocation = servLoc.substringAfter('-');
                    system.debug('SubServLoc>>>>'+accLocation);
                    String timeStamp;
                    DateTime acceptableDateTime;
                    if(dtAr.SERVICEHIST[i].JobDate != null){
                        dtAr.SERVICEHIST[i].JobDate =String.valueof(system.today().adddays(-1));
                    }
                }
            }
            jsonstring=JSON.serialize(wrapperdtAr);
            workorder so = [select id,WorkOrderNumber from workorder where id=:wo.id];
            String JobNumber = 'Dealer_DataExchange - 79704393' ;
            List<CSS_JobEventTemporary__c> Histlstjob2 = new List<CSS_JobEventTemporary__c>();
            je.key__c=JobNumber;
            je.ESN__c='79704393';
            je.JSONResponse__c=jsonstring;
            je.Attribute1__c = 'Att1'; 
            je.Attribute2__c = 'Att2';
            je.Attribute3__c = 'Att3';
            je.Attribute4__c = 'Att4';
            je.Attribute5__c = 'Att5';
            je.Attribute6__c = 'Att6';
            je.Attribute7__c = 'Att7';
            je.Attribute8__c = 'Att8';
            je.Attribute9__c = 'MI';
            je.Attribute14__c = '9182';
            je.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je);
            Histlstjob2.add(je);
            
            je2.key__c=JobNumber;
            je2.ESN__c='79704393';
            je2.JSONResponse__c=jsonstring;
            je2.Attribute1__c = 'Att1'; 
            je2.Attribute2__c = 'Att2';
            je2.Attribute3__c = 'Att3';
            je2.Attribute4__c = 'Att4';
            je2.Attribute5__c = 'Att5';
            je2.Attribute6__c = 'Att6';
            je2.Attribute7__c = 'Att7';
            je2.Attribute8__c = 'Att8';
            je2.Attribute9__c = 'KM';
            je2.Attribute14__c = '15000';
            je2.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je2);
            Histlstjob2.add(je2);
            
            je3.key__c=JobNumber;
            je3.ESN__c='79704393';
            je3.JSONResponse__c=jsonstring;
            je3.Attribute1__c = 'Att1'; 
            je3.Attribute2__c = 'Att2';
            je3.Attribute3__c = 'Att3';
            je3.Attribute4__c = 'Att4';
            je3.Attribute5__c = 'Att5';
            je3.Attribute6__c = 'Att6';
            je3.Attribute7__c = 'Att7';
            je3.Attribute8__c = 'Att8';
            je3.Attribute9__c = 'HR';
            je3.Attribute14__c = '134';
            je3.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je3);
            Histlstjob2.add(je3);
            insert jobEventList;
            
            List<CSS_Integration_Details__c> IntegrationList = new List<CSS_Integration_Details__c>();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.name= 'FSL_MoveX_ServiceHistory';
            conDetails.End_Point__c= 'https://test.Com/getServiceHistory';
            conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
            conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
            conDetails.IsActive__c = true;
            conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
            IntegrationList.add(conDetails);
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/gettoken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'OAGOAuth';
            IntegrationList.add(conDetails1);
            insert IntegrationList;
            
            
            List<serviceappointment> serviceappointmentList = new List<serviceappointment>();
            serviceappointment sa= new serviceappointment();
            sa.parentrecordId = wo.Id;
            sa.Status = 'None';
            sa.EarliestStartTime = datetime.now().addDays(2);
            sa.DueDate = System.now().addDays(30);
            sa.SchedStartTime=datetime.now().addDays(3);
            sa.SchedEndTime = datetime.now().addDays(4);
            sa.Service_Order__c= wo.id;
            sa.Formatted_Scheduled_Start__c='FSS';
            sa.Assigned_ServiceResource__c = sr.Id;
            sa.Is_a_Tech_Appointment__c=true;
            sa.user__c = newUser.id;
            sa.Service_Order__c = wo.id;
            serviceappointmentList.add(sa);
            
            serviceappointment sa1= new serviceappointment();
            sa1.parentrecordId = wo1.Id;
            sa1.Status = 'None';
            sa1.EarliestStartTime = datetime.now().addDays(2);
            sa1.DueDate = System.now().addDays(30);
            sa1.SchedStartTime=datetime.now().addDays(3);
            sa1.SchedEndTime = datetime.now().addDays(4);
            sa1.Service_Order__c= wo1.id;
            sa1.Formatted_Scheduled_Start__c='populateResourceDetails';
            sa1.Is_a_Tech_Appointment__c=true;
            //serviceappointmentList.add(sa1);
            insert serviceappointmentList;
            
            sa.Status = 'Scheduled';
            //  update sa;       
            
            
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
            FSL_CL_IntakeVHCompCtrl.strWOId = WorkOrderList[0].id;
            FSL_CL_IntakeVHCompCtrl.dtCreated = System.now();
            DateTime lastDate = System.now().addDays(-109);
            FSL_CL_IntakeVHCompCtrl.getRecentHistJobs();
            FSL_CL_IntakeVHCompCtrl.getHistJobs();
            Test.stopTest(); 
        }
    }
    
    
    @isTest
    public static void testM4()
    {
        FSL_CL_IntakeVHCompCtrl obj = new FSL_CL_IntakeVHCompCtrl();
        string sCustomerName;
        string sCSSJobNum;
        string sShopsWorkOrder;
        string sServiceModel;
        string sLocation;
        string sWorkSummary;
        string sFaultcodeSymp;
        Decimal sMileage = 123456.45;
        string sRecent_Visit;
        string sCreated_Time_Zone;
        string sCreated_Time_sort;
        string sMeter;
        Boolean sRepeat_Visit;
        Id sjobId;
        
        obj.ServiceHistList = 'Sample';
        FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
        FSL_CL_IntakeVHCompCtrl.dtCreated=system.now();
        FSL_CL_IntakeVHCompCtrl.strJobNum = '79704393';
        FSL_CL_IntakeVHCompCtrl.strLocation = 'Cummins Brisbane';
        FSL_CL_IntakeVHCompCtrl.strLocationCode = '05340-05351';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com',ERP__c='BMS');
        
        User newUser2A = new User(Alias = 'standt2A', Email='test2A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing2A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p2.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test12AQnewUser@gmail.com');
        insert newUser; 
        insert newUser2A;
        
        System.runAs(newUser)
        {                        
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
           
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.IAM_Service_Provider_Code__c = '29550';
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.MobilePhone='9899909890';
            con.Email='test@test.com';
            con.AccountId=acc.id;
            insert con;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
             Test.startTest();
            ServiceTerritory sT= new ServiceTerritory();
            sT.name = 'TEST ST Mobile';
            sT.OperatingHoursId=oh.id;
            sT.Location_Code__c='03250-02851';
            sT.FSL_Service_Territory_Code__c = '02851';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            sT.IsActive=true;
            insert sT;
            
            FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
            insert lm;
            
            
            Asset asst = new Asset();
            asst.Labor_Multiplier__c = lm.id;
            asst.Name = '79704393';
            asst.AccountId=acc.Id;
            asst.Safety_Requirement__c=True;
            asst.Type__c='Engines';
            asst.Type_PSN__c='Engines-79644334';
            asst.Application_Code__c='234';
            asst.Individual__c ='';
            insert asst;
            
            WorkType wt=new WorkType();
            wt = TestUtility.newWorkType();
            
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            WorkOrder wo = new WorkOrder();
            Id woRecId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
            
            wo.AssetId=asst.id;
            wo.ServiceTerritoryId=sT.id;
            wo.Available_for_Service__c=datetime.now()+3;
            wo.SelectedSolution__c='abc';
            wo.createdDate=system.now().addDays(-109);
            wo.Process_Step__c = 'Repair';
            wo.Status = 'Repair';
            wo.Type__c = 'Dealer';
            wo.RecordTypeId = woRecId;
            wo.CSS_Hours__c =  1000;
            wo.Category1__c = 'Leak';
            wo.Complaint_Type1__c='Air Leak';
            wo.Mileage__c = 234569.29;
            wo.Mileage_Measure__c = 'MILES'; 
            wo.ESN__c = '79704393';
            wo.Dealer_Shop_Work_Order__c = '13121';
            wo.EVL_DX_SONumber__c=true;
            wo.WorkTypeId =wt.id;
            
            WorkOrderList.add(wo);
            
            WorkOrder wo1 = new WorkOrder();
            wo1.AssetId=asst.id;
            wo1.Category1__c = 'Leak';
            wo1.Complaint_Type1__c='Air Leak';
            wo1.Available_for_Service__c=datetime.now()+3;
            wo1.SelectedSolution__c='abc';
            wo1.Process_Step__c = '';
            wo1.Dealer_Shop_Work_Order__c = 'test';
            wo1.Mileage__c = 2232.21;
            wo1.CSS_Hours__c = 202;
            wo1.Mileage_Measure__c = 'MILES';
            wo1.Service_Model__c = 'New';
            wo1.EVL_DX_SONumber__c=true;
            wo1.Type__c= 'Dealer';
            WorkOrderList.add(wo1);
            
            
            insert WorkOrderList;
            
            List<case> lstcs=new List<case>();
            case cs=new case();
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=asst.id;
            cs.Description='test symptoms';
            cs.Service_Territory__c=st.id;
            cs.BusinessHoursId=bhs.id;
            
            cs.ServiceJob__c = wo.id;
            cs.Assigned_to__c = string.valueof(newUser.id) + ','+string.valueof(userinfo.getuserid());
            insert cs;
            lstcs.add(cs);
            
            ServiceResource sr=new ServiceResource();
            sr = TestUtility.createServiceResource(newUser.id, 'service resourse', true, true);
            
            List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO = TestUtility.newJobOrder();
            JO.createddate = system.now().addDays(-109);
            
            CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            CSS_Job_Order__c cjo2 = new CSS_Job_Order__c();
            
            cjo = TestUtility.createJobOrder(newUser.Id, 'Closed');
            cjo.createddate = system.now().addDays(-109);
            jobOrderList.add(cjo);  
            
            cjo2 = TestUtility.createJobOrder(newUser.Id, 'Intake');
            cjo2.createddate = system.now().addDays(-109);
            jobOrderList.add(cjo2);
            
            insert jobOrderList;
            
            FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
            cfc.Cummins_Fault_Code__c = '123';            
            insert cfc;
            
            FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
            spnfc.SPN__c ='3597-2';
            insert spnfc;
            
            FSL_PCode__c pfc= new FSL_PCode__c();
            pfc.CDS_ID__c='p008';
            insert pfc; 
            
            List<CSS_Fault_Code__c> faultCodeList = new List<CSS_Fault_Code__c>();
            CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
            fcode.Name=cfc.name;
            fcode.Type__c = 'Fault';
            fcode.Fault_Code_Type__c = '1';
            fcode.Service_Order__c = wo.id;
            fcode.extfield__c = cfc.id+' '+wo.id;
            faultCodeList.add(fcode);
            
            CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
            fcObj = TestUtility.newFaultCodeObj(wo.Id, cjo.Id);
            fcObj.createddate = system.now().addDays(-109);
            fcObj.Job_Order__c = cjo.id;
            faultCodeList.add(fcObj);
            
            CSS_Fault_Code__c fcObj2 = new CSS_Fault_Code__c();
            fcObj2 = TestUtility.newFaultCodeObj2(wo.Id, cjo.Id);
            fcObj2.createddate = system.now().addDays(-109);
            fcObj2.Job_Order__c = cjo2.id;
            faultCodeList.add(fcObj2);
            
            insert faultCodeList;
            
            List<CSS_SymptomQA__c> SymptomQAList = new List<CSS_SymptomQA__c>();
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym = TestUtility.newSymWithWO(wo.Id);
            sym.createddate = system.now().addDays(-109);
            sym.Job_Order__c = cjo.id;
            SymptomQAList.add(sym);
            
            CSS_SymptomQA__c sym2=new CSS_SymptomQA__c();
            sym2 = TestUtility.newSym(cjo.id);
            sym2.createddate = system.now().addDays(-109);
            sym2.Job_Order__c = cjo.id;
            SymptomQAList.add(sym2);
            
            insert SymptomQAList;
           
            List<CSS_Solutions__c> SolList = new List<CSS_Solutions__c>();
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol.FSL_Solution_Position__c='1';
            sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol.Repair_Response__c='Repair not performed.';//Repair Successful.';
            sol.Repair_Notes__c='Test';
            sol.FSL_Service_Job__c=wo.Id;
            sol.FaultCode__c=fcObj.Id;
            sol.Symptom__c =sym.id;
            sol.createdDate=system.now().addDays(-109);        
            SolList.add(sol);
            
            CSS_Solutions__c sol2=new CSS_Solutions__c();
            sol2.Case_Name__c='test';
            sol2.Name = 'S00000758';
            sol2.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol2.FSL_Solution_Position__c='1';
            sol2.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol2.Repair_Response__c='Repair Successful.';
            sol2.Repair_Notes__c='Test';
            sol2.Symptom__c=sym.id;
            sol2.FSL_Service_Job__c = wo.Id;
            sol2.Service_Job__c=cjo.id;
            sol2.FaultCode__c=fcObj2.Id;
            sol2.Symptom__c =sym2.id;
            sol2.createdDate=system.now().addDays(-109);
            SolList.add(sol2);
            
            insert SolList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c();
            solCmp.Solutions__c = sol.Id;
            solCmp.Name = 'Turbo';
            solCmp.Component_Code__c = 'AV';
            solCmp.System_Code__c = 'FH';
            solCmp.Performed_Review__c = true;
            solCmp.FSL_FA_Service_Order__c = wo.Id;
            solCmp.FSL_Service_Job__c = wo.Id;
            solCmp.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp);
            
            CSS_Solution_Component__c solCmp2 = new CSS_Solution_Component__c();
            solCmp2.Solutions__c = sol.Id;
            solCmp2.Name = 'Turbo';
            solCmp2.Component_Code__c = 'AV';
            solCmp2.System_Code__c = 'FH';
            solCmp2.Performed_Review__c = false;
            solCmp2.FSL_FA_Service_Order__c = wo.Id;
            solCmp2.FSL_Service_Job__c = wo.Id;
            solCmp2.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp2);
            
            insert solCompList;
            
            List<FSL_SRT__c> SRTList = new List<FSL_SRT__c>();
            FSL_SRT__c srtVar = new FSL_SRT__c();
            srtVar.Service_Order__c = wo.id;
            srtVar.SRT_AccessiblityCheck__c=True;
            srtVar.Access_Code_A__c = 65;
            srtVar.name = 'Test'+Math.random();
            srtVar.Type__c = 'typ';
            srtVar.Repair_SRTs__c =sol.FSL_Service_Job__c;
            srtVar.isPerformed__c =True;
            SRTList.add(srtVar);
            
            FSL_SRT__c srtVar2 = new FSL_SRT__c();
            srtVar.Solution_Number__c = sol.Id;
            srtVar2.Service_Order__c = wo.Id;
            srtVar2.SRT_AccessiblityCheck__c=True;
            srtVar2.Access_Code_A__c = 65;
            srtVar2.name = 'Test'+Math.random();
            srtVar2.Type__c = 'Repair';
            srtVar2.isPerformed__c =True;
            srtVar2.Repair_SRTs__c =sol.FSL_Service_Job__c;
            SRTList.add(srtVar2);
            
            insert SRTList; 
            
            
            
            List<CSS_JobEventTemporary__c> jobEventList = new List<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je2=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je3=new CSS_JobEventTemporary__c();
            String jsonstring = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            EVL_DX_SORequestWrapper wrapperdtAr = new EVL_DX_SORequestWrapper();
            
            EVL_DX_SORequestWrapper.DataArea DataAreaDetails = new EVL_DX_SORequestWrapper.DataArea();
            wrapperdtAr.setDataArea(DataAreaDetails);
            
            wrapperdtAr  = (EVL_DX_SORequestWrapper) System.JSON.deserialize(jsonstring, EVL_DX_SORequestWrapper.class);
            
            EVL_DX_SORequestWrapper.DataArea dtAr =  wrapperdtAr.getDataArea();
            
            if(dtAr.SERVICEHIST != null){
                for(integer i=0;i<dtAr.SERVICEHIST.size();i++)
                { 
                    String servLoc = dtAr.SERVICEHIST[i].ServiceLocation;
                    system.debug('ServLoc>>>>'+servLoc);
                    String accLocation = servLoc.substringAfter('-');
                    system.debug('SubServLoc>>>>'+accLocation);
                    String timeStamp;
                    DateTime acceptableDateTime;
                    if(dtAr.SERVICEHIST[i].JobDate != null){
                        dtAr.SERVICEHIST[i].JobDate =String.valueof(system.today().adddays(-1));
                    }
                }
            }
            jsonstring=JSON.serialize(wrapperdtAr);
            workorder so = [select id,WorkOrderNumber from workorder where id=:wo.id];
            String JobNumber = 'Dealer_DataExchange - 79704393' ;
            List<CSS_JobEventTemporary__c> Histlstjob2 = new List<CSS_JobEventTemporary__c>();
            je.key__c=JobNumber;
            je.ESN__c='79704393';
            je.JSONResponse__c=jsonstring;
            je.Attribute1__c = 'Att1'; 
            je.Attribute2__c = 'Att2';
            je.Attribute3__c = 'Att3';
            je.Attribute4__c = 'Att4';
            je.Attribute5__c = 'Att5';
            je.Attribute6__c = 'Att6';
            je.Attribute7__c = 'Att7';
            je.Attribute8__c = 'Att8';
            je.Attribute9__c = 'MI';
            je.Attribute14__c = '9182';
            je.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je);
            Histlstjob2.add(je);
            
            je2.key__c=JobNumber;
            je2.ESN__c='79704393';
            je2.JSONResponse__c=jsonstring;
            je2.Attribute1__c = 'Att1'; 
            je2.Attribute2__c = 'Att2';
            je2.Attribute3__c = 'Att3';
            je2.Attribute4__c = 'Att4';
            je2.Attribute5__c = 'Att5';
            je2.Attribute6__c = 'Att6';
            je2.Attribute7__c = 'Att7';
            je2.Attribute8__c = 'Att8';
            je2.Attribute9__c = 'KM';
            je2.Attribute14__c = '15000';
            je2.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je2);
            Histlstjob2.add(je2);
            
            je3.key__c=JobNumber;
            je3.ESN__c='79704393';
            je3.JSONResponse__c=jsonstring;
            je3.Attribute1__c = 'Att1'; 
            je3.Attribute2__c = 'Att2';
            je3.Attribute3__c = 'Att3';
            je3.Attribute4__c = 'Att4';
            je3.Attribute5__c = 'Att5';
            je3.Attribute6__c = 'Att6';
            je3.Attribute7__c = 'Att7';
            je3.Attribute8__c = 'Att8';
            je3.Attribute9__c = 'HR';
            je3.Attribute14__c = '134';
            je3.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je3);
            Histlstjob2.add(je3);
            insert jobEventList;
            
            List<CSS_Integration_Details__c> IntegrationList = new List<CSS_Integration_Details__c>();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.name= 'FSL_MoveX_ServiceHistory';
            conDetails.End_Point__c= 'https://test.Com/getServiceHistory';
            conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
            conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
            conDetails.IsActive__c = true;
            conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
            IntegrationList.add(conDetails);
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/gettoken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'OAGOAuth';
            IntegrationList.add(conDetails1);
            insert IntegrationList;
            
            
            List<serviceappointment> serviceappointmentList = new List<serviceappointment>();
            serviceappointment sa= new serviceappointment();
            sa.parentrecordId = wo.Id;
            sa.Status = 'None';
            sa.EarliestStartTime = datetime.now().addDays(2);
            sa.DueDate = System.now().addDays(30);
            sa.SchedStartTime=datetime.now().addDays(3);
            sa.SchedEndTime = datetime.now().addDays(4);
            sa.Service_Order__c= wo.id;
            sa.Formatted_Scheduled_Start__c='FSS';
            sa.Assigned_ServiceResource__c = sr.Id;
            sa.Is_a_Tech_Appointment__c=true;
            sa.user__c = newUser.id;
            sa.Service_Order__c = wo.id;
            serviceappointmentList.add(sa);
            
            serviceappointment sa1= new serviceappointment();
            sa1.parentrecordId = wo1.Id;
            sa1.Status = 'None';
            sa1.EarliestStartTime = datetime.now().addDays(2);
            sa1.DueDate = System.now().addDays(-109);
            sa1.SchedStartTime=datetime.now().addDays(3);
            sa1.SchedEndTime = datetime.now().addDays(4);
            sa1.Service_Order__c= wo1.id;
            sa1.Formatted_Scheduled_Start__c='populateResourceDetails';
            sa1.Is_a_Tech_Appointment__c=true;
            //serviceappointmentList.add(sa1);
            insert serviceappointmentList;
             Test.stopTest(); 
            sa.Status = 'Scheduled';
            //  update sa;       
            
            
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
            FSL_CL_IntakeVHCompCtrl.strWOId = WorkOrderList[0].id;
            FSL_CL_IntakeVHCompCtrl.dtCreated = System.now();
            DateTime lastDate = System.now().addDays(-109);
            FSL_CL_IntakeVHCompCtrl.getRecentHistJobs();
            FSL_CL_IntakeVHCompCtrl.getHistJobs();
           
        }
    }
    @isTest
    public static void testM5()
    {
        FSL_CL_IntakeVHCompCtrl obj = new FSL_CL_IntakeVHCompCtrl();
        string sCustomerName;
        string sCSSJobNum;
        string sShopsWorkOrder;
        string sServiceModel;
        string sLocation;
        string sWorkSummary;
        string sFaultcodeSymp;
        Decimal sMileage = 123456.45;
        string sRecent_Visit;
        string sCreated_Time_Zone;
        string sCreated_Time_sort;
        string sMeter;
        Boolean sRepeat_Visit;
        Id sjobId;
        
        obj.ServiceHistList = 'Sample';
        FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
        FSL_CL_IntakeVHCompCtrl.dtCreated=system.now();
        FSL_CL_IntakeVHCompCtrl.strJobNum = '79704393';
        FSL_CL_IntakeVHCompCtrl.strLocation = 'Cummins Brisbane';
        FSL_CL_IntakeVHCompCtrl.strLocationCode = '05340-05351';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com',ERP__c='BMS');
        
        User newUser2A = new User(Alias = 'standt2A', Email='test2A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing2A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p2.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test12AQnewUser@gmail.com');
        insert newUser; 
        insert newUser2A;
        
        System.runAs(newUser)
        {                        
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
           // Test.startTest();
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.IAM_Service_Provider_Code__c = '29550';
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.MobilePhone='9899909890';
            con.Email='test@test.com';
            con.AccountId=acc.id;
            insert con;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            ServiceTerritory sT= new ServiceTerritory();
            sT.name = 'TEST ST Mobile';
            sT.OperatingHoursId=oh.id;
            sT.Location_Code__c='03250-02851';
            sT.FSL_Service_Territory_Code__c = '02851';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            sT.IsActive=true;
            insert sT;
            
            FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
            insert lm;
            
            
            Asset asst = new Asset();
            asst.Labor_Multiplier__c = lm.id;
            asst.Name = '79704393';
            asst.AccountId=acc.Id;
            asst.Safety_Requirement__c=True;
            asst.Type__c='Engines';
            asst.Type_PSN__c='Engines-79644334';
            asst.Application_Code__c='234';
            asst.Individual__c ='';
            insert asst;
            
            WorkType wt=new WorkType();
            wt = TestUtility.newWorkType();
            
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            WorkOrder wo = new WorkOrder();
            Id woRecId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
            
            wo.AssetId=asst.id;
            wo.ServiceTerritoryId=sT.id;
            wo.Available_for_Service__c=datetime.now()+3;
            wo.SelectedSolution__c='abc';
            wo.createdDate=system.now().addDays(-109);
            wo.Process_Step__c = 'Repair';
            wo.Status = 'Repair';
            wo.Type__c = 'Dealer';
            wo.RecordTypeId = woRecId;
            wo.CSS_Hours__c =  1000;
            wo.Category1__c = 'Leak';
            wo.Complaint_Type1__c='Air Leak';
            wo.Mileage__c = 234569.29;
            wo.Mileage_Measure__c = 'MILES'; 
            wo.ESN__c = '79704393';
            wo.Dealer_Shop_Work_Order__c = '13121';
            wo.EVL_DX_SONumber__c=true;
            wo.WorkTypeId =wt.id;
            
            WorkOrderList.add(wo);
            
            WorkOrder wo1 = new WorkOrder();
            wo1.AssetId=asst.id;
            wo1.Category1__c = 'Leak';
            wo1.Complaint_Type1__c='Air Leak';
            wo1.Available_for_Service__c=datetime.now()+3;
            wo1.SelectedSolution__c='abc';
            wo1.Process_Step__c = '';
            wo1.Dealer_Shop_Work_Order__c = 'test';
            wo1.Mileage__c = 2232.21;
            wo1.CSS_Hours__c = 202;
            wo1.Mileage_Measure__c = 'MILES';
            wo1.Service_Model__c = 'New';
            wo1.EVL_DX_SONumber__c=true;
            wo1.Type__c= 'Dealer';
            WorkOrderList.add(wo1);
            
            
            insert WorkOrderList;
            
            List<case> lstcs=new List<case>();
            case cs=new case();
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=asst.id;
            cs.Description='test symptoms';
            cs.Service_Territory__c=st.id;
            cs.BusinessHoursId=bhs.id;
            
            cs.ServiceJob__c = wo.id;
            cs.Assigned_to__c = string.valueof(newUser.id) + ','+string.valueof(userinfo.getuserid());
            insert cs;
            lstcs.add(cs);
            
            ServiceResource sr=new ServiceResource();
            sr = TestUtility.createServiceResource(newUser.id, 'service resourse', true, true);
            
            List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO = TestUtility.newJobOrder();
            JO.createddate = system.now().addDays(-109);
            
            CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            CSS_Job_Order__c cjo2 = new CSS_Job_Order__c();
            
            cjo = TestUtility.createJobOrder(newUser.Id, 'Closed');
            cjo.createddate = system.now().addDays(-109);
            jobOrderList.add(cjo);  
            
            cjo2 = TestUtility.createJobOrder(newUser.Id, 'Intake');
            cjo2.createddate = system.now().addDays(-109);
            jobOrderList.add(cjo2);
            
            insert jobOrderList;
            
            FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
            cfc.Cummins_Fault_Code__c = '123';            
            insert cfc;
            
            FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
            spnfc.SPN__c ='3597-2';
            insert spnfc;
            
            FSL_PCode__c pfc= new FSL_PCode__c();
            pfc.CDS_ID__c='p008';
            insert pfc; 
             Test.startTest();
            List<CSS_Fault_Code__c> faultCodeList = new List<CSS_Fault_Code__c>();
            CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
            fcode.Name=cfc.name;
            fcode.Type__c = 'Fault';
            fcode.Fault_Code_Type__c = '1';
            fcode.Service_Order__c = wo.id;
            fcode.extfield__c = cfc.id+' '+wo.id;
            faultCodeList.add(fcode);
            
            CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
            fcObj = TestUtility.newFaultCodeObj(wo.Id, cjo.Id);
            fcObj.createddate = system.now().addDays(-10);
            fcObj.Job_Order__c = cjo.id;
            faultCodeList.add(fcObj);
            
            CSS_Fault_Code__c fcObj2 = new CSS_Fault_Code__c();
            fcObj2 = TestUtility.newFaultCodeObj2(wo.Id, cjo.Id);
            fcObj2.createddate = system.now().addDays(-10);
            fcObj2.Job_Order__c = cjo2.id;
            faultCodeList.add(fcObj2);
            
            insert faultCodeList;
            
            
            List<CSS_SymptomQA__c> SymptomQAList = new List<CSS_SymptomQA__c>();
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym = TestUtility.newSymWithWO(wo.Id);
            sym.createddate = system.now().addDays(-109);
            sym.Job_Order__c = cjo.id;
            SymptomQAList.add(sym);
            
            CSS_SymptomQA__c sym2=new CSS_SymptomQA__c();
            sym2 = TestUtility.newSym(cjo.id);
            sym2.createddate = system.now().addDays(-109);
            sym2.Job_Order__c = cjo.id;
            SymptomQAList.add(sym2);
            
            insert SymptomQAList;
            
            List<CSS_Solutions__c> SolList = new List<CSS_Solutions__c>();
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol.FSL_Solution_Position__c='1';
            sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol.Repair_Response__c='Repair not performed.';//Repair Successful.';
            sol.Repair_Notes__c='Test';
            sol.FSL_Service_Job__c=wo.Id;
            sol.FaultCode__c=fcObj.Id;
            sol.Symptom__c =sym.id;
            sol.createdDate=system.now().addDays(-109);        
            SolList.add(sol);
            
            CSS_Solutions__c sol2=new CSS_Solutions__c();
            sol2.Case_Name__c='test';
            sol2.Name = 'S00000758';
            sol2.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol2.FSL_Solution_Position__c='1';
            sol2.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol2.Repair_Response__c='Repair Successful.';
            sol2.Repair_Notes__c='Test';
            sol2.Symptom__c=sym.id;
            sol2.FSL_Service_Job__c = wo.Id;
            sol2.Service_Job__c=cjo.id;
            sol2.FaultCode__c=fcObj2.Id;
            sol2.Symptom__c =sym2.id;
            sol2.createdDate=system.now().addDays(-109);
            SolList.add(sol2);
            
            insert SolList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c();
            solCmp.Solutions__c = sol.Id;
            solCmp.Name = 'Turbo';
            solCmp.Component_Code__c = 'AV';
            solCmp.System_Code__c = 'FH';
            solCmp.Performed_Review__c = true;
            solCmp.FSL_FA_Service_Order__c = wo.Id;
            solCmp.FSL_Service_Job__c = wo.Id;
            solCmp.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp);
            
            CSS_Solution_Component__c solCmp2 = new CSS_Solution_Component__c();
            solCmp2.Solutions__c = sol.Id;
            solCmp2.Name = 'Turbo';
            solCmp2.Component_Code__c = 'AV';
            solCmp2.System_Code__c = 'FH';
            solCmp2.Performed_Review__c = false;
            solCmp2.FSL_FA_Service_Order__c = wo.Id;
            solCmp2.FSL_Service_Job__c = wo.Id;
            solCmp2.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp2);
            
            insert solCompList;
            
            List<FSL_SRT__c> SRTList = new List<FSL_SRT__c>();
            FSL_SRT__c srtVar = new FSL_SRT__c();
            srtVar.Service_Order__c = wo.id;
            srtVar.SRT_AccessiblityCheck__c=True;
            srtVar.Access_Code_A__c = 65;
            srtVar.name = 'Test'+Math.random();
            srtVar.Type__c = 'typ';
            srtVar.Repair_SRTs__c =sol.FSL_Service_Job__c;
            srtVar.isPerformed__c =True;
            SRTList.add(srtVar);
            
            FSL_SRT__c srtVar2 = new FSL_SRT__c();
            srtVar.Solution_Number__c = sol.Id;
            srtVar2.Service_Order__c = wo.Id;
            srtVar2.SRT_AccessiblityCheck__c=True;
            srtVar2.Access_Code_A__c = 65;
            srtVar2.name = 'Test'+Math.random();
            srtVar2.Type__c = 'Repair';
            srtVar2.isPerformed__c =True;
            srtVar2.Repair_SRTs__c =sol.FSL_Service_Job__c;
            SRTList.add(srtVar2);
            
            insert SRTList; 
            
            
            
            List<CSS_JobEventTemporary__c> jobEventList = new List<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je2=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je3=new CSS_JobEventTemporary__c();
            String jsonstring = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            EVL_DX_SORequestWrapper wrapperdtAr = new EVL_DX_SORequestWrapper();
            
            EVL_DX_SORequestWrapper.DataArea DataAreaDetails = new EVL_DX_SORequestWrapper.DataArea();
            wrapperdtAr.setDataArea(DataAreaDetails);
            
            wrapperdtAr  = (EVL_DX_SORequestWrapper) System.JSON.deserialize(jsonstring, EVL_DX_SORequestWrapper.class);
            
            EVL_DX_SORequestWrapper.DataArea dtAr =  wrapperdtAr.getDataArea();
            
            if(dtAr.SERVICEHIST != null){
                for(integer i=0;i<dtAr.SERVICEHIST.size();i++)
                { 
                    String servLoc = dtAr.SERVICEHIST[i].ServiceLocation;
                    system.debug('ServLoc>>>>'+servLoc);
                    String accLocation = servLoc.substringAfter('-');
                    system.debug('SubServLoc>>>>'+accLocation);
                    String timeStamp;
                    DateTime acceptableDateTime;
                    if(dtAr.SERVICEHIST[i].JobDate != null){
                        dtAr.SERVICEHIST[i].JobDate =String.valueof(system.today().adddays(-1));
                    }
                }
            }
            jsonstring=JSON.serialize(wrapperdtAr);
            workorder so = [select id,WorkOrderNumber from workorder where id=:wo.id];
            String JobNumber = 'Dealer_DataExchange - 79704393' ;
            List<CSS_JobEventTemporary__c> Histlstjob2 = new List<CSS_JobEventTemporary__c>();
            je.key__c=JobNumber;
            je.ESN__c='79704393';
            je.JSONResponse__c=jsonstring;
            je.Attribute1__c = 'Att1'; 
            je.Attribute2__c = 'Att2';
            je.Attribute3__c = 'Att3';
            je.Attribute4__c = 'Att4';
            je.Attribute5__c = 'Att5';
            je.Attribute6__c = 'Att6';
            je.Attribute7__c = 'Att7';
            je.Attribute8__c = 'Att8';
            je.Attribute9__c = 'MI';
            je.Attribute14__c = '9182';
            je.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je);
            Histlstjob2.add(je);
            
            je2.key__c=JobNumber;
            je2.ESN__c='79704393';
            je2.JSONResponse__c=jsonstring;
            je2.Attribute1__c = 'Att1'; 
            je2.Attribute2__c = 'Att2';
            je2.Attribute3__c = 'Att3';
            je2.Attribute4__c = 'Att4';
            je2.Attribute5__c = 'Att5';
            je2.Attribute6__c = 'Att6';
            je2.Attribute7__c = 'Att7';
            je2.Attribute8__c = 'Att8';
            je2.Attribute9__c = 'KM';
            je2.Attribute14__c = '15000';
            je2.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je2);
            Histlstjob2.add(je2);
            
            je3.key__c=JobNumber;
            je3.ESN__c='79704393';
            je3.JSONResponse__c=jsonstring;
            je3.Attribute1__c = 'Att1'; 
            je3.Attribute2__c = 'Att2';
            je3.Attribute3__c = 'Att3';
            je3.Attribute4__c = 'Att4';
            je3.Attribute5__c = 'Att5';
            je3.Attribute6__c = 'Att6';
            je3.Attribute7__c = 'Att7';
            je3.Attribute8__c = 'Att8';
            je3.Attribute9__c = 'HR';
            je3.Attribute14__c = '134';
            je3.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je3);
            Histlstjob2.add(je3);
            insert jobEventList;
            
            List<CSS_Integration_Details__c> IntegrationList = new List<CSS_Integration_Details__c>();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.name= 'FSL_MoveX_ServiceHistory';
            conDetails.End_Point__c= 'https://test.Com/getServiceHistory';
            conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
            conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
            conDetails.IsActive__c = true;
            conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
            IntegrationList.add(conDetails);
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/gettoken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'OAGOAuth';
            IntegrationList.add(conDetails1);
            insert IntegrationList;
            
            
            List<serviceappointment> serviceappointmentList = new List<serviceappointment>();
            serviceappointment sa= new serviceappointment();
            sa.parentrecordId = wo.Id;
            sa.Status = 'None';
            sa.EarliestStartTime = datetime.now().addDays(2);
            sa.DueDate = System.now().addDays(30);
            sa.SchedStartTime=datetime.now().addDays(3);
            sa.SchedEndTime = datetime.now().addDays(4);
            sa.Service_Order__c= wo.id;
            sa.Formatted_Scheduled_Start__c='FSS';
            sa.Assigned_ServiceResource__c = sr.Id;
            sa.Is_a_Tech_Appointment__c=true;
            sa.user__c = newUser.id;
            sa.Service_Order__c = wo.id;
            serviceappointmentList.add(sa);
            
            serviceappointment sa1= new serviceappointment();
            sa1.parentrecordId = wo1.Id;
            sa1.Status = 'None';
            sa1.EarliestStartTime = datetime.now().addDays(2);
            sa1.DueDate = System.now().addDays(-109);
            sa1.SchedStartTime=datetime.now().addDays(3);
            sa1.SchedEndTime = datetime.now().addDays(4);
            sa1.Service_Order__c= wo1.id;
            sa1.Formatted_Scheduled_Start__c='populateResourceDetails';
            sa1.Is_a_Tech_Appointment__c=true;
            //serviceappointmentList.add(sa1);
            insert serviceappointmentList;
            
            sa.Status = 'Scheduled';
            //  update sa;       
            
            
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
            FSL_CL_IntakeVHCompCtrl.strWOId = WorkOrderList[0].id;
            FSL_CL_IntakeVHCompCtrl.dtCreated = System.now();
            DateTime lastDate = System.now().addDays(-109);
            FSL_CL_IntakeVHCompCtrl.getRecentHistJobs();
            FSL_CL_IntakeVHCompCtrl.getHistJobs();
            Test.stopTest(); 
        }
    }
    @isTest
    public static void testM6()
    {
        FSL_CL_IntakeVHCompCtrl obj = new FSL_CL_IntakeVHCompCtrl();
        string sCustomerName;
        string sCSSJobNum;
        string sShopsWorkOrder;
        string sServiceModel;
        string sLocation;
        string sWorkSummary;
        string sFaultcodeSymp;
        Decimal sMileage = 123456.45;
        string sRecent_Visit;
        string sCreated_Time_Zone;
        string sCreated_Time_sort;
        string sMeter;
        Boolean sRepeat_Visit;
        Id sjobId;
        
        obj.ServiceHistList = 'Sample';
        FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
        FSL_CL_IntakeVHCompCtrl.dtCreated=system.now();
        FSL_CL_IntakeVHCompCtrl.strJobNum = '79704393';
        FSL_CL_IntakeVHCompCtrl.strLocation = 'Cummins Brisbane';
        FSL_CL_IntakeVHCompCtrl.strLocationCode = '05340-05351';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com',ERP__c='BMS');
        
        User newUser2A = new User(Alias = 'standt2A', Email='test2A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing2A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p2.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test12AQnewUser@gmail.com');
        insert newUser; 
        insert newUser2A;
        
        System.runAs(newUser)
        {                        
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
          
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.IAM_Service_Provider_Code__c = '29550';
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.MobilePhone='9899909890';
            con.Email='test@test.com';
            con.AccountId=acc.id;
            insert con;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            Test.startTest();
            ServiceTerritory sT= new ServiceTerritory();
            sT.name = 'TEST ST Mobile';
            sT.OperatingHoursId=oh.id;
            sT.Location_Code__c='03250-02851';
            sT.FSL_Service_Territory_Code__c = '02851';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            sT.IsActive=true;
            insert sT;
            
            FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
            insert lm;
            
            
            Asset asst = new Asset();
            asst.Labor_Multiplier__c = lm.id;
            asst.Name = '79704393';
            asst.AccountId=acc.Id;
            asst.Safety_Requirement__c=True;
            asst.Type__c='Engines';
            asst.Type_PSN__c='Engines-79644334';
            asst.Application_Code__c='234';
            asst.Individual__c ='';
            insert asst;
            
            WorkType wt=new WorkType();
            wt = TestUtility.newWorkType();
            
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            WorkOrder wo = new WorkOrder();
            Id woRecId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
            
            wo.AssetId=asst.id;
            wo.ServiceTerritoryId=sT.id;
            wo.Available_for_Service__c=datetime.now()+3;
            wo.SelectedSolution__c='abc';
            wo.createdDate=system.now().addDays(-109);
            wo.Process_Step__c = 'Repair';
            wo.Status = 'Repair';
            wo.Type__c = 'Dealer';
            wo.RecordTypeId = woRecId;
            wo.CSS_Hours__c =  1000;
            wo.Category1__c = 'Leak';
            wo.Complaint_Type1__c='Air Leak';
            wo.Mileage__c = 234569.29;
            wo.Mileage_Measure__c = 'MILES'; 
            wo.ESN__c = '79704393';
            wo.Dealer_Shop_Work_Order__c = '13121';
            wo.EVL_DX_SONumber__c=true;
            wo.WorkTypeId =wt.id;
            
            WorkOrderList.add(wo);
            
            WorkOrder wo1 = new WorkOrder();
            wo1.AssetId=asst.id;
            wo1.Category1__c = 'Leak';
            wo1.Complaint_Type1__c='Air Leak';
            wo1.Available_for_Service__c=datetime.now()+3;
            wo1.SelectedSolution__c='abc';
            wo1.Process_Step__c = '';
            wo1.Dealer_Shop_Work_Order__c = 'test';
            wo1.Mileage__c = 2232.21;
            wo1.CSS_Hours__c = 202;
            wo1.Mileage_Measure__c = 'MILES';
            wo1.Service_Model__c = 'New';
            wo1.EVL_DX_SONumber__c=true;
            wo1.Type__c= 'Dealer';
            WorkOrderList.add(wo1);
            
            
            insert WorkOrderList;
            
            List<case> lstcs=new List<case>();
            case cs=new case();
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=asst.id;
            cs.Description='test symptoms';
            cs.Service_Territory__c=st.id;
            cs.BusinessHoursId=bhs.id;
            
            cs.ServiceJob__c = wo.id;
            cs.Assigned_to__c = string.valueof(newUser.id) + ','+string.valueof(userinfo.getuserid());
            insert cs;
            lstcs.add(cs);
            
            ServiceResource sr=new ServiceResource();
            sr = TestUtility.createServiceResource(newUser.id, 'service resourse', true, true);
            
            List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO = TestUtility.newJobOrder();
            JO.createddate = system.now().addDays(-109);
            
            CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            CSS_Job_Order__c cjo2 = new CSS_Job_Order__c();
            
            cjo = TestUtility.createJobOrder(newUser.Id, 'Closed');
            cjo.createddate = system.now().addDays(-109);
            jobOrderList.add(cjo);  
            
            cjo2 = TestUtility.createJobOrder(newUser.Id, 'Intake');
            cjo2.createddate = system.now().addDays(-109);
            jobOrderList.add(cjo2);
            
            insert jobOrderList;
            
            FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
            cfc.Cummins_Fault_Code__c = '123';            
            insert cfc;
            
            FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
            spnfc.SPN__c ='3597-2';
            insert spnfc;
            
            FSL_PCode__c pfc= new FSL_PCode__c();
            pfc.CDS_ID__c='p008';
            insert pfc; 
            
            List<CSS_Fault_Code__c> faultCodeList = new List<CSS_Fault_Code__c>();
            CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
            fcode.Name=cfc.name;
            fcode.Type__c = 'Fault';
            fcode.Fault_Code_Type__c = '1';
            fcode.Service_Order__c = wo.id;
            fcode.extfield__c = cfc.id+' '+wo.id;
            faultCodeList.add(fcode);
            
            CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
            fcObj = TestUtility.newFaultCodeObj(wo.Id, cjo.Id);
            fcObj.createddate = system.now().addDays(-109);
            fcObj.Job_Order__c = cjo.id;
            faultCodeList.add(fcObj);
            
            CSS_Fault_Code__c fcObj2 = new CSS_Fault_Code__c();
            fcObj2 = TestUtility.newFaultCodeObj2(wo.Id, cjo.Id);
            fcObj2.createddate = system.now().addDays(-109);
            fcObj2.Job_Order__c = cjo2.id;
            faultCodeList.add(fcObj2);
            
            insert faultCodeList;
            
            List<CSS_SymptomQA__c> SymptomQAList = new List<CSS_SymptomQA__c>();
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym = TestUtility.newSymWithWO(wo.Id);
            sym.createddate = system.now().addDays(-109);
            sym.Job_Order__c = cjo.id;
            sym.Type__c = 'SearchString';
            SymptomQAList.add(sym);
            
            CSS_SymptomQA__c sym2=new CSS_SymptomQA__c();
            sym2 = TestUtility.newSym(cjo.id);
            sym2.createddate = system.now().addDays(-109);
            sym2.Job_Order__c = cjo.id;
            sym2.Type__c = 'SearchString';
            SymptomQAList.add(sym2);
            
            insert SymptomQAList;
            
            List<CSS_Solutions__c> SolList = new List<CSS_Solutions__c>();
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol.FSL_Solution_Position__c='1';
            sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol.Repair_Response__c='Repair not performed.';//Repair Successful.';
            sol.Repair_Notes__c='Test';
            sol.FSL_Service_Job__c=wo.Id;
            sol.FaultCode__c=fcObj.Id;
            sol.Symptom__c =sym.id;
            sol.createdDate=system.now().addDays(-109);        
            SolList.add(sol);
            
            CSS_Solutions__c sol2=new CSS_Solutions__c();
            sol2.Case_Name__c='test';
            sol2.Name = 'S00000758';
            sol2.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol2.FSL_Solution_Position__c='1';
            sol2.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol2.Repair_Response__c='Repair Successful.';
            sol2.Repair_Notes__c='Test';
            sol2.Symptom__c=sym.id;
            sol2.FSL_Service_Job__c = wo.Id;
            sol2.Service_Job__c=cjo.id;
            sol2.FaultCode__c=fcObj2.Id;
            sol2.Symptom__c =sym2.id;
            sol2.createdDate=system.now().addDays(-109);
            SolList.add(sol2);
            
            insert SolList;
             
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c();
            solCmp.Solutions__c = sol.Id;
            solCmp.Name = 'Turbo';
            solCmp.Component_Code__c = 'AV';
            solCmp.System_Code__c = 'FH';
            solCmp.Performed_Review__c = true;
            solCmp.FSL_FA_Service_Order__c = wo.Id;
            solCmp.FSL_Service_Job__c = wo.Id;
            solCmp.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp);
            
            CSS_Solution_Component__c solCmp2 = new CSS_Solution_Component__c();
            solCmp2.Solutions__c = sol.Id;
            solCmp2.Name = 'Turbo';
            solCmp2.Component_Code__c = 'AV';
            solCmp2.System_Code__c = 'FH';
            solCmp2.Performed_Review__c = false;
            solCmp2.FSL_FA_Service_Order__c = wo.Id;
            solCmp2.FSL_Service_Job__c = wo.Id;
            solCmp2.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp2);
            
            insert solCompList;
            
            List<FSL_SRT__c> SRTList = new List<FSL_SRT__c>();
            FSL_SRT__c srtVar = new FSL_SRT__c();
            srtVar.Service_Order__c = wo.id;
            srtVar.SRT_AccessiblityCheck__c=True;
            srtVar.Access_Code_A__c = 65;
            srtVar.name = 'Test'+Math.random();
            srtVar.Type__c = 'typ';
            srtVar.Repair_SRTs__c =sol.FSL_Service_Job__c;
            srtVar.isPerformed__c =True;
            SRTList.add(srtVar);
            
            FSL_SRT__c srtVar2 = new FSL_SRT__c();
            srtVar.Solution_Number__c = sol.Id;
            srtVar2.Service_Order__c = wo.Id;
            srtVar2.SRT_AccessiblityCheck__c=True;
            srtVar2.Access_Code_A__c = 65;
            srtVar2.name = 'Test'+Math.random();
            srtVar2.Type__c = 'Repair';
            srtVar2.isPerformed__c =True;
            srtVar2.Repair_SRTs__c =sol.FSL_Service_Job__c;
            SRTList.add(srtVar2);
            
            insert SRTList; 
            
            
            
            List<CSS_JobEventTemporary__c> jobEventList = new List<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je2=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je3=new CSS_JobEventTemporary__c();
            String jsonstring = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            EVL_DX_SORequestWrapper wrapperdtAr = new EVL_DX_SORequestWrapper();
            
            EVL_DX_SORequestWrapper.DataArea DataAreaDetails = new EVL_DX_SORequestWrapper.DataArea();
            wrapperdtAr.setDataArea(DataAreaDetails);
            
            wrapperdtAr  = (EVL_DX_SORequestWrapper) System.JSON.deserialize(jsonstring, EVL_DX_SORequestWrapper.class);
            
            EVL_DX_SORequestWrapper.DataArea dtAr =  wrapperdtAr.getDataArea();
            
            if(dtAr.SERVICEHIST != null){
                for(integer i=0;i<dtAr.SERVICEHIST.size();i++)
                { 
                    String servLoc = dtAr.SERVICEHIST[i].ServiceLocation;
                    system.debug('ServLoc>>>>'+servLoc);
                    String accLocation = servLoc.substringAfter('-');
                    system.debug('SubServLoc>>>>'+accLocation);
                    String timeStamp;
                    DateTime acceptableDateTime;
                    if(dtAr.SERVICEHIST[i].JobDate != null){
                        dtAr.SERVICEHIST[i].JobDate =String.valueof(system.today().adddays(-1));
                    }
                }
            }
            jsonstring=JSON.serialize(wrapperdtAr);
            workorder so = [select id,WorkOrderNumber from workorder where id=:wo.id];
            String JobNumber = 'Dealer_DataExchange - 79704393' ;
            List<CSS_JobEventTemporary__c> Histlstjob2 = new List<CSS_JobEventTemporary__c>();
            je.key__c=JobNumber;
            je.ESN__c='79704393';
            je.JSONResponse__c=jsonstring;
            je.Attribute1__c = 'Att1'; 
            je.Attribute2__c = 'Att2';
            je.Attribute3__c = 'Att3';
            je.Attribute4__c = 'Att4';
            je.Attribute5__c = 'Att5';
            je.Attribute6__c = 'Att6';
            je.Attribute7__c = 'Att7';
            je.Attribute8__c = 'Att8';
            je.Attribute9__c = 'MI';
            je.Attribute14__c = '9182';
            je.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je);
            Histlstjob2.add(je);
            
            je2.key__c=JobNumber;
            je2.ESN__c='79704393';
            je2.JSONResponse__c=jsonstring;
            je2.Attribute1__c = 'Att1'; 
            je2.Attribute2__c = 'Att2';
            je2.Attribute3__c = 'Att3';
            je2.Attribute4__c = 'Att4';
            je2.Attribute5__c = 'Att5';
            je2.Attribute6__c = 'Att6';
            je2.Attribute7__c = 'Att7';
            je2.Attribute8__c = 'Att8';
            je2.Attribute9__c = 'KM';
            je2.Attribute14__c = '15000';
            je2.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je2);
            Histlstjob2.add(je2);
            
            je3.key__c=JobNumber;
            je3.ESN__c='79704393';
            je3.JSONResponse__c=jsonstring;
            je3.Attribute1__c = 'Att1'; 
            je3.Attribute2__c = 'Att2';
            je3.Attribute3__c = 'Att3';
            je3.Attribute4__c = 'Att4';
            je3.Attribute5__c = 'Att5';
            je3.Attribute6__c = 'Att6';
            je3.Attribute7__c = 'Att7';
            je3.Attribute8__c = 'Att8';
            je3.Attribute9__c = 'HR';
            je3.Attribute14__c = '134';
            je3.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je3);
            Histlstjob2.add(je3);
            insert jobEventList;
                
            List<CSS_Integration_Details__c> IntegrationList = new List<CSS_Integration_Details__c>();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.name= 'FSL_MoveX_ServiceHistory';
            conDetails.End_Point__c= 'https://test.Com/getServiceHistory';
            conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
            conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
            conDetails.IsActive__c = true;
            conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
            IntegrationList.add(conDetails);
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/gettoken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'OAGOAuth';
            IntegrationList.add(conDetails1);
            insert IntegrationList;
            
            
            List<serviceappointment> serviceappointmentList = new List<serviceappointment>();
            serviceappointment sa= new serviceappointment();
            sa.parentrecordId = wo.Id;
            sa.Status = 'None';
            sa.EarliestStartTime = datetime.now().addDays(2);
            sa.DueDate = System.now().addDays(30);
            sa.SchedStartTime=datetime.now().addDays(3);
            sa.SchedEndTime = datetime.now().addDays(4);
            sa.Service_Order__c= wo.id;
            sa.Formatted_Scheduled_Start__c='FSS';
            sa.Assigned_ServiceResource__c = sr.Id;
            sa.Is_a_Tech_Appointment__c=true;
            sa.user__c = newUser.id;
            sa.Service_Order__c = wo.id;
            serviceappointmentList.add(sa);
            
            serviceappointment sa1= new serviceappointment();
            sa1.parentrecordId = wo1.Id;
            sa1.Status = 'None';
            sa1.EarliestStartTime = datetime.now().addDays(2);
            sa1.DueDate = System.now().addDays(-109);
            sa1.SchedStartTime=datetime.now().addDays(3);
            sa1.SchedEndTime = datetime.now().addDays(4);
            sa1.Service_Order__c= wo1.id;
            sa1.Formatted_Scheduled_Start__c='populateResourceDetails';
            sa1.Is_a_Tech_Appointment__c=true;
            //serviceappointmentList.add(sa1);
            insert serviceappointmentList;
            Test.stopTest(); 
            sa.Status = 'Scheduled';
            //  update sa;       
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
            FSL_CL_IntakeVHCompCtrl.strWOId = WorkOrderList[0].id;
            FSL_CL_IntakeVHCompCtrl.dtCreated = System.now();
            DateTime lastDate = System.now().addDays(-109);
            FSL_CL_IntakeVHCompCtrl.getRecentHistJobs();
            FSL_CL_IntakeVHCompCtrl.getHistJobs();
          
        }
    }
    
    @isTest
    public static void testM7()
    {
        FSL_CL_IntakeVHCompCtrl obj = new FSL_CL_IntakeVHCompCtrl();
        string sCustomerName;
        string sCSSJobNum;
        string sShopsWorkOrder;
        string sServiceModel;
        string sLocation;
        string sWorkSummary;
        string sFaultcodeSymp;
        Decimal sMileage = 123456.45;
        string sRecent_Visit;
        string sCreated_Time_Zone;
        string sCreated_Time_sort;
        string sMeter;
        Boolean sRepeat_Visit;
        Id sjobId;
        
        obj.ServiceHistList = 'Sample';
        FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
        FSL_CL_IntakeVHCompCtrl.dtCreated=system.now();
        FSL_CL_IntakeVHCompCtrl.strLocation = 'Cummins Brisbane';
        FSL_CL_IntakeVHCompCtrl.strLocationCode = '05340-05351';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com',ERP__c='BMS');
        
        User newUser2A = new User(Alias = 'standt2A', Email='test2A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing2A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p2.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test12AQnewUser@gmail.com');
        insert newUser; 
        insert newUser2A;
        
        System.runAs(newUser)
        {                        
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
            
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.MobilePhone='9899909890';
            con.Email='test@test.com';
            con.AccountId=acc.id;
            insert con;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            Test.startTest(); 
            ServiceTerritory sT= new ServiceTerritory();
            sT.name = 'TEST ST Mobile';
            sT.OperatingHoursId=oh.id;
            sT.Location_Code__c='03250-02851';
            sT.FSL_Service_Territory_Code__c = '02851';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            sT.IsActive=true;
            insert sT;
            
            FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
            insert lm;
            
            
            Asset asst = new Asset();
            asst.Name = '79704393';
            asst.Labor_Multiplier__c = lm.id;
            asst.AccountId=acc.Id;
            asst.Safety_Requirement__c=True;
            asst.Type__c='Engines';
            asst.Type_PSN__c='Engines-79644334';
            asst.Application_Code__c='234';
            asst.Individual__c ='';
            insert asst;
            
            case cs=new case();
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=asst.id;
            cs.Description='test symptoms';
            cs.Service_Territory__c=st.id;
            cs.BusinessHoursId=bhs.id;
            insert cs;
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            WorkOrder wo = new WorkOrder();
            wo.ServiceTerritoryId=sT.id;
            wo.AccountId=acc.id;
            wo.ContactId=con.id;
            wo.Repair_Location__c='In Shop';
            wo.AssetId=asst.id;
            wo.Available_for_Service__c=datetime.now()+3;
            wo.SelectedSolution__c='abc';
            wo.createdDate=system.now().addDays(-109);
            wo.Process_Step__c = 'Repair';
            wo.Status = 'Repair';
            wo.CSS_Hours__c =  1000;
            wo.Category1__c = 'Leak';
            wo.Complaint_Type1__c='Air Leak';
            wo.Mileage__c = 0;
            wo.Mileage_Measure__c = 'MILES'; 
            wo.ESN__c = '79704393';
            wo.Type__c = 'Dealer';
            WorkOrderList.add(wo);
            
            WorkOrder wo1 = new WorkOrder();
            wo1.ServiceTerritoryId=sT.id;
            wo1.AccountId=acc.id;
            wo1.ContactId=con.id;
            wo1.Repair_Location__c='In Shop';
            wo1.AssetId=asst.id;
            wo1.Category1__c = 'Leak';
            wo1.Complaint_Type1__c='Air Leak';
            wo1.Available_for_Service__c=datetime.now()+3;
            wo1.SelectedSolution__c='abc';
            wo1.Process_Step__c = 'Repair';
            wo1.Shop_Work_Order__c = 'test';
            wo1.Mileage__c = 0;
            wo1.CSS_Hours__c = 202;
            wo1.Mileage_Measure__c = 'MILES';
            wo1.Service_Model__c = 'New';
            WorkOrderList.add(wo1);
            
           
            insert WorkOrderList;
            
             //Test.startTest();
            
            List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
            
            CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            
            cjo.Customer_Name__c = 'Wonder Trucks';
            cjo.Assigned_To__c=newUser.id;
            cjo.Additional_Tech1__c=newUser.id;
            cjo.Additional_Tech2__c=newUser.id;    
            cjo.Status__c='Intake';
            cjo.DSID__c='DSBDT2274';
            cjo.unit_number__c='12345';
            cjo.createdDate=system.now().addDays(-109);
            cjo.Shop_Work_Order__c='abcd';
            cjo.ESN__c='79704393';
            cjo.DSID_UpdateTimestamp__c=System.now();
            cjo.INSITE_UpdateTimeStamp__c=System.now();
            cjo.Service_Model__c = 'werwe';
            cjo.Category__c = 'Leak';
            cjo.Complaint_Type__c = 'Air Leak';
            jobOrderList.add(cjo); 
            
            insert jobOrderList;
            
            FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
            cfc.Cummins_Fault_Code__c = '123';            
            insert cfc;
            
            FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
            spnfc.SPN__c ='3597-2';
            insert spnfc;
            
            FSL_PCode__c pfc= new FSL_PCode__c();
            pfc.CDS_ID__c='p008';
            insert pfc;
            
            List<CSS_Fault_Code__c> faultCodeList = new List<CSS_Fault_Code__c>();
            
            CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
            fcObj.Name = 'test';
            fcObj.Primary_Fault_Code__c = 6;
            fcObj.Service_Order__c = wo.Id;
            fcObj.isPole__c = true;
            fcObj.PoleMessage__c = true;
            fcObj.Service_Order__c=wo.Id;
            fcObj.Sequence__c = 3;
            fcObj.Mod__c = 'test';
            fcObj.Job_Order__c = cjo.Id;
            fcObj.Fault_Code_Type__c ='New';
            fcObj.Related_Fault_Code__c = 'abc';       
            fcObj.Number_of_Solutions__c = '60';
            fcObj.CreatedDate = system.now().addDays(-109);
            faultCodeList.add(fcObj);
            
            insert faultCodeList;
            
            List<CSS_SymptomQA__c> SymptomQAList = new List<CSS_SymptomQA__c>();
            
            
            CSS_SymptomQA__c sym2=new CSS_SymptomQA__c();
            sym2.Job_Order__c=cjo.id;
            sym2.Name = 'Black Smoke';
            sym2.caption__c ='white smoke';
            sym2.Option1__c  ='12213';
            sym2.Option_type__c  ='qwewqe';
            sym2.Guide_Question__c ='1asdsad2213';
            sym2.Type__c  ='SearchString';
            sym2.createdDate=system.now().addDays(-109);
            SymptomQAList.add(sym2);
            
            insert SymptomQAList;
            
            List<CSS_Solutions__c> SolList = new List<CSS_Solutions__c>();
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol.FSL_Solution_Position__c='1';
            sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol.Repair_Response__c='Repair not performed.';//Repair Successful.';
            sol.Repair_Notes__c='Test';
            sol.FSL_Service_Job__c=wo.Id;
            sol.createdDate=system.now().addDays(-109);        
            SolList.add(sol);
            
            insert SolList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c();
            solCmp.Solutions__c = sol.Id;
            solCmp.Name = 'Turbo';
            solCmp.Component_Code__c = 'AV';
            solCmp.System_Code__c = 'FH';
            solCmp.Performed_Review__c = true;
            solCmp.FSL_FA_Service_Order__c = wo.Id;
            solCmp.FSL_Service_Job__c = wo.Id;
            solCmp.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp);
            
            CSS_Solution_Component__c solCmp2 = new CSS_Solution_Component__c();
            solCmp2.Solutions__c = sol.Id;
            solCmp2.Name = 'Turbo';
            solCmp2.Component_Code__c = 'AV';
            solCmp2.System_Code__c = 'FH';
            solCmp2.Performed_Review__c = false;
            solCmp2.FSL_FA_Service_Order__c = wo.Id;
            solCmp2.FSL_Service_Job__c = wo.Id;
            solCmp2.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp2);
            
            insert solCompList;
            
            List<FSL_SRT__c> SRTList = new List<FSL_SRT__c>();
            FSL_SRT__c srtVar = new FSL_SRT__c();
            srtVar.Service_Order__c = wo.id;
            srtVar.SRT_AccessiblityCheck__c=True;
            srtVar.Access_Code_A__c = 65;
            srtVar.name = 'Test'+Math.random();
            srtVar.Type__c = 'typ';
            srtVar.Repair_SRTs__c =sol.FSL_Service_Job__c;
            srtVar.isPerformed__c =True;
            SRTList.add(srtVar);
            
            FSL_SRT__c srtVar2 = new FSL_SRT__c();
            srtVar.Solution_Number__c = sol.Id;
            srtVar2.Service_Order__c = wo.Id;
            srtVar2.SRT_AccessiblityCheck__c=True;
            srtVar2.Access_Code_A__c = 65;
            srtVar2.name = 'Test'+Math.random();
            srtVar2.Type__c = 'Repair';
            srtVar2.isPerformed__c =True;
            srtVar2.Repair_SRTs__c =sol.FSL_Service_Job__c;
            SRTList.add(srtVar2);
            
            insert SRTList;
            
            
            List<CSS_JobEventTemporary__c> jobEventList = new List<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je2=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je3=new CSS_JobEventTemporary__c();
            
            List<CSS_JobEventTemporary__c> Histlstjob2 = new List<CSS_JobEventTemporary__c>();
            je.key__c='79704393';
            je.Attribute1__c = 'Att1'; 
            je.Attribute2__c = 'Att2';
            je.Attribute3__c = 'Att3';
            je.Attribute4__c = 'Att4';
            je.Attribute5__c = 'Att5';
            je.Attribute6__c = 'Att6';
            je.Attribute7__c = 'Att7';
            je.Attribute8__c = 'Att8';
            je.Attribute9__c = 'MI';
            je.Attribute14__c = '9182';
            je.Attribute13__c = system.now().addDays(-730);     
            jobEventList.add(je);
            Histlstjob2.add(je);
            
            je2.key__c='79704393';
            je2.Attribute1__c = 'Att1'; 
            je2.Attribute2__c = 'Att2';
            je2.Attribute3__c = 'Att3';
            je2.Attribute4__c = 'Att4';
            je2.Attribute5__c = 'Att5';
            je2.Attribute6__c = 'Att6';
            je2.Attribute7__c = 'Att7';
            je2.Attribute8__c = 'Att8';
            je2.Attribute9__c = 'KM';
            je2.Attribute14__c = '15000';
            je2.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je2);
            Histlstjob2.add(je2);
            
            je3.key__c='79704393';
            je3.Attribute1__c = 'Att1'; 
            je3.Attribute2__c = 'Att2';
            je3.Attribute3__c = 'Att3';
            je3.Attribute4__c = 'Att4';
            je3.Attribute5__c = 'Att5';
            je3.Attribute6__c = 'Att6';
            je3.Attribute7__c = 'Att7';
            je3.Attribute8__c = 'Att8';
            je3.Attribute9__c = 'HR';
            je3.Attribute14__c = '134';
            je3.Attribute13__c = system.now().addDays(-109);     
            jobEventList.add(je3);
            Histlstjob2.add(je3);
            insert jobEventList;
              Test.stopTest();
            List<CSS_Integration_Details__c> IntegrationList = new List<CSS_Integration_Details__c>();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.name= 'FSL_MoveX_ServiceHistory';
            conDetails.End_Point__c= 'https://test.Com/getServiceHistory';
            conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
            conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
            conDetails.IsActive__c = true;
            conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
            IntegrationList.add(conDetails);
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/gettoken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'OAGOAuth';
            IntegrationList.add(conDetails1);
            
            insert IntegrationList;
            
            
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
             List<string> lststrLocationterritory = new List<string>();
            lststrLocationterritory.add(sT.name);
            FSL_CL_IntakeVHCompCtrl.strLocationterritory = lststrLocationterritory;
            FSL_CL_IntakeVHCompCtrl.dtCreated = System.now();
            DateTime lastDate = System.now().addDays(-30);
            FSL_CL_IntakeVHCompCtrl.getRecentHistJobs();
            FSL_CL_IntakeVHCompCtrl.getHistJobs();
          
        }
    }
     @isTest
    public static void testM8()
    {
        FSL_CL_IntakeVHCompCtrl obj = new FSL_CL_IntakeVHCompCtrl();
        string sCustomerName;
        string sCSSJobNum;
        string sShopsWorkOrder;
        string sServiceModel;
        string sLocation;
        string sWorkSummary;
        string sFaultcodeSymp;
        Decimal sMileage = 123456.45;
        string sRecent_Visit;
        string sCreated_Time_Zone;
        string sCreated_Time_sort;
        string sMeter;
        Boolean sRepeat_Visit;
        Id sjobId;
        
        obj.ServiceHistList = 'Sample';
        FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
        FSL_CL_IntakeVHCompCtrl.dtCreated=system.now();
        FSL_CL_IntakeVHCompCtrl.strLocation = 'Cummins Brisbane';
        FSL_CL_IntakeVHCompCtrl.strLocationCode = '05340-05351';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com',ERP__c='BMS');
        
        User newUser2A = new User(Alias = 'standt2A', Email='test2A@gmail.com', UserRoleId = ur.Id ,
                                  EmailEncodingKey='UTF-8', LastName='Testing2A', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p2.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='test12AQnewUser@gmail.com');
        insert newUser; 
        insert newUser2A;
        
        System.runAs(newUser)
        {                        
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
            
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.MobilePhone='9899909890';
            con.Email='test@test.com';
            con.AccountId=acc.id;
            insert con;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            ServiceTerritory sT= new ServiceTerritory();
            sT.name = 'TEST ST Mobile';
            sT.OperatingHoursId=oh.id;
            sT.Location_Code__c='03250-02851';
            sT.FSL_Service_Territory_Code__c = '02851';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            sT.IsActive=true;
            insert sT;
            
            FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
            insert lm;
              Test.startTest(); 
            
            Asset asst = new Asset();
            asst.Name = '79704393';
            asst.Labor_Multiplier__c = lm.id;
            asst.AccountId=acc.Id;
            asst.Safety_Requirement__c=True;
            asst.Type__c='Engines';
            asst.Type_PSN__c='Engines-79644334';
            asst.Application_Code__c='234';
            asst.Individual__c ='';
            insert asst;
            
            case cs=new case();
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=asst.id;
            cs.Description='test symptoms';
            cs.Service_Territory__c=st.id;
            cs.BusinessHoursId=bhs.id;
            insert cs;
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            WorkOrder wo = new WorkOrder();
            wo.ServiceTerritoryId=sT.id;
            wo.AccountId=acc.id;
            wo.ContactId=con.id;
            wo.Repair_Location__c='In Shop';
            wo.AssetId=asst.id;
            wo.Available_for_Service__c=datetime.now()+3;
            wo.SelectedSolution__c='abc';
            wo.createdDate=system.now().addDays(-10);
            wo.Process_Step__c = 'Repair';
            wo.Status = 'Repair';
           // wo.CSS_Hours__c =  1000;
            wo.Category1__c = 'Leak';
            wo.Complaint_Type1__c='Air Leak';
            wo.Mileage__c = 0;
            wo.Mileage_Measure__c = 'MILES'; 
            wo.ESN__c = '79704393';
            wo.Type__c = 'Dealer';
            WorkOrderList.add(wo);
            
            WorkOrder wo1 = new WorkOrder();
            wo1.ServiceTerritoryId=sT.id;
            wo1.AccountId=acc.id;
            wo1.ContactId=con.id;
            wo1.Repair_Location__c='In Shop';
            wo1.AssetId=asst.id;
            wo1.Category1__c = 'Leak';
            wo1.Complaint_Type1__c='Air Leak';
            wo1.Available_for_Service__c=datetime.now()+3;
            wo1.SelectedSolution__c='abc';
            wo1.Process_Step__c = 'Repair';
            wo1.Shop_Work_Order__c = 'test';
            wo1.Mileage__c = 0;
            wo1.CSS_Hours__c = 202;
            wo1.Mileage_Measure__c = 'MILES';
            wo1.Service_Model__c = 'New';
            WorkOrderList.add(wo1);
            
            
            insert WorkOrderList;
            //Test.startTest();
            
            List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
            
            CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            
            cjo.Customer_Name__c = 'Wonder Trucks';
            cjo.Assigned_To__c=newUser.id;
            cjo.Additional_Tech1__c=newUser.id;
            cjo.Additional_Tech2__c=newUser.id;    
            cjo.Status__c='Intake';
            cjo.DSID__c='DSBDT2274';
            cjo.unit_number__c='12345';
            cjo.createdDate=system.now().addDays(-10);
            cjo.Shop_Work_Order__c='abcd';
            cjo.ESN__c='79704393';
            cjo.DSID_UpdateTimestamp__c=System.now();
            cjo.INSITE_UpdateTimeStamp__c=System.now();
            cjo.Service_Model__c = 'werwe';
            cjo.Category__c = 'Leak';
            cjo.Complaint_Type__c = 'Air Leak';
            cjo.Mileage__c = 0;
            jobOrderList.add(cjo); 
            
            insert jobOrderList;
          
            FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
            cfc.Cummins_Fault_Code__c = '123';            
            insert cfc;
            
            FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
            spnfc.SPN__c ='3597-2';
            insert spnfc;
            
            FSL_PCode__c pfc= new FSL_PCode__c();
            pfc.CDS_ID__c='p008';
            insert pfc;
            
            List<CSS_Fault_Code__c> faultCodeList = new List<CSS_Fault_Code__c>();
            
            CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
            fcObj.Name = 'test';
            fcObj.Primary_Fault_Code__c = 6;
            fcObj.Service_Order__c = wo.Id;
            fcObj.isPole__c = true;
            fcObj.PoleMessage__c = true;
            fcObj.Service_Order__c=wo.Id;
            fcObj.Sequence__c = 3;
            fcObj.Mod__c = 'test';
            fcObj.Job_Order__c = cjo.Id;
            fcObj.Fault_Code_Type__c ='New';
            fcObj.Related_Fault_Code__c = 'abc';       
            fcObj.Number_of_Solutions__c = '60';
            fcObj.CreatedDate = system.now().addDays(-10);
            faultCodeList.add(fcObj);
            
            insert faultCodeList;
            
            List<CSS_SymptomQA__c> SymptomQAList = new List<CSS_SymptomQA__c>();
            
            
            CSS_SymptomQA__c sym2=new CSS_SymptomQA__c();
            sym2.Job_Order__c=cjo.id;
            sym2.Name = 'Black Smoke';
            sym2.caption__c ='white smoke';
            sym2.Option1__c  ='12213';
            sym2.Option_type__c  ='qwewqe';
            sym2.Guide_Question__c ='1asdsad2213';
            sym2.Type__c  ='SearchString';
            sym2.createdDate=system.now().addDays(-10);
            SymptomQAList.add(sym2);
            
            insert SymptomQAList;
            
            List<CSS_Solutions__c> SolList = new List<CSS_Solutions__c>();
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Solution_Title__c='Battery circuit fuse has open circuit test';
            sol.FSL_Solution_Position__c='1';
            sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
            sol.Repair_Response__c='Repair not performed.';//Repair Successful.';
            sol.Repair_Notes__c='Test';
            sol.FSL_Service_Job__c=wo.Id;
            sol.createdDate=system.now().addDays(-10);        
            SolList.add(sol);
            
            insert SolList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c();
            solCmp.Solutions__c = sol.Id;
            solCmp.Name = 'Turbo';
            solCmp.Component_Code__c = 'AV';
            solCmp.System_Code__c = 'FH';
            solCmp.Performed_Review__c = true;
            solCmp.FSL_FA_Service_Order__c = wo.Id;
            solCmp.FSL_Service_Job__c = wo.Id;
            solCmp.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp);
            
            CSS_Solution_Component__c solCmp2 = new CSS_Solution_Component__c();
            solCmp2.Solutions__c = sol.Id;
            solCmp2.Name = 'Turbo';
            solCmp2.Component_Code__c = 'AV';
            solCmp2.System_Code__c = 'FH';
            solCmp2.Performed_Review__c = false;
            solCmp2.FSL_FA_Service_Order__c = wo.Id;
            solCmp2.FSL_Service_Job__c = wo.Id;
            solCmp2.FSL_Account_Code__c = 'New Parts Warranty - 62';
            solCompList.add(solCmp2);
            
            insert solCompList;
            
            List<FSL_SRT__c> SRTList = new List<FSL_SRT__c>();
            FSL_SRT__c srtVar = new FSL_SRT__c();
            srtVar.Service_Order__c = wo.id;
            srtVar.SRT_AccessiblityCheck__c=True;
            srtVar.Access_Code_A__c = 65;
            srtVar.name = 'Test'+Math.random();
            srtVar.Type__c = 'typ';
            srtVar.Repair_SRTs__c =sol.FSL_Service_Job__c;
            srtVar.isPerformed__c =True;
            SRTList.add(srtVar);
            
            FSL_SRT__c srtVar2 = new FSL_SRT__c();
            srtVar.Solution_Number__c = sol.Id;
            srtVar2.Service_Order__c = wo.Id;
            srtVar2.SRT_AccessiblityCheck__c=True;
            srtVar2.Access_Code_A__c = 65;
            srtVar2.name = 'Test'+Math.random();
            srtVar2.Type__c = 'Repair';
            srtVar2.isPerformed__c =True;
            srtVar2.Repair_SRTs__c =sol.FSL_Service_Job__c;
            SRTList.add(srtVar2);
            
            insert SRTList;
            
            
            List<CSS_JobEventTemporary__c> jobEventList = new List<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je2=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je3=new CSS_JobEventTemporary__c();
            
            List<CSS_JobEventTemporary__c> Histlstjob2 = new List<CSS_JobEventTemporary__c>();
            je.key__c='79704393';
            je.Attribute1__c = 'Att1'; 
            je.Attribute2__c = 'Att2';
            je.Attribute3__c = 'Att3';
            je.Attribute4__c = 'Att4';
            je.Attribute5__c = 'Att5';
            je.Attribute6__c = 'Att6';
            je.Attribute7__c = 'Att7';
            je.Attribute8__c = 'Att8';
            je.Attribute9__c = 'MI';
            je.Attribute14__c = '9182';
            je.Attribute13__c = system.now().addDays(-10);     
            jobEventList.add(je);
            Histlstjob2.add(je);
            
            je2.key__c='79704393';
            je2.Attribute1__c = 'Att1'; 
            je2.Attribute2__c = 'Att2';
            je2.Attribute3__c = 'Att3';
            je2.Attribute4__c = 'Att4';
            je2.Attribute5__c = 'Att5';
            je2.Attribute6__c = 'Att6';
            je2.Attribute7__c = 'Att7';
            je2.Attribute8__c = 'Att8';
            je2.Attribute9__c = 'KM';
            je2.Attribute14__c = '15000';
            je2.Attribute13__c = system.now().addDays(-10);     
            jobEventList.add(je2);
            Histlstjob2.add(je2);
            
            je3.key__c='79704393';
            je3.Attribute1__c = 'Att1'; 
            je3.Attribute2__c = 'Att2';
            je3.Attribute3__c = 'Att3';
            je3.Attribute4__c = 'Att4';
            je3.Attribute5__c = 'Att5';
            je3.Attribute6__c = 'Att6';
            je3.Attribute7__c = 'Att7';
            je3.Attribute8__c = 'Att8';
            je3.Attribute9__c = 'HR';
            je3.Attribute14__c = '134';
            je3.Attribute13__c = system.now().addDays(-10);     
            jobEventList.add(je3);
            Histlstjob2.add(je3);
            insert jobEventList;
            
            List<CSS_Integration_Details__c> IntegrationList = new List<CSS_Integration_Details__c>();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.name= 'FSL_MoveX_ServiceHistory';
            conDetails.End_Point__c= 'https://test.Com/getServiceHistory';
            conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
            conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
            conDetails.IsActive__c = true;
            conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
            IntegrationList.add(conDetails);
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/gettoken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'OAGOAuth';
            IntegrationList.add(conDetails1);
            
            insert IntegrationList;
             Test.stopTest();
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
            List<string> lststrLocationterritory = new List<string>();
            lststrLocationterritory.add(sT.name);
            FSL_CL_IntakeVHCompCtrl.strLocationterritory = lststrLocationterritory;
            FSL_CL_IntakeVHCompCtrl.dtCreated = System.now();
            DateTime lastDate = System.now().addDays(-30);
            FSL_CL_IntakeVHCompCtrl.getRecentHistJobs();
            FSL_CL_IntakeVHCompCtrl.getHistJobs();
           
        }
    }
   /*  @isTest
    public static void test9()
    {
        FSL_CL_IntakeVHCompCtrl obj = new FSL_CL_IntakeVHCompCtrl();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        
        User newUser = new User(Alias = 'standt',Email='test1@gmail.com',UserRoleId = ur.Id,EmailEncodingKey='UTF-8',LastName='Testing',LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com',ERP__c='BMS');

        insert newUser;
        System.runAs(newUser)
        {
            Map<String, SObject> testResourceMap = TestUtility.createSingleTestResource();
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
            
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc = TestUtility.createTestAccount('Test Account', accRecId);
            
            FSL_Labor_Multiplier__c lm = new FSL_Labor_Multiplier__c();
            lm.Name = 'TIER B';
            insert lm;
            
            Asset asst = new Asset();
            asst = TestUtility.createTestAsset(acc,'Engines-79644334');
            
            case cs=new case();
            cs = TestUtility.createTestCase(acc.Id, asst.Id);
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            WorkOrder wo = new WorkOrder();
            wo = TestUtility.createWorkOrder('test', testResourceMap.get('WorkType').Id, testResourceMap.get('ServiceTerritory').Id);
            WorkOrderList.add(wo);
            
            WorkOrder wo1 = new WorkOrder();
            wo1 = TestUtility.createWorkOrder('test', testResourceMap.get('WorkType').Id, testResourceMap.get('ServiceTerritory').Id);
            WorkOrderList.add(wo1);
            
            List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
            
            CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            
            cjo = TestUtility.createJobOrder(newUser.Id,'Closed');
            jobOrderList.add(cjo); 
            
            insert jobOrderList;
            
            FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
            cfc.Cummins_Fault_Code__c = '123';            
            insert cfc;
            
            FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
            spnfc.SPN__c ='3597-2';
            insert spnfc;
            
            FSL_PCode__c pfc= new FSL_PCode__c();
            pfc.CDS_ID__c='p008';
            insert pfc;
            
            Test.startTest();
            List<CSS_Fault_Code__c> faultCodeList = new List<CSS_Fault_Code__c>();
            
            CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
            fcObj = TestUtility.newFaultCodeObj(wo.id, cjo.id);
            faultCodeList.add(fcObj);
            
            insert faultCodeList;
            
            List<CSS_SymptomQA__c> SymptomQAList = new List<CSS_SymptomQA__c>();            
            
            CSS_SymptomQA__c sym2=new CSS_SymptomQA__c();
            sym2 = TestUtility.newSym(cjo.ID);
            SymptomQAList.add(sym2);
            
            insert SymptomQAList;
            
            List<CSS_Solutions__c> SolList = new List<CSS_Solutions__c>();
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol = TestUtility.newSol(wo.ID);
            SolList.add(sol);
            
            insert SolList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCmp = new CSS_Solution_Component__c();
            solCmp = TestUtility.newSolComp(sol.Id, wo.Id);
            solCompList.add(solCmp);
            
            CSS_Solution_Component__c solCmp2 = new CSS_Solution_Component__c();
            solCmp2 = TestUtility.newSolComp(sol.Id, wo.Id);
            solCompList.add(solCmp2);
            
            insert solCompList;
            
            List<FSL_SRT__c> SRTList = new List<FSL_SRT__c>();
            FSL_SRT__c srtVar = new FSL_SRT__c();
            srtVar = TestUtility.newSrtVar(wo.id, sol.FSL_Service_Job__c);
            SRTList.add(srtVar);
            
            FSL_SRT__c srtVar2 = new FSL_SRT__c();
            srtVar2 = TestUtility.newSrtVar(wo.id, sol.FSL_Service_Job__c);
            SRTList.add(srtVar2);
            
            insert SRTList;
            
            
            List<CSS_JobEventTemporary__c> jobEventList = new List<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je2=new CSS_JobEventTemporary__c();
            CSS_JobEventTemporary__c je3=new CSS_JobEventTemporary__c();
            
            List<CSS_JobEventTemporary__c> Histlstjob2 = new List<CSS_JobEventTemporary__c>();
            je = TestUtility.newJobEvent();   
            jobEventList.add(je);
            Histlstjob2.add(je);
            
            je2 = TestUtility.newJobEvent();    
            jobEventList.add(je2);
            Histlstjob2.add(je2);
            
            je3 = TestUtility.newJobEvent();     
            jobEventList.add(je3);
            Histlstjob2.add(je3);
            insert jobEventList;
            
            List<CSS_Integration_Details__c> IntegrationList = new List<CSS_Integration_Details__c>();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = TestUtility.createIntegrationDetails();
            IntegrationList.add(conDetails);
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
           	conDetails1 = TestUtility.createIntegrationDetails();
            IntegrationList.add(conDetails1);
            Test.stopTest();
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_CL_IntakeVHCompCtrl.strESN = '79704393';
            FSL_CL_IntakeVHCompCtrl.dtCreated = System.now();
            DateTime lastDate = System.now().addDays(-30);
            FSL_CL_IntakeVHCompCtrl.getRecentHistJobs();
            FSL_CL_IntakeVHCompCtrl.getHistJobs();
            FSL_CL_IntakeVHCompCtrl.MultiUserscheck(new List<String>{(String)UserInfo.getName()});
            system.assert(newUser.ProfileId != null);

        }
    }
    // Ended by Anusha NIN-469*/
    
    
}