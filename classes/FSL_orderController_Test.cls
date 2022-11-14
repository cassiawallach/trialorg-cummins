/*
* Test Class for Apex Controller - FSL_orderController
* Author - Piyush Rani
*/
/*********************************************************************************
Name:FSL_orderController_Test
===================================================================================
Purpose:                                                            
-------  
Test class for FSL_orderController 
===================================================================================
History                                                            
----------------------------------------------------------------------------------
VERSION                 AUTHOR                              DATE                                   
1.0                     Lochana Rajput                      08/26/2022
***************************************************************************************/
@isTest
public class FSL_orderController_Test {
    
    public static testmethod void orderControllerTestMethod(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.email='priyanka.thotakura@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        ase.Application_Code__c='234';
        ase.Make__c ='testmake'; 
        ase.Model__c ='test model'; 
        ase.Engine_Family_Code__c='10';
        insert ase;
        
        CSS_Make_Model_Access__c cssMakeModelAcc= new CSS_Make_Model_Access__c(Access__c='a', Make__c = 'testmake', Model__c ='test model', EngineFamilyCode__c = '10');
        insert cssMakeModelAcc;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c='03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        insert st1;
        
        case cs=new case();
        
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        cs.Bypass_Validation_Rule__c = true;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
        //Replaced with description filed 
        // cs.General_Symptoms__c='test symptoms';
        cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;
        
        FSL_workorderListTriggerHandle.avoidAfterupdate=true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
        //wo.FaultCodeId__c='123';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId   = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        insert wo;
        
        Test.startTest();
        wo.ServiceTerritoryId=st1.Id;
        update wo;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        insert spnfc;
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        insert pfc;
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' '+wo.id;
        fcode.Sequence__c = 1;
        fcode.Fault_Code_Type__c = 'APD-P';
        //fcode.Count__c = 3;
        //fcode.Status__c = 'Active';
        insert fcode;
        
       // wo.FaultCodeId__c = fcode.id;
        update wo;
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'FSL_TextNotification';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'FSL_TextNotification';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        inte.AuthEnv__c = 'OAGOAuthStg';
        inte.Method_Type__c = 'POST';
        inte.Timeout__c = 2.0;
        insert inte;
        
        CSS_Integration_Details__c cc = [Select Id, Name from CSS_Integration_Details__c];
        system.debug('-----cc'+cc);
        
        List<CSS_Solutions__c> solTesting = new List<CSS_Solutions__c>();
        CSS_Solutions__c sol_Test = new CSS_Solutions__c();
        sol_Test.FSL_Service_Job__c = wo.Id;
        sol_Test.Name='T00000690';
        sol_Test.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol_Test.FSL_Solution_Position__c='1';
        sol_Test.Diagnostic_Notes__c='Test';
        sol_Test.Repair_Notes__c='Good';
        sol_Test.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol_Test.Repair_Response__c='Repair Successful.';
        sol_Test.FaultCode__c=fcode.Id;
        sol_Test.userTimestamp__c=datetime.now();
        solTesting.add(sol_Test);
        
         
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.FSL_Service_Job__c = wo.Id;
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.userTimestamp__c=datetime.now();
        insert sol;
        
        List<CSS_Solutions__c> lstCS = new List<CSS_Solutions__c>();
        CSS_Solutions__c csol = new CSS_Solutions__c();
        csol.Name='T00000691';
        csol.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol.FSL_Solution_Position__c='1.1';
        csol.Diagnostic_Notes__c='Test';
        csol.Repair_Notes__c='Good';
        csol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol.Repair_Response__c='Repair Successful.';
        csol.FaultCode__c=fcode.Id;
        csol.CSS_Nested_Solutions__c=sol.Id;
        csol.FSL_Service_Job__c=wo.Id;
        csol.userTimestamp__c = datetime.now();
        lstCS.add(csol);
        
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
        csol1.userTimestamp__c = datetime.now();
        lstCS.add(csol1);
        
        insert lstCS;
        
        List<FSL_SRT__c> ListSRT = new List<FSL_SRT__c>();
        FSL_SRT__c objSRT1 = new FSL_SRT__c();
        objSRT1.CSS_Fault_Code__c = fcode.Id;
        objSRT1.Solution_Number__c = sol.Id;
        objSRT1.Service_Order__c = wo.Id;
        objSRT1.SRT_Select__c = true;
        objSRT1.SRT_Time__c = 1.0;
        objSRT1.Type__c = 'Diagnosis';
        ListSRT.add(objSRT1);
        
        FSL_SRT__c objSRT2 = new FSL_SRT__c();
        objSRT2.CSS_Fault_Code__c = fcode.Id;
        objSRT2.Solution_Number__c = sol.Id;
        objSRT2.Service_Order__c = wo.Id;
        objSRT2.SRT_Select__c = true;
        objSRT2.SRT_Time__c = 1.0;
        objSRT2.Type__c = 'Diagnosis';
        ListSRT.add(objSRT2);
        insert ListSRT;
        
        Knowledge__kav kw = new Knowledge__kav();
        kw.UrlName = csol1.Name;
        kw.Validations__c = '<strong>Validation</strong> <ul style="margin-left: 40px;"><li>Check ECM Calibration Revision History  </li><li>Use the recommended Cummins electronic service tool or equivalent to find the current ECM code and revision number in the ECM.  </li><li>Compare the ECM code and revision number in the ECM to the calibration revisions listed in the ECM Calibration Revision History Database for applicable changes related to this fault code.  </li><li>Refer to ECM Calibration Revision History Database.  </li><li>Connect all components  </li><li>Connect the recommended Cummins electronic service tool or equivalent.  </li><li>Operate the engine within the &quot;Conditions for Clearing the Fault Code&quot; found in the Overview section of the troubleshooting procedure.  </li><li>Verify that the fault code is no longer active.  </li></ul> <br>';
        kw.Verification__c = '<strong>Conditions</strong> <ul style="margin-left: 40px;"><li>Turn keyswitch OFF.  </li><li>Disconnect the aftertreatment DPF differential pressure sensor from the OEM wiring harness.  </li></ul> <br> <strong>Linked Solutions</strong> <ul style="margin-left: 40px;"><li>Inspect the pins and connectors for damage. Refer to Solution <a href="/articles/Knowledge/S00000877?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00000877</a>  </li><li>Aftertreatment DPF differential pressure sensor open circuit check Refer to Solution <a href="/articles/Knowledge/S00001247?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00001247</a>  </li></ul> <br>';
        kw.Repairs__c = '<strong>Repair</strong> <ul style="margin-left: 40px;"><li>No additional action is required for this solution.  </li></ul> <br>' ;
        kw.Title = 'Aftertreatment DPF differential pressure sensor voltage check';
        insert kw;
        
        FSLTestDataSetupCls.createIntegrationConfigs();
        FSL_orderController  fslWorkOrder = new FSL_orderController();
        FSL_orderController.WrapObject oCon = new FSL_orderController.WrapObject(fcode,solTesting,2.0,2.0);
        FSL_orderController.fetchPriorityFaultCodes(wo.Id,1);
        FSL_orderController.fetchNonPriorityFaultCodes(wo.Id,1);
        FSL_orderController.fetchPOJobOrderFaultCodes(wo.Id,1);
        FSL_orderController.fetchNPOJobOrderFaultCodes(wo.Id,1);
        FSL_orderController.fetchPServiceOrderFaultCodes(wo.Id,1);
        FSL_orderController.fetchNPServOrdFaultCodes(wo.Id,1);
        //FSL_orderController.fetchPriorityDetails(String.valueOf(wo.Id),1);
        FSL_orderController.fetchPriorityDetMap(String.valueOf(wo.Id),1);
        
        FSL_workorderListTriggerHandle.avoidAfterupdate=true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        FSL_orderController.changeRecord(String.valueOf(wo.Id));
        
        FSL_orderController.getknowledge(String.valueOf(csol.Id));
        FSL_orderController.maxSequenceMethod(wo.Id);
        
        Test.stoptest();
    }
    
    public static testmethod void orderControllerTestMethod_Two(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.email='priyanka.thotakura@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        ase.Application_Code__c='234';
        ase.Make__c ='testmake'; 
        ase.Model__c ='test model'; 
        ase.Engine_Family_Code__c='10';
        insert ase;
        
        CSS_Make_Model_Access__c cssMakeModelAcc= new CSS_Make_Model_Access__c(Access__c='a', Make__c = 'testmake', Model__c ='test model', EngineFamilyCode__c = '10');
        insert cssMakeModelAcc;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c='03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        insert st1;
        
        case cs=new case();
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        cs.Bypass_Validation_Rule__c = true;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
        //Replaced with description filed 
        // cs.General_Symptoms__c='test symptoms';
        cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;
        
        FSL_workorderListTriggerHandle.avoidAfterupdate=true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        FSL_workorderListTriggerHandle.avoidBeforeInsert = true;
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
      //  wo.FaultCodeId__c='123';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId   = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        insert wo;
        
        Test.StartTest();
        wo.ServiceTerritoryId=st1.Id;
        //update wo;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        insert spnfc;
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        insert pfc;
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' '+wo.id;
        fcode.Sequence__c = 0;
        fcode.Fault_Code_Type__c = 'APD-P';
        fcode.Count__c = 1;
        fcode.Status__c = 'Active';
        insert fcode;
        
       // wo.FaultCodeId__c = fcode.id;
        update wo;
        
        List<CSS_Solutions__c> solTesting = new List<CSS_Solutions__c>();
        CSS_Solutions__c sol_Test = new CSS_Solutions__c();
        sol_Test.Name='T00000690';
        sol_Test.FSL_Service_Job__c = wo.Id;
        sol_Test.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol_Test.FSL_Solution_Position__c='1';
        sol_Test.Diagnostic_Notes__c='Test';
        sol_Test.Repair_Notes__c='Good';
        sol_Test.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol_Test.Repair_Response__c='Repair Successful.';
        sol_Test.FaultCode__c=fcode.Id;
        sol_Test.userTimestamp__c=datetime.now();
        solTesting.add(sol_Test);
        
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.FSL_Service_Job__c = wo.Id;
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.userTimestamp__c=datetime.now();
        insert sol;
        
        List<CSS_Solutions__c> lstCSIns = new List<CSS_Solutions__c>();
        CSS_Solutions__c csol = new CSS_Solutions__c();
        csol.Name='T00000691';
        csol.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol.FSL_Solution_Position__c='1.1';
        csol.Diagnostic_Notes__c='Test';
        csol.Repair_Notes__c='Good';
        csol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol.Repair_Response__c='Repair Successful.';
        csol.FaultCode__c=fcode.Id;
        csol.CSS_Nested_Solutions__c=sol.Id;
        csol.FSL_Service_Job__c=wo.Id;
        csol.userTimestamp__c = datetime.now();
        lstCSIns.add(csol);
        
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
        csol1.userTimestamp__c = datetime.now();
        lstCSIns.add(csol1);
        
        insert lstCSIns;
        List<FSL_SRT__c> ListSRT = new List<FSL_SRT__c>();
        FSL_SRT__c objSRT1 = new FSL_SRT__c();
        objSRT1.CSS_Fault_Code__c = fcode.Id;
        objSRT1.Solution_Number__c = sol.Id;
        objSRT1.Service_Order__c = wo.Id;
        objSRT1.SRT_Select__c = true;
        objSRT1.SRT_Time__c = 1.0;
        objSRT1.Type__c = 'Diagnosis';
        ListSRT.add(objSRT1);
        
        FSL_SRT__c objSRT2 = new FSL_SRT__c();
        objSRT2.CSS_Fault_Code__c = fcode.Id;
        objSRT2.Solution_Number__c = sol.Id;
        objSRT2.Service_Order__c = wo.Id;
        objSRT2.SRT_Select__c = true;
        objSRT2.SRT_Time__c = 1.0;
        objSRT2.Type__c = 'Diagnosis';
        ListSRT.add(objSRT2);
        
        insert ListSRT;
        
        Knowledge__kav kw = new Knowledge__kav();
        kw.UrlName = csol1.Name;
        kw.Validations__c = '<strong>Validation</strong> <ul style="margin-left: 40px;"><li>Check ECM Calibration Revision History  </li><li>Use the recommended Cummins electronic service tool or equivalent to find the current ECM code and revision number in the ECM.  </li><li>Compare the ECM code and revision number in the ECM to the calibration revisions listed in the ECM Calibration Revision History Database for applicable changes related to this fault code.  </li><li>Refer to ECM Calibration Revision History Database.  </li><li>Connect all components  </li><li>Connect the recommended Cummins electronic service tool or equivalent.  </li><li>Operate the engine within the &quot;Conditions for Clearing the Fault Code&quot; found in the Overview section of the troubleshooting procedure.  </li><li>Verify that the fault code is no longer active.  </li></ul> <br>';
        kw.Verification__c = '<strong>Conditions</strong> <ul style="margin-left: 40px;"><li>Turn keyswitch OFF.  </li><li>Disconnect the aftertreatment DPF differential pressure sensor from the OEM wiring harness.  </li></ul> <br> <strong>Linked Solutions</strong> <ul style="margin-left: 40px;"><li>Inspect the pins and connectors for damage. Refer to Solution <a href="/articles/Knowledge/S00000877?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00000877</a>  </li><li>Aftertreatment DPF differential pressure sensor open circuit check Refer to Solution <a href="/articles/Knowledge/S00001247?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00001247</a>  </li></ul> <br>';
        kw.Repairs__c = '<strong>Repair</strong> <ul style="margin-left: 40px;"><li>No additional action is required for this solution.  </li></ul> <br>' ;
        kw.Title = 'Aftertreatment DPF differential pressure sensor voltage check';
        insert kw;
        
        FSLTestDataSetupCls.createIntegrationConfigs();
        FSL_orderController  fslWorkOrder = new FSL_orderController();
        FSL_orderController.WrapObject oCon = new FSL_orderController.WrapObject(fcode,solTesting,2.0,2.0);
        FSL_orderController.fetchPriorityFaultCodes(wo.Id,1);
        FSL_orderController.fetchNonPriorityFaultCodes(wo.Id,1);
        FSL_orderController.fetchPOJobOrderFaultCodes(wo.Id,1);
        FSL_orderController.fetchNPOJobOrderFaultCodes(wo.Id,1);
        FSL_orderController.fetchPServiceOrderFaultCodes(wo.Id,1);
        FSL_orderController.fetchNPServOrdFaultCodes(wo.Id,1);
        //FSL_orderController.fetchPriorityDetails(String.valueOf(wo.Id),1);
        FSL_orderController.fetchPriorityDetMap(String.valueOf(wo.Id),1);
        //FSL_orderController.changeRecord(String.valueOf(wo.Id));
        FSL_orderController.getknowledge(String.valueOf(csol.Id));
        FSL_orderController.maxSequenceMethod(fcode.Id);
        Test.stopTest();
    }
    
    public static testmethod void orderControllerTestMethod_Three(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.email='priyanka.thotakura@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        ase.Application_Code__c='234';
        ase.Make__c ='testmake'; 
        ase.Model__c ='test model'; 
        ase.Engine_Family_Code__c='10';
        insert ase;
        
        CSS_Make_Model_Access__c cssMakeModelAcc= new CSS_Make_Model_Access__c(Access__c='a', Make__c = 'testmake', Model__c ='test model', EngineFamilyCode__c = '10');
        insert cssMakeModelAcc;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c='03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        insert st1;
        
        case cs=new case();
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        cs.Bypass_Validation_Rule__c = true;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
        //Replaced with description filed 
        // cs.General_Symptoms__c='test symptoms';
        cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;
        
        FSL_workorderListTriggerHandle.avoidAfterupdate=true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
       // wo.FaultCodeId__c='123';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId   = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        insert wo;
        
        Test.startTest();
        wo.ServiceTerritoryId=st1.Id;
        update wo;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        insert spnfc;
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        insert pfc;
        
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' '+wo.id;
        fcode.Sequence__c = 0;
        fcode.Fault_Code_Type__c = 'Testing';
        fcode.Count__c = 1;
        fcode.Status__c = 'Active';
        insert fcode;
        
       // wo.FaultCodeId__c = fcode.id;
        update wo;
        
      //  wo.FaultCodeId__c = fcode.id;
        update wo;
        
        List<CSS_Solutions__c> solTesting = new List<CSS_Solutions__c>();
        CSS_Solutions__c sol_Test = new CSS_Solutions__c();
        sol_Test.Name='T00000690';
        sol_Test.FSL_Service_Job__c = wo.Id;
        sol_Test.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol_Test.FSL_Solution_Position__c='1';
        sol_Test.Diagnostic_Notes__c='Test';
        sol_Test.Repair_Notes__c='Good';
        sol_Test.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol_Test.Repair_Response__c='Repair Successful.';
        sol_Test.FaultCode__c=fcode.Id;
        sol_Test.userTimestamp__c=datetime.now();
        solTesting.add(sol_Test);
        
        // Test.startTest();
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.FSL_Service_Job__c = wo.Id;
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.userTimestamp__c=datetime.now();
        insert sol;
        
        CSS_Solutions__c csol = new CSS_Solutions__c();
        csol.Name='T00000691';
        csol.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol.FSL_Solution_Position__c='1.1';
        csol.Diagnostic_Notes__c='Test';
        csol.Repair_Notes__c='Good';
        csol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol.Repair_Response__c='Repair Successful.';
        csol.FaultCode__c=fcode.Id;
        csol.CSS_Nested_Solutions__c=sol.Id;
        csol.FSL_Service_Job__c=wo.Id;
        csol.userTimestamp__c = datetime.now();
        insert csol;
        
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
        csol1.userTimestamp__c = datetime.now();
        insert csol1;
        
        List<FSL_SRT__c> ListSRT = new List<FSL_SRT__c>();
        FSL_SRT__c objSRT1 = new FSL_SRT__c();
        objSRT1.CSS_Fault_Code__c = fcode.Id;
        objSRT1.Solution_Number__c = sol.Id;
        objSRT1.Service_Order__c = wo.Id;
        objSRT1.SRT_Select__c = true;
        objSRT1.SRT_Time__c = 1.0;
        objSRT1.Type__c = 'Diagnosis';
        ListSRT.add(objSRT1);
        
        FSL_SRT__c objSRT2 = new FSL_SRT__c();
        objSRT2.CSS_Fault_Code__c = fcode.Id;
        objSRT2.Solution_Number__c = sol.Id;
        objSRT2.Service_Order__c = wo.Id;
        objSRT2.SRT_Select__c = true;
        objSRT2.SRT_Time__c = 1.0;
        objSRT2.Type__c = 'Diagnosis';
        ListSRT.add(objSRT2);
        insert ListSRT;
        
        Knowledge__kav kw = new Knowledge__kav();
        kw.UrlName = csol1.Name;
        kw.Validations__c = '<strong>Validation</strong> <ul style="margin-left: 40px;"><li>Check ECM Calibration Revision History  </li><li>Use the recommended Cummins electronic service tool or equivalent to find the current ECM code and revision number in the ECM.  </li><li>Compare the ECM code and revision number in the ECM to the calibration revisions listed in the ECM Calibration Revision History Database for applicable changes related to this fault code.  </li><li>Refer to ECM Calibration Revision History Database.  </li><li>Connect all components  </li><li>Connect the recommended Cummins electronic service tool or equivalent.  </li><li>Operate the engine within the &quot;Conditions for Clearing the Fault Code&quot; found in the Overview section of the troubleshooting procedure.  </li><li>Verify that the fault code is no longer active.  </li></ul> <br>';
        kw.Verification__c = '<strong>Conditions</strong> <ul style="margin-left: 40px;"><li>Turn keyswitch OFF.  </li><li>Disconnect the aftertreatment DPF differential pressure sensor from the OEM wiring harness.  </li></ul> <br> <strong>Linked Solutions</strong> <ul style="margin-left: 40px;"><li>Inspect the pins and connectors for damage. Refer to Solution <a href="/articles/Knowledge/S00000877?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00000877</a>  </li><li>Aftertreatment DPF differential pressure sensor open circuit check Refer to Solution <a href="/articles/Knowledge/S00001247?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00001247</a>  </li></ul> <br>';
        kw.Repairs__c = '<strong>Repair</strong> <ul style="margin-left: 40px;"><li>No additional action is required for this solution.  </li></ul> <br>' ;
        kw.Title = 'Aftertreatment DPF differential pressure sensor voltage check';
        insert kw;
        
        FSLTestDataSetupCls.createIntegrationConfigs();
        FSL_orderController  fslWorkOrder = new FSL_orderController();
        FSL_orderController.WrapObject oCon = new FSL_orderController.WrapObject(fcode,solTesting,2.0,2.0);
        FSL_orderController.fetchPriorityFaultCodes(wo.Id,1);
        //FSL_orderController.fetchNonPriorityFaultCodes(wo.Id,1);
        FSL_orderController.fetchPOJobOrderFaultCodes(wo.Id,1);
        FSL_orderController.fetchNPOJobOrderFaultCodes(wo.Id,1);
        FSL_orderController.fetchPServiceOrderFaultCodes(wo.Id,1);
        FSL_orderController.fetchNPServOrdFaultCodes(wo.Id,1);
        //FSL_orderController.fetchPriorityDetails(String.valueOf(wo.Id),1);
        FSL_orderController.fetchPriorityDetMap(String.valueOf(wo.Id),1);
        //FSL_orderController.changeRecord(String.valueOf(wo.Id));
        FSL_orderController.getknowledge(String.valueOf(csol.Id));
        FSL_orderController.maxSequenceMethod(fcode.Id);
        Test.stopTest();
    }
    
    public static testmethod void orderControllerTestMethod_Four(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.email='priyanka.thotakura@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        ase.Application_Code__c='234';
        ase.Make__c ='testmake'; 
        ase.Model__c ='test model'; 
        ase.Engine_Family_Code__c='10';
        insert ase;
        
        CSS_Make_Model_Access__c cssMakeModelAcc= new CSS_Make_Model_Access__c(Access__c='a', Make__c = 'testmake', Model__c ='test model', EngineFamilyCode__c = '10');
        insert cssMakeModelAcc;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c='03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        insert st1;
        
        case cs=new case();
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        cs.Bypass_Validation_Rule__c = true;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
        //Replaced with description filed 
        // cs.General_Symptoms__c='test symptoms';
        cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;
        
        FSL_workorderListTriggerHandle.avoidAfterupdate=true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
       //wo.FaultCodeId__c='123';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId   = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        insert wo;
        
        Test.startTest();
        wo.ServiceTerritoryId=st1.Id;
        update wo;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        insert spnfc;
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        insert pfc;
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' '+wo.id;
        fcode.Sequence__c = 1;
        fcode.Fault_Code_Type__c = 'Testing';
        fcode.Count__c = 1;
        fcode.Status__c = 'Active';
        insert fcode;
        
      //  wo.FaultCodeId__c = fcode.id;
        update wo;
        
       // wo.FaultCodeId__c = fcode.id;
        update wo;
        List<CSS_Solutions__c> solTesting = new List<CSS_Solutions__c>();
        CSS_Solutions__c sol_Test = new CSS_Solutions__c();
        sol_Test.Name='T00000690';
        sol_Test.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol_Test.FSL_Solution_Position__c='1';
        sol_Test.Diagnostic_Notes__c='Test';
        sol_Test.Repair_Notes__c='Good';
        sol_Test.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol_Test.Repair_Response__c='Repair Successful.';
        sol_Test.FaultCode__c=fcode.Id;
        sol_Test.userTimestamp__c=datetime.now();
        solTesting.add(sol_Test);
        
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.FSL_Service_Job__c = wo.Id;
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.userTimestamp__c=datetime.now();
        insert sol;
        
        CSS_Solutions__c csol = new CSS_Solutions__c();
        csol.Name='T00000691';
        csol.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol.FSL_Solution_Position__c='1.1';
        csol.Diagnostic_Notes__c='Test';
        csol.Repair_Notes__c='Good';
        csol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol.Repair_Response__c='Repair Successful.';
        csol.FaultCode__c=fcode.Id;
        csol.CSS_Nested_Solutions__c=sol.Id;
        csol.FSL_Service_Job__c=wo.Id;
        csol.userTimestamp__c = datetime.now();
        insert csol;
        
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
        csol1.userTimestamp__c = datetime.now();
        insert csol1;
        
        List<FSL_SRT__c> ListSRT = new List<FSL_SRT__c>();
        FSL_SRT__c objSRT1 = new FSL_SRT__c();
        objSRT1.CSS_Fault_Code__c = fcode.Id;
        objSRT1.Solution_Number__c = sol.Id;
        objSRT1.Service_Order__c = wo.Id;
        objSRT1.SRT_Select__c = true;
        objSRT1.SRT_Time__c = 1.0;
        objSRT1.Type__c = 'Diagnosis';
        ListSRT.add(objSRT1);
        
        FSL_SRT__c objSRT2 = new FSL_SRT__c();
        objSRT2.CSS_Fault_Code__c = fcode.Id;
        objSRT2.Solution_Number__c = sol.Id;
        objSRT2.Service_Order__c = wo.Id;
        objSRT2.SRT_Select__c = true;
        objSRT2.SRT_Time__c = 1.0;
        objSRT2.Type__c = 'Diagnosis';
        ListSRT.add(objSRT2);
        insert ListSRT;
        
        Knowledge__kav kw = new Knowledge__kav();
        kw.UrlName = csol1.Name;
        kw.Validations__c = '<strong>Validation</strong> <ul style="margin-left: 40px;"><li>Check ECM Calibration Revision History  </li><li>Use the recommended Cummins electronic service tool or equivalent to find the current ECM code and revision number in the ECM.  </li><li>Compare the ECM code and revision number in the ECM to the calibration revisions listed in the ECM Calibration Revision History Database for applicable changes related to this fault code.  </li><li>Refer to ECM Calibration Revision History Database.  </li><li>Connect all components  </li><li>Connect the recommended Cummins electronic service tool or equivalent.  </li><li>Operate the engine within the &quot;Conditions for Clearing the Fault Code&quot; found in the Overview section of the troubleshooting procedure.  </li><li>Verify that the fault code is no longer active.  </li></ul> <br>';
        kw.Verification__c = '<strong>Conditions</strong> <ul style="margin-left: 40px;"><li>Turn keyswitch OFF.  </li><li>Disconnect the aftertreatment DPF differential pressure sensor from the OEM wiring harness.  </li></ul> <br> <strong>Linked Solutions</strong> <ul style="margin-left: 40px;"><li>Inspect the pins and connectors for damage. Refer to Solution <a href="/articles/Knowledge/S00000877?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00000877</a>  </li><li>Aftertreatment DPF differential pressure sensor open circuit check Refer to Solution <a href="/articles/Knowledge/S00001247?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00001247</a>  </li></ul> <br>';
        kw.Repairs__c = '<strong>Repair</strong> <ul style="margin-left: 40px;"><li>No additional action is required for this solution.  </li></ul> <br>' ;
        kw.Title = 'Aftertreatment DPF differential pressure sensor voltage check';
        insert kw;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u2 = [SELECT Id from User WHERE ProfileId =:p.Id AND IsActive=:TRUE LIMIT 1];
        
        System.runAs(u2){
            FSLTestDataSetupCls.createIntegrationConfigs();
            FSL_orderController  fslWorkOrder = new FSL_orderController();
            FSL_orderController.WrapObject oCon = new FSL_orderController.WrapObject(fcode,solTesting,2.0,2.0);
            FSL_orderController.fetchPriorityFaultCodes(wo.Id,1);
            //FSL_orderController.fetchNonPriorityFaultCodes(wo.Id,1);
            FSL_orderController.fetchPOJobOrderFaultCodes(wo.Id,1);
            FSL_orderController.fetchNPOJobOrderFaultCodes(wo.Id,0);
            FSL_orderController.fetchPServiceOrderFaultCodes(wo.Id,1);
            //FSL_orderController.fetchNPServOrdFaultCodes(wo.Id,1);
            //FSL_orderController.fetchPriorityDetails(String.valueOf(wo.Id),1);
            FSL_orderController.fetchPriorityDetMap(String.valueOf(wo.Id),1);
            //FSL_orderController.changeRecord(String.valueOf(wo.Id));
            FSL_orderController.getknowledge(String.valueOf(csol.Id));
            FSL_orderController.maxSequenceMethod(fcode.Id);
        }
        
        Test.stopTest();
    }
    
    public static testmethod void orderControllerTestMethod_Five(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.email='priyanka.thotakura@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        ase.Application_Code__c='234';
        ase.Make__c ='testmake'; 
        ase.Model__c ='test model'; 
        ase.Engine_Family_Code__c='10';
        insert ase;
        
        CSS_Make_Model_Access__c cssMakeModelAcc= new CSS_Make_Model_Access__c(Access__c='a', Make__c = 'testmake', Model__c ='test model', EngineFamilyCode__c = '10');
        insert cssMakeModelAcc;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c='03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        insert st1;
        
        case cs=new case();
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
        //Replaced with description filed 
        // cs.General_Symptoms__c='test symptoms';
        cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;
        
        FSL_workorderListTriggerHandle.avoidAfterupdate=true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
       // wo.FaultCodeId__c='123';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId   = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        insert wo;
        
        Test.startTest();
        wo.ServiceTerritoryId=st1.Id;
        update wo;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        insert spnfc;
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        insert pfc;
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' '+wo.id;
        fcode.Sequence__c = 1;
        fcode.Fault_Code_Type__c = 'APD-P';
        fcode.Count__c = 1;
        fcode.Status__c = 'Active';
        insert fcode;
        
       // wo.FaultCodeId__c = fcode.id;
        update wo;
        
        
        List<CSS_Solutions__c> solTesting = new List<CSS_Solutions__c>();
        CSS_Solutions__c sol_Test = new CSS_Solutions__c();
        sol_Test.Name='T00000690';
        sol_Test.FSL_Service_Job__c = wo.Id;
        sol_Test.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol_Test.FSL_Solution_Position__c='1';
        sol_Test.Diagnostic_Notes__c='Test';
        sol_Test.Repair_Notes__c='Good';
        sol_Test.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol_Test.Repair_Response__c='Repair Successful.';
        sol_Test.FaultCode__c=fcode.Id;
        sol_Test.userTimestamp__c=datetime.now();
        solTesting.add(sol_Test);
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.FSL_Service_Job__c = wo.Id;
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.userTimestamp__c=datetime.now();
        insert sol;
        
        // Test.startTest();
        CSS_Solutions__c csol = new CSS_Solutions__c();
        csol.Name='T00000691';
        csol.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol.FSL_Solution_Position__c='1.1';
        csol.Diagnostic_Notes__c='Test';
        csol.Repair_Notes__c='Good';
        csol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol.Repair_Response__c='Repair Successful.';
        csol.FaultCode__c=fcode.Id;
        csol.CSS_Nested_Solutions__c=sol.Id;
        csol.FSL_Service_Job__c=wo.Id;
        csol.userTimestamp__c = datetime.now();
        insert csol;
        
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
        csol1.userTimestamp__c = datetime.now();
        insert csol1;
        
        List<FSL_SRT__c> ListSRT = new List<FSL_SRT__c>();
        FSL_SRT__c objSRT1 = new FSL_SRT__c();
        objSRT1.CSS_Fault_Code__c = fcode.Id;
        objSRT1.Solution_Number__c = sol.Id;
        objSRT1.Service_Order__c = wo.Id;
        objSRT1.SRT_Select__c = true;
        objSRT1.SRT_Time__c = 1.0;
        objSRT1.Type__c = 'Diagnosis';
        ListSRT.add(objSRT1);
        
        FSL_SRT__c objSRT2 = new FSL_SRT__c();
        objSRT2.CSS_Fault_Code__c = fcode.Id;
        objSRT2.Solution_Number__c = sol.Id;
        objSRT2.Service_Order__c = wo.Id;
        objSRT2.SRT_Select__c = true;
        objSRT2.SRT_Time__c = 1.0;
        objSRT2.Type__c = 'Diagnosis';
        ListSRT.add(objSRT2);
        insert ListSRT;
        
        Knowledge__kav kw = new Knowledge__kav();
        kw.UrlName = csol1.Name;
        kw.Validations__c = '<strong>Validation</strong> <ul style="margin-left: 40px;"><li>Check ECM Calibration Revision History  </li><li>Use the recommended Cummins electronic service tool or equivalent to find the current ECM code and revision number in the ECM.  </li><li>Compare the ECM code and revision number in the ECM to the calibration revisions listed in the ECM Calibration Revision History Database for applicable changes related to this fault code.  </li><li>Refer to ECM Calibration Revision History Database.  </li><li>Connect all components  </li><li>Connect the recommended Cummins electronic service tool or equivalent.  </li><li>Operate the engine within the &quot;Conditions for Clearing the Fault Code&quot; found in the Overview section of the troubleshooting procedure.  </li><li>Verify that the fault code is no longer active.  </li></ul> <br>';
        kw.Verification__c = '<strong>Conditions</strong> <ul style="margin-left: 40px;"><li>Turn keyswitch OFF.  </li><li>Disconnect the aftertreatment DPF differential pressure sensor from the OEM wiring harness.  </li></ul> <br> <strong>Linked Solutions</strong> <ul style="margin-left: 40px;"><li>Inspect the pins and connectors for damage. Refer to Solution <a href="/articles/Knowledge/S00000877?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00000877</a>  </li><li>Aftertreatment DPF differential pressure sensor open circuit check Refer to Solution <a href="/articles/Knowledge/S00001247?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00001247</a>  </li></ul> <br>';
        kw.Repairs__c = '<strong>Repair</strong> <ul style="margin-left: 40px;"><li>No additional action is required for this solution.  </li></ul> <br>' ;
        kw.Title = 'Aftertreatment DPF differential pressure sensor voltage check';
        insert kw;
        
        FSLTestDataSetupCls.createIntegrationConfigs();
        FSL_orderController  fslWorkOrder = new FSL_orderController();
        FSL_orderController.WrapObject oCon = new FSL_orderController.WrapObject(fcode,solTesting,2.0,2.0);
        FSL_orderController.fetchPriorityFaultCodes(fcode.Id,1);
        FSL_orderController.fetchNonPriorityFaultCodes(fcode.Id,1);
        FSL_orderController.fetchPOJobOrderFaultCodes(wo.Id,0);
        FSL_orderController.fetchNPOJobOrderFaultCodes(wo.Id,1);
        //FSL_orderController.fetchPServiceOrderFaultCodes(wo.Id,1);
        FSL_orderController.fetchNPServOrdFaultCodes(wo.Id,1);
        //FSL_orderController.fetchPriorityDetails(String.valueOf(wo.Id),1);
        FSL_orderController.fetchPriorityDetMap(String.valueOf(wo.Id),1);
        FSL_orderController.changeRecord(String.valueOf(wo.Id));
        FSL_orderController.getknowledge(String.valueOf(csol.Id));
        FSL_orderController.maxSequenceMethod(fcode.Id);
        Test.stopTest();
    }
    
    public static testmethod void orderControllerTestMethod_Six(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.email='priyanka.thotakura@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        ase.Application_Code__c='234';
        ase.Make__c ='testmake'; 
        ase.Model__c ='test model'; 
        ase.Engine_Family_Code__c='10';
        insert ase;
        
        CSS_Make_Model_Access__c cssMakeModelAcc= new CSS_Make_Model_Access__c(Access__c='a', Make__c = 'testmake', Model__c ='test model', EngineFamilyCode__c = '10');
        insert cssMakeModelAcc;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        List<ServiceTerritory> stList = new List<ServiceTerritory>();
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST 12 Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        stList.add(st);
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c='03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        stList.add(st1);
        insert stlist;
        case cs=new case();
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        cs.Bypass_Validation_Rule__c = true;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
        //Replaced with description filed 
        // cs.General_Symptoms__c='test symptoms';
        cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;
        
        FSL_workorderListTriggerHandle.avoidAfterupdate=true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        FSL_workorderListTriggerHandle.avoidBeforeInsert = true;
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
       // wo.FaultCodeId__c='123';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId   = recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        //insert wo;
        
        
        wo.ServiceTerritoryId=st1.Id;
        insert wo;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        insert spnfc;
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        insert pfc;
        
        FSL_workorderListTriggerHandle.avoidAfterupdate=true;
        FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        FSL_workorderListTriggerHandle.avoidBeforeInsert = true;
        WorkOrder JO = NEW WorkOrder();
        // JO.Unit_Number__c = '12345';
        // JO.Failure_Point__c = 1.5;
        // JO.Failure_Point_Measure__c = 'qw';       
        JO.Customer_Name__c = 'CumminsTnD';
        // JO.Status__c = 'Repair Complete';
        JO.ESN__c = 'test1234';
        JO.DSID_WorkGroup__c = '';
        // JO.DSID_Creation_Timestamp__c = system.now();
        // JO.DSID_Status__c = 'open';
        JO.ESN_Locked__c = true;
        JO.ESN_Insite__c = '79464646';
        JO.Application__c = '130 - AUTOMOTIVE';
        // JO.Failure_Point__c = 1234;
        //JO.Failure_Point_Measure__c = 'test1234';
        JO.Make__c = 'BMC';
        JO.Equipment_ID__c = 'equip';
        JO.Model__c = 'MILITARY';
        JO.DSID__c = '';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        // Jo.Assigned_To__c = UserInfo.getUserId();
        // Jo.AccessCode__c ='A';
        
        JO.ServiceTerritoryId = FSL_TestDataUtility.createServiceTerritory().Id;
        // insert(JO);
        
        Test.startTest();
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Service_Order__c = wo.id;
        fcode.extfield__c = cfc.id+' '+wo.id;
        fcode.Sequence__c = 1;
        fcode.Fault_Code_Type__c = 'BLANK';
        fcode.Count__c = 1;
        fcode.Status__c = 'Active';
        // fcode.Job_Order__c = JO.Id ;
        insert fcode;
        
       // wo.FaultCodeId__c = fcode.id;
        update wo;
        
        List<CSS_Solutions__c> solTesting = new List<CSS_Solutions__c>();
        List<CSS_Solutions__c> solTestingIns = new List<CSS_Solutions__c>();
        CSS_Solutions__c sol_Test = new CSS_Solutions__c();
        sol_Test.Name='T00000690';
        sol_Test.FSL_Service_Job__c = wo.Id;
        sol_Test.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol_Test.FSL_Solution_Position__c='1';
        sol_Test.Diagnostic_Notes__c='Test';
        sol_Test.Repair_Notes__c='Good';
        sol_Test.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol_Test.Repair_Response__c='Repair Successful.';
        sol_Test.FaultCode__c=fcode.Id;
        sol_Test.userTimestamp__c=datetime.now();
        solTesting.add(sol_Test);
        
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
        
        CSS_Solutions__c csol = new CSS_Solutions__c();
        csol.Name='T00000691';
        csol.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol.FSL_Solution_Position__c='1.1';
        csol.Diagnostic_Notes__c='Test';
        csol.Repair_Notes__c='Good';
        csol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol.Repair_Response__c='Repair Successful.';
        csol.FaultCode__c=fcode.Id;
        csol.CSS_Nested_Solutions__c=sol.Id;
        csol.FSL_Service_Job__c=wo.Id;
        csol.userTimestamp__c = datetime.now();
        solTestingIns.add(csol);
        
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
        csol1.userTimestamp__c = datetime.now();
        solTestingIns.add(csol1);
        
        insert solTestingIns;
        
        List<FSL_SRT__c> ListSRT = new List<FSL_SRT__c>();
        FSL_SRT__c objSRT1 = new FSL_SRT__c();
        objSRT1.CSS_Fault_Code__c = fcode.Id;
        objSRT1.Solution_Number__c = sol.Id;
        objSRT1.Service_Order__c = wo.Id;
        objSRT1.SRT_Select__c = true;
        objSRT1.SRT_Time__c = 1.0;
        objSRT1.Type__c = 'Diagnosis';
        ListSRT.add(objSRT1);
        
        FSL_SRT__c objSRT2 = new FSL_SRT__c();
        objSRT2.CSS_Fault_Code__c = fcode.Id;
        objSRT2.Solution_Number__c = sol.Id;
        objSRT2.Service_Order__c = wo.Id;
        objSRT2.SRT_Select__c = true;
        objSRT2.SRT_Time__c = 1.0;
        objSRT2.Type__c = 'Diagnosis';
        ListSRT.add(objSRT2);
        insert ListSRT;
        
        Knowledge__kav kw = new Knowledge__kav();
        kw.UrlName = csol1.Name;
        kw.Language='en_US';
        kw.Validations__c = '<strong>Validation</strong> <ul style="margin-left: 40px;"><li>Check ECM Calibration Revision History  </li><li>Use the recommended Cummins electronic service tool or equivalent to find the current ECM code and revision number in the ECM.  </li><li>Compare the ECM code and revision number in the ECM to the calibration revisions listed in the ECM Calibration Revision History Database for applicable changes related to this fault code.  </li><li>Refer to ECM Calibration Revision History Database.  </li><li>Connect all components  </li><li>Connect the recommended Cummins electronic service tool or equivalent.  </li><li>Operate the engine within the &quot;Conditions for Clearing the Fault Code&quot; found in the Overview section of the troubleshooting procedure.  </li><li>Verify that the fault code is no longer active.  </li></ul> <br>';
        kw.Verification__c = '<strong>Conditions</strong> <ul style="margin-left: 40px;"><li>Turn keyswitch OFF.  </li><li>Disconnect the aftertreatment DPF differential pressure sensor from the OEM wiring harness.  </li></ul> <br> <strong>Linked Solutions</strong> <ul style="margin-left: 40px;"><li>Inspect the pins and connectors for damage. Refer to Solution <a href="/articles/Knowledge/S00000877?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00000877</a>  </li><li>Aftertreatment DPF differential pressure sensor open circuit check Refer to Solution <a href="/articles/Knowledge/S00001247?q=Select+Id%2C+Validations__c%2C+Verification__c%2C+Repairs__c+from+Knowledge__kav+limit+100&amp;_dc=1570163205048" target="_blank">S00001247</a>  </li></ul> <br>';
        kw.Repairs__c = '<strong>Repair</strong> <ul style="margin-left: 40px;"><li>No additional action is required for this solution.  </li></ul> <br>' ;
        kw.Title = 'Aftertreatment DPF differential pressure sensor voltage check';
        insert kw;
        
        FSLTestDataSetupCls.createIntegrationConfigs();
        FSL_orderController fslWorkOrder = new FSL_orderController();
        FSL_orderController.WrapObject oCon = new FSL_orderController.WrapObject(fcode,solTesting,2.0,2.0);
        FSL_orderController.fetchPOJobOrderFaultCodes(JO.Id,1);
        FSL_orderController.fetchPServiceOrderFaultCodes(wo.Id,1);
        Test.stopTest();
    }
    
    //Start Road-468 - Rajender added on 07/25/2022
    public static testmethod void checkingforFTRFlag() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardusnew@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingnew', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardunew@testorg.com'
                          , FederationIdentifier ='zxABCNew',
                          Country='United States',Street='14 ABC',City='Columbus',State='Indiana',PostalCode='74201');
        insert u;
        
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy_Guidanz';
        acc.Email_Notification_Frequency__c='Real-Time';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861New';
        ase.AccountId=acc.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644834';
        ase.Engine_Family_Code__c = '10';
        insert ase;
        
       	WorkType wt=new WorkType();
        wt.Name='Test work type';
        wt.EstimatedDuration=60.00;
        insert wt;
                
        ServiceResource sr=new ServiceResource();
        sr.Name='service resource';
        sr.IsActive=true;
        sr.RelatedRecordId=u.id;
        sr.ResourceType='T';
        sr.Is_a_Tech__c=true;
        insert sr;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        insert oh;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = '01234-01234';
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234-01234';
        objServiceTerritory.OperatingHoursId = oh.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory; 
        
        ServiceTerritoryMember stm=new ServiceTerritoryMember();
        stm.ServiceResourceId=sr.id;
        stm.ServiceTerritoryId=objServiceTerritory.id;
        stm.TerritoryType='P';
        stm.EffectiveStartDate=datetime.now();
        stm.Street = '1460 N National Rd';
        stm.City = 'Columbus';
        stm.State = 'Indiana';
        stm.Country = 'United States';
        stm.PostalCode = '47201';
        insert stm;
        
        FSL_SubType__c subt = new FSL_SubType__c();
        subt.Name = 'IS - SHOP';
        insert subt;
       
        workorder wo =new workorder();
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Process_Step__c = 'Intake';
        wo.Available_for_Service__c=datetime.now()+3;
        wo.WorkTypeId= wt.Id;
        wo.Shop_Work_Order__c='00001234';
        wo.AssignedResource__c ='Teswtst';
        wo.ServiceTerritoryId = objServiceTerritory.id;
        wo.Process_Step__c ='Schedule';
        wo.RPV_Notification_Flag__c='RNFLAG';
        wo.General_Symptoms__c = 'Testing';
        wo.FSL_Sub_Type__c = subt.Id;
        insert wo;
        
        Test.startTest();
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = wo.Id;
        sa.Status = 'Scheduled';
        sa.EarliestStartTime = datetime.now().addDays(2);
        sa.DueDate = System.now().addDays(30);
        sa.SchedStartTime=datetime.now().addDays(3);
        sa.SchedEndTime = datetime.now().addDays(4);
        sa.Service_Order__c= wo.id;
        sa.Formatted_Scheduled_Start__c='FSS';
        sa.Assigned_ServiceResource__c = sr.Id;
        sa.Is_a_Tech_Appointment__c=true;
        insert sa;
        
        sa.Status = 'Dispatched';
        update sa;
        
        Service_Order_Extension__c soe = new Service_Order_Extension__c();
        soe = [SELECT Id, FSL_ABRFlag__c FROM Service_Order_Extension__c WHERE Service_Order_Id__c =: wo.Id];
        soe.FSL_ABRFlag__c = true;
        update soe;
        
        Boolean WOStatus = FSL_orderController.getWOStatus(wo.Id);
        system.assertEquals(true, WOStatus);
        Boolean FTRflag = FSL_orderController.fetchFTRFlag(wo.Id);
        system.assertEquals(true, FTRflag);
        FSL_orderController.updateStatustoJobPlan(wo.Id);
        FSL_orderController.updateStatustoRepair(wo.Id);
        Test.stopTest();
    }
    //End Road-468 - Rajender added on 07/25/2022

    //STARTS: 1.0 SG-114 - Added by Lochana on 08/26/2022
    @isTest
    public static void test_fetchFTRDetails() {
        FSL_Switch__c FSlSwitch =FSL_TestDataUtility.createFSLSwitchRecord('Enable_FTR_Switch', true);
        insert FSlSwitch;

        OperatingHours testOh = TestUtility.createOperatingHours('testName');

        ServiceTerritory testTerritory = TestUtility.createServiceTerritory('testName', true, testOh.Id);

        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = FSL_TestDataUtility.createAccount();
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con = FSL_TestDataUtility.createContact(conRecId, acc.Id);
        insert con;
        
        Asset  ast = FSL_TestDataUtility.createAsset();
        
        Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EVL_Guidanz_Dealer_Evolution').getRecordTypeId();
        List<Case> lstCases = FSL_TestDataUtility.createCases(servRecId,acc.Id, con.Id,ast.Id,testTerritory.Id,1);
        lstCases[0].FSL_ABRFlag__c= true;
        insert lstCases;
        Id DealerRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        List<workorder> lstWO = FSL_TestDataUtility.createWO(lstCases, acc.Id);
        lstWO[0].RecordTypeId = DealerRTID;
        lstWO[0].EVL_Stage__c = 'Triage & Diagnosis';
        insert lstWO;
        Workorder wo1= lstWO[0];
        Test.startTest();
        FSL_orderController.WrapperClass obj = FSL_orderController.fetchFTRDetails(wo1.Id);
        Test.stopTest();
        System.assertEquals(true, obj.isFTR);
        System.assertEquals('Triage & Diagnosis', obj.dealerStagestr);
        
    }

    @isTest
    public static void test_updateWOStatus() {
        OperatingHours testOh = TestUtility.createOperatingHours('testName');

        ServiceTerritory testTerritory = TestUtility.createServiceTerritory('testName', true, testOh.Id);

        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = FSL_TestDataUtility.createAccount();
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con = FSL_TestDataUtility.createContact(conRecId, acc.Id);
        insert con;
        
        Asset  ast = FSL_TestDataUtility.createAsset();
        
        Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EVL_Guidanz_Dealer_Evolution').getRecordTypeId();
        List<Case> lstCases = FSL_TestDataUtility.createCases(servRecId,acc.Id, con.Id,ast.Id,testTerritory.Id,1);
        lstCases[0].FSL_ABRFlag__c= true;
        insert lstCases;
        Id DealerRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        List<workorder> lstWO = FSL_TestDataUtility.createWO(lstCases, acc.Id);
        lstWO[0].RecordTypeId = DealerRTID;
        lstWO[0].EVL_Stage__c = 'Triage & Diagnosis';
        insert lstWO;
        Workorder wo1= lstWO[0];
        Test.startTest();
        FSL_orderController.updateWOStatus(wo1.Id, 'Repair');
        wo1 = [SELECT Id, Status, EVL_Stage__c from WorkOrder where Id=: wo1.Id];
        Test.stopTest();
        System.assertEquals('Repair', wo1.Status);
        System.assertEquals('Repair', wo1.EVL_Stage__c);
        
    }
    //ENDS: 1.0 SG-114 - Added by Lochana on 08/26/2022

}