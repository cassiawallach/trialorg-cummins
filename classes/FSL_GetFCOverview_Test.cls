@isTest
public class FSL_GetFCOverview_Test {
    
    @testSetup static void dataSetup() {
        
        CSS_accountLanguage__c acclang = new CSS_accountLanguage__C(); 
        acclang.Name = 'en_US';
        acclang.CSS_userLanguage__c = 'English';
        acclang.CSS_QsolLanguage__c = 'en';
        acclang.CSS_EDSLanguage__c = 'en';
        insert acclang; 
        
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
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory(); 
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        st.IsActive = true;
        sT.Location_Code__c = '05340-05351';
        sT.FSL_Service_Territory_Code__c = '05351';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Type_PSN__c = 'Engines-79704393';
        insert asst; 
        
        WorkOrder wo    = new WorkOrder();
        wo.AccountId    = acc.Id;
        wo.AssetId      = asst.Id;
        wo.ServiceTerritoryId = sT.Id;
        wo.Status       = 'closed';
        wo.Category1__c = 'Leak';
        wo.Process_Step__c = 'Intake';
        //wo.Complaint_Type1__c = 'COOLANT LEAK EXTERNAL';        
        wo.Shop_Work_Order__c = 'test';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.createdDate=system.now().addDays(-29);
        wo.Repair_Location__c = 'Mobile';
        //wo.FaultCodeId__c = '';
        // wo.Failure_Date__c = system.now().addDays(-29);
        insert wo;
        Service_Order_Extension__c extn = new Service_Order_Extension__c();
        extn.Service_Order_Id__c = wo.Id;
        extn.FaultCodeId__c = '145';
        insert extn;
        
        CSS_Fault_Code__c fcObj = new CSS_Fault_Code__c();
        fcObj.Name = extn.Id;
        fcObj.Primary_Fault_Code__c = 6;
        //  fcObj.Job_Order__c = cjo.Id;
        fcObj.isPole__c = true;
        fcObj.Service_Order__c = wo.Id;
        //fcObj.Job_Order__c = cjo.Id;
        fcObj.PoleMessage__c = true;
        fcObj.Sequence__c = 3;
        fcObj.Mod__c = 'test';
        fcObj.Fault_Code_Type__c ='New';
        fcObj.Related_Fault_Code__c = 'abc';       
        fcObj.Number_of_Solutions__c = '60';
        fcObj.CreatedDate = system.now().addDays(-29);
        Insert fcObj;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getToken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails2 = new CSS_Integration_Details__c();
        conDetails2.End_Point__c = 'https//test.com/getFCOverview';
        conDetails2.Passcode__c = 'Admin';
        conDetails2.Username__c = 'Admin';
        conDetails2.Name = 'FSL_QSOL_FCOverview'; 
        insert conDetails2;
    }
    
    @isTest static void testCallout() {
        
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_CL_QSOLIntegrations.getToken('FSL_GetApiToken_QSOL');
        test.stopTest();
    }
    
    @isTest static void testCalloutForFCOverview() {
        
        // Set mock callout class 
        WorkOrder wo = new WorkOrder();
        CSS_Fault_Code__c fc = new CSS_Fault_Code__c();
        wo = [Select id from WorkOrder Limit 1];
        Service_Order_Extension__c extn1 = new Service_Order_Extension__c();
        extn1 = [SELECT id,FaultCodeId__c FROM Service_Order_Extension__c WHERE Service_Order_Id__c =: wo.Id  LIMIT 1];
        fc = [Select id from CSS_Fault_Code__c where Service_Order__c =: wo.Id];
        extn1.FaultCodeId__c = fc.Id;
        update extn1;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_GetFCOverview.getFCOverview(wo.Id);  
        FSL_GetFCOverview.logFSOverviewAuditEvent(wo.Id);
        test.stopTest();
    }
}