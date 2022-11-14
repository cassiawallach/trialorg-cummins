/*
 * Test Class for Apex Controller - FSL_CL_BMSSRTData
 * Author - Piyush Rani
 */ 
@isTest
public class FSL_CL_BMSSRTData_Test {
    @isTest public static void getBMSSRTDataTest() {
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory serTer = new ServiceTerritory();
        serTer.Name = 'ST001 Mobile';
        serTer.OperatingHoursId = oh.Id;
        serTer.IsActive = true;
        serTer.Location_Code__c = '03520-04892';
        serTer.FSL_Service_Territory_Code__c = '04892';
        serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer.Territory__c = 'AUSTRALIA';
        insert serTer;
        
        List<workorder> woInfo = new List<workorder>();
        workorder wo1 = new workorder();
        wo1.Account = acc;
        wo1.Process_Step__c = 'Intake';
        wo1.Repair_Location__c = 'Mobile';
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.ServiceTerritoryid = serTer.id;
        wo1.sub_status__c = 'Troubleshooting Complete';
        wo1.Shop_Work_Order__c = '175831';
        wo1.Make__c = 'INTERNATIONAL';
        wo1.Model__c = 'PROSTAR'; 
        woInfo.add(wo1);
        insert woInfo;
        
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo1.id;
        fcode.extfield__c = cfc.id+' '+wo1.id;
        fcode.Sequence__c = 1;
        fcode.Fault_Code_Type__c = 'APD-P';
        
        insert fcode;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.FSL_Service_Job__c = wo1.Id;
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.userTimestamp__c=datetime.now();
        insert sol;
        
        List<FSL_SRT__c> ListSRT = new List<FSL_SRT__c>();
        FSL_SRT__c objSRT1 = new FSL_SRT__c();
        objSRT1.Name='99-999';//Added by Charan
        objSRT1.CSS_Fault_Code__c = fcode.Id;
        objSRT1.Solution_Number__c = sol.Id;
        objSRT1.Service_Order__c = wo1.Id;
        objSRT1.SRT_Select__c = true;
        objSRT1.SRT_Time__c = 1.0;
        objSRT1.Type__c = 'Diagnosis';
        ListSRT.add(objSRT1);
        
        FSL_SRT__c objSRT2 = new FSL_SRT__c();
        objSRT2.Name = 'Travel'; //Added by Charan 
        objSRT2.CSS_Fault_Code__c = fcode.Id;
        objSRT2.Solution_Number__c = sol.Id;
        objSRT2.Service_Order__c = wo1.Id;
        objSRT2.SRT_Select__c = true;
        objSRT2.SRT_Time__c = 1.0;
        objSRT2.Type__c = 'Diagnosis';
        ListSRT.add(objSRT2);
        FSL_SRT__c objSRT3 = new FSL_SRT__c();
        objSRT3.Name = '99-999-99'; //Added by Charan 
        objSRT3.CSS_Fault_Code__c = fcode.Id;
        objSRT3.Solution_Number__c = sol.Id;
        objSRT3.Service_Order__c = wo1.Id;
        objSRT3.SRT_Select__c = true;
        objSRT3.SRT_Time__c = 1.0;
        objSRT3.Type__c = 'Diagnosis';
        ListSRT.add(objSRT3);
        insert ListSRT;
        
        RestRequest req = new RestRequest(); 
   		RestResponse res = new RestResponse();
        
        FSL_CL_BMSSRTData.getBMSSRTData(woInfo[0].Id);
        FSL_CL_BMSSRTData.handleErrorLog(req, res, 'TestServiceName', 'Success', 'TestServiceVersion', 'TestToolId', 'TestSenderId');
        Test.stopTest();
    }
}