@isTest
public class FSL_CL_getEPRFlag_Test {
    
    static testMethod void test1() {
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.CSS_DistributorCode__c = '05340';
        acc.CSS_DBCode__c = '05351';
        acc.Name = 'Test Account ';
        insert acc; 
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory(); 
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '05340-05351';
        sT.FSL_Service_Territory_Code__c = '05351';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Type_PSN__c = 'Engines-79704393';
        asst.Type__c = 'Engines';
        insert asst;
        
        WorkOrder wo    = new WorkOrder();
        wo.AccountId    = acc.Id;
        wo.AssetId      = asst.Id;
        wo.ServiceTerritoryId = sT.Id;
        wo.Status       = 'Triage & Diagnosis';
        wo.Category1__c = 'Leak';
        wo.Process_Step__c = 'Intake';
        //wo.Complaint_Type1__c = 'COOLANT LEAK EXTERNAL';        
        wo.Shop_Work_Order__c = 'test';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.createdDate=system.now().addDays(-29);
        // wo.Failure_Date__c = system.now().addDays(-29);
        
        insert wo;
        
        FSL_Account_Code__c accCode = new FSL_Account_Code__c();
        accCode.Account_Code_Description__c = 'test';
        accCode.Name = 'RRP - 13';
        insert accCode;
        
        CSS_Solution_Component__c solCon = new CSS_Solution_Component__c();
        solCon.name = 'test';
        solCon.Component_Id__c = '123';
        solCon.System_Code__c = '68';
        solCon.Component_Code__c = '12';
        solCon.AccountCode__c = '1245';
        solCon.Account_Code__c= accCode.Id;
        solCon.FSL_Service_Job__c = wo.Id;
        solCon.RoadRelay_Warranty__c='No';
        solCon.Fault_Code__c = '123'; 
        solCon.Selected_Component__c = true;
        
        insert solCon;
        
        //
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' '+wo.id;
        insert fcode;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.FSL_Service_Job__c=wo.Id;
        sol.userTimestamp__c=datetime.now();
        insert sol;
        
        CSS_Solutions__c csol1 = new CSS_Solutions__c();
        csol1.Name='T00000691';
        csol1.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol1.FSL_Solution_Position__c='1.1';
        csol1.Diagnostic_Notes__c='Test';
        csol1.Repair_Notes__c='Good';
        csol1.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol1.Repair_Response__c='Repair Successful.';
        csol1.FaultCode__c=fcode.Id;
        csol1.CSS_Nested_Solutions__c=sol.Id;
        csol1.FSL_Service_Job__c=wo.Id;
        insert csol1;
        
        List<FSL_Parts__c> solpart = new List<FSL_Parts__c>();
        solpart.add(new FSL_Parts__c(Name = '432879200', Solution__c = csol1.id, CSS_Solution_Component__c = solCon.id, Service_Order__c=wo.Id));
        insert solpart;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.name= 'OAGOAuth';
        conDetails.End_Point__c= 'https://test.Com/gettoken';
        conDetails.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
        conDetails.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
        conDetails.IsActive__c = true;
        conDetails.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
        
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.name= 'CSS_SBL_GetPartReturns';
        conDetails1.End_Point__c= 'https://test.Com/csswarranty/getpartreturn';
        conDetails1.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
        conDetails1.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
        conDetails1.IsActive__c = true;
        conDetails1.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
        conDetails1.AuthEnv__c='MuleAuthDEV';
        conDetails1.IsActive__c=true;
        conDetails1.Method_Type__c='Get';
        conDetails1.Timeout__c=12000;        
        insert conDetails1; 
        
        test.startTest();
        // Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_CL_getEPRFlag.getEPRFlagTriggerUpdate(solpart);
        FSL_CL_getEPRFlag.getEPRFlagTriggerHelper(solpart);
        FSL_getEPRFlagResWrapper partResJSON = new FSL_getEPRFlagResWrapper();
        string JsonWr ='{"DataArea":[{"LOCATION": "","MESSAGE": "***ENHANCED PARTS RETURN REQUEST***PLEASE TAG THE PART AND PLACE IT IN THE BOX OF THE REPLACEMENT PART.LABELTHE PART WITH A MATERIAL RETURN TAG WHICH INCLUDES ESN, DISTRIBUTOR CODE, CLAIM NUMBER AND WORK ORDER NUMBER. THE PART SHOULD BE RETURNED TO: CUMMINS SSC EUROPE UNIT B DAVENTRY INTERCHANGE, SOPWITH WAY DRAYTON FIELDS INDUSTRIAL ESTATE, DAVENTRY, NORTHHAMPTONSHIRE, NN11, 8PB, UK.CONTACT SSC.EUROPE@CUMMINS.COM WITH QUESTIONS.","ATTENTION": "","RETURNMESSAGE": "","EPRFLAG": "Y","PARTNUMBER": "528408300","COMPANY": ""}],"Header":{"Status": "Success","ReturnCodeDescription": ""}}';
        FSL_getEPRFlagResWrapper.parse(JsonWr);
        test.stopTest();
    }
}