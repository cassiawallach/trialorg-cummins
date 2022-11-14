/*
Test class
*/
@isTest
public class CSS_SolutionTrigger_Test {
    public static testMethod void testSolutions() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        
        
        CSS_Job_Order__c job1;
        CSS_Job_Order__c job2 = new CSS_Job_Order__c(); 
        CSS_Job_Order__c job3;
        CSS_Solutions__c solutions;
        CSS_Solutions__c solutions1 = new CSS_Solutions__c();
        CSS_Solutions__c solutions2;
        CSS_Fault_Code__c fc;
        CSS_Fault_Code__c fc1;
        CSS_Fault_Code__c fauC = new CSS_Fault_Code__c();
        System.runAs(newUser) {
            
            
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getQSOLToken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails4 = new CSS_Integration_Details__c();
        conDetails4.End_Point__c = 'https//test.com/getRetrieveOptionList';
        conDetails4.Passcode__c = 'Admin'; 
        conDetails4.Username__c = 'Admin';
        conDetails4.Name = 'FSL_QSOL_RetrieveOptionList'; 
        insert conDetails4;
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        
        Id recTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Options').getRecordTypeId();
        Id DealerecTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();

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
        insert ase;
        
        
        
        
        
        case cs=new case();
        cs.AccountId=acc.id;
        cs.ContactId=con.id;
        cs.AssetId=ase.id;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        cs.General_Symptoms__c='test symptoms';
       // cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;
        
       

        workorder wo=new workorder();
        //wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.SelectedSolution__c='abc';
        wo.Process_Step__c = 'Repair';
        wo.Type__c = 'Dealer';
        wo.RecordTypeId = DealerecTypeId;
       // wo.ServiceTerritoryId=st1.Id;
        insert wo;
            Test.startTest();           
            job1 = new CSS_Job_Order__c(ownerId = newUser.id,Customer_Name__c='varun',service_model__c='Test');
            insert job1;
            fc = new CSS_Fault_Code__c(name='441',Job_Order__c=job1.id, Service_Order__c =wo.Id);
            insert fc;
            CSS_Fault_Code__c fcNew = new CSS_Fault_Code__c(name='145',Job_Order__c=job1.id, Service_Order__c =wo.Id, EVL_Sequence__c = 1);
            insert fcNew;
            solutions = new CSS_Solutions__c(ownerID = newUser.id,Name='K21484443',Service_Job__c=job1.Id,Solution_Title__c='Test',Case_Name__c='K21484443',FaultCode__c=fc.id);
            insert solutions;
            job2 = [select Customer_Name__c from CSS_Job_Order__c where id =:job1.id];
            job2.Customer_Name__c ='SRT';
            solutions1 = [select Name from CSS_Solutions__c where Name =:'K21484443'];
            solutions1.Diagnostic_Response__c ='Not the solution';
            solutions1.Repair_Response__c = 'Repair Successful.';
            solutions1.Out_Of_Order__c = True;
            update solutions1;
            job3 = new CSS_Job_Order__c(ownerId = newUser.id,Customer_Name__c='varun',service_model__c='Test');
            insert job3;
            fc1 = new CSS_Fault_Code__c(name='441',Job_Order__c=job3.id, Service_Order__c =wo.Id, EVL_Sequence__c = 0);
            insert fc1;
            solutions2 = new CSS_Solutions__c(ownerID = newUser.id,Name='K21484443',Service_Job__c=job3.Id,Solution_Title__c='Test',Case_Name__c='K21484443',FaultCode__c=fc1.id,Diagnostic_Response__c ='Not the solution',Repair_Response__c = 'Repair Successful.');
            insert solutions2;
            Test.setMock(HttpCalloutMock.class, new CSS_Diagnosis_SRT_Test());
            Map<ID,String> sol = new Map<ID,String>();
            Map<id,id> jobOrder = new Map<id,id>();
            sol.put(solutions.id,solutions.name);
            jobOrder.put(solutions.id,solutions.Service_Job__c);
            //CSS_SRT.diagnosticSRT(jobOrder,sol,'Test','A',1.1);
            fauC = [select name from CSS_Fault_Code__c  where id =:solutions.FaultCode__c];
            fauC.PoleMessage__c = True;
            update fauC;
            Test.stopTest();
        }
    }
}