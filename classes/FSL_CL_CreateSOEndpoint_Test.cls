@isTest
public class FSL_CL_CreateSOEndpoint_Test {
    
    
    @isTest  
    static void testSORequest() {
        List<User> listOfUser = [SELECT Id, ERP__C FROM User WHERE isActive = true AND Profile.Name = 'CSS Integration'];
        //String myJSON =  '{"Header":{"Status": " ","Sender":{"ServiceName": "GetJobContactInfo","SenderID": "Movex"},"Target": "CSS","Location": " "},"DataArea": [{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "40","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"ADD" }]}';
        //String myJSON = '{"Header":{"Status": " ","Sender":{"ServiceName": "GetJobContactInfo","SenderID": "BMS"},"Target": "CSS","Location": " "},"DataArea": [{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "4","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"ADD" },{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "40","ContactName": "TRAVIS Trol""EmailNotification":"Y","TextNotification":"Y","LanguagePreference":"EN","NightlyCommunication":"N","MobilePhoneNumber":"7890123458","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"Update" },{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "46","ContactName": "TRAVIS","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00",,"EventFlag":"Add" }]}';
        String myJSON = '{"Header":{"Sender":{"ServiceName":"PMWO","SenderID":"BMS"},"Target":"CSS","LocationCode":"02850-02651"},"DataArea":[{"ERPWorkOrder":"49440","CustomerCode":"102686","PaymentType":"","Prepaid":"PM Prepay","SiteId":"2","SiteLocation":"In Shop","LaborMultiplier":"","SiteContactId":"3","SupervisorFirstName":"","SupervisorLastName":"","ERPContractNumber":"","Type":"External","PSN":"78","Complaint":"","Cause":"","Correction":"","ScheduledDate":"","PromisedDate":"","TransactionType":"PM","ServicePMType":"","SubType":"TestSubType","StandardService":"","NumberOfTechnicians":"2","PreferredTechnician":"","StatusNotes":"","Parts":[{"PartLineNumber":"898493","PartLineType":"PM","PartNumber":"32798404","ProductCode":"","PartDescription":"Test Part1 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"2"},{"PartLineNumber":"898494","PartLineType":"PM","PartNumber":"32798405","ProductCode":"","PartDescription":"Test Part2 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"2"},{"PartLineNumber":"898495","PartLineType":"PM","PartNumber":"32798406","ProductCode":"","PartDescription":"Test Part3 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"2"}],"EPRFlag":"","WorkOrderNotes":"Internal Comments","TotalDuration":"3","SRTs":[{"SRTGroup":"Group1","SRTProcedure":"Procedure1","PartNumber":"32798404","SRTDescription":"SRT1 Description","SRTTime":"0.6","SRTQuantity":"2"},{"SRTGroup":"Group2","SRTProcedure":"Procedure2","PartNumber":"32798404","SRTDescription":"SRT2 Description","SRTTime":"0.6","SRTQuantity":"2"},{"SRTGroup":"Group3","SRTProcedure":"Procedure3","PartNumber":"32798404","SRTDescription":"SRT3 Description","SRTTime":"0.6","SRTQuantity":"2"}],"InvoiceDate":"","TaskGroup":""},{"ERPWorkOrder":"494401","CustomerCode":"102686","PaymentType":"","Prepaid":"PM Prepay","SiteId":"2","SiteLocation":"In Shop","LaborMultiplier":"","SiteContactId":"3","SupervisorFirstName":"","SupervisorLastName":"","ERPContractNumber":"","Type":"External","PSN":"78","Complaint":"","Cause":"","Correction":"","ScheduledDate":"","PromisedDate":"","TransactionType":"PM","ServicePMType":"","SubType":"TestSubType","StandardService":"","NumberOfTechnicians":"2","PreferredTechnician":"","StatusNotes":"","Parts":[{"PartLineNumber":"898493","PartLineType":"PM","PartNumber":"32798404","ProductCode":"","PartDescription":"Test Part1 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"2"},{"PartLineNumber":"898494","PartLineType":"PM","PartNumber":"32798405","ProductCode":"","PartDescription":"Test Part2 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"2"},{"PartLineNumber":"898495","PartLineType":"PM","PartNumber":"32798406","ProductCode":"","PartDescription":"Test Part3 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"2"}],"EPRFlag":"","WorkOrderNotes":"Internal Comments","TotalDuration":"3","SRTs":[{"SRTGroup":"Group1","SRTProcedure":"Procedure1","PartNumber":"32798404","SRTDescription":"SRT1 Description","SRTTime":"0.6","SRTQuantity":"2"},{"SRTGroup":"Group2","SRTProcedure":"Procedure2","PartNumber":"32798404","SRTDescription":"SRT2 Description","SRTTime":"0.6","SRTQuantity":"2"},{"SRTGroup":"Group3","SRTProcedure":"Procedure3","PartNumber":"32798404","SRTDescription":"SRT3 Description","SRTTime":"0.6","SRTQuantity":"2"}],"InvoiceDate":"","TaskGroup":""}]}';
        //Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
        //Test User
        
        FSL_CL_SOWrapper objWrap = new FSL_CL_SOWrapper();
        FSL_CL_SOWrapper.DataArea objDataarea = new FSL_CL_SOWrapper.DataArea();
        objDataarea.ERPWorkOrder = '49440';
        
        WorkType wt = new WorkType();
        wt.name = 'PM';
        wt.EstimatedDuration = 1;
        insert wt;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.FSL_ERP_Customer_Code__c = '102686';
        acc.Name = 'Test Acc';
        acc.Cmi_account_status__c = 'Active';
        acc.BillingStreet = '1466 N, National Rd, testing';
        acc.BillingCity = 'Columbus';
        acc.BillingState = 'Indiana';
        acc.BillingCountry= 'United States';
        acc.BillingPostalCode = '47201';
        acc.Type = 'Customer';
        //added by Harsha
        acc.FSL_Source_ERP__c = 'BMS';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Travis';
        con.LastName = 'Grigg';
        con.AccountId = acc.Id;
        con.FSL_Contact_Id__c = '10';
        con.Phone = '7879883045';
        con.Email = 'test2@cummins.com';
        con.IAM_Contact_Status__c = 'Inactive';
        //con.Mobile_Phone__c='1234567890'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone ='1234567890';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        // con.IAM_Contact_source__c = 'BMS';
        insert con;
        
        /*
        IAM_CDH_Cross_references__c objSite1 = new IAM_CDH_Cross_references__c();
        objSite1.Name = 'TestNew';
        objSite1.IAM_Account__c = acc.Id;
        objSite1.FSL_MoveX_Contact_Id__c = '10';
        objSite1.FSL_MoveX_Site_Id__c = '1';
        objSite1.FSL_City__c = 'Brisbane';
        //siteList.add(objSite1);
        insert objSite1;
        */
        Asset asset1 = new Asset();
        system.runas(listOfUser.get(0)) {
            Schema.Location loc = new Schema.Location();
            loc.Name = 'TestNew';
            loc.FSL_Account__c = acc.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
            
            Schema.Address addr = new Schema.Address();
            addr.parentId = loc.id;
            addr.Account__c = acc.Id;
            addr.Street = '1466 N, National Rd, testing';
            addr.FSL_Site_Name__c = 'TestNew';
            addr.FSL_Site_ID__c = '1';
            addr.City = 'Brisbane';
            insert addr;
            
            
            asset1.Name = '342819';
            asset1.Type_PSN__c = 'External-78';
            asset1.Type__c = 'Engines';
            asset1.AccountId = acc.Id;
            asset1.FSL_Site__c = addr.Id;
            //asset1.Site__C = objSite.Id;
            insert asset1;
        }
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory In Shop OR Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '02850-02651-FPG';
        objServiceTerritory.FSL_Service_Territory_Code__c = '1234-1234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        Test.startTest();
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder.AccountId = acc.Id;
        objWorkOrder.WorkTypeId = workType.Id;
        objWorkOrder.AssetId = asset1.Id;
        objWorkOrder.Shop_Work_Order__c='49440';
        //objWorkOrder.Type__c = 'Internal';
        insert objWorkOrder;
        Test.stoptest();
        FSL_SubType__c st = new FSL_SubType__c();
        st.Name ='TestsubType';
        insert st;  
        // insert st;  
        
        RestRequest request = new RestRequest();
        request.requestUri ='/CreatePMWorkOrder/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        RestContext.response = new RestResponse();
        FSL_CL_CreateSOEndpoint.postPMWorkOrder();
        System.assertEquals(false, [SELECT Id FROM CSS_Integration_Error__c WHERE  Service_Name__c = 'FSL_CL_CreateSOEndpoint'].isEmpty(), 'Error should be there.');
    }
    
    @isTest  
    static void testSORequestNegative() {
        List<User> listOfUser = [SELECT Id, ERP__C FROM User WHERE isActive = true AND Profile.Name = 'CSS Integration'];
        //String myJSON =  '{"Header":{"Status": " ","Sender":{"ServiceName": "GetJobContactInfo","SenderID": "Movex"},"Target": "CSS","Location": " "},"DataArea": [{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "40","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"ADD" }]}';
        //String myJSON = '{"Header":{"Status": " ","Sender":{"ServiceName": "GetJobContactInfo","SenderID": "BMS"},"Target": "CSS","Location": " "},"DataArea": [{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "4","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"ADD" },{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "40","ContactName": "TRAVIS Trol""EmailNotification":"Y","TextNotification":"Y","LanguagePreference":"EN","NightlyCommunication":"N","MobilePhoneNumber":"7890123458","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"Update" },{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "46","ContactName": "TRAVIS","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00",,"EventFlag":"Add" }]}';
        String myJSON = '{"Header":{"Sender":{"ServiceName":"PMWO","SenderID":"BMS"},"Target":"CSS","LocationCode":"02850-02651"},"DataArea":[{"ERPWorkOrder":"49440","CustomerCode":"102686","PaymentType":"","Prepaid":"PM Prepay","SiteId":"2","SiteLocation":"In Shop","LaborMultiplier":"","SiteContactId":"3","SupervisorFirstName":"","SupervisorLastName":"","ERPContractNumber":"","Type":"External","PSN":"78","Complaint":"","Cause":"","Correction":"","ScheduledDate":"","PromisedDate":"","TransactionType":"PM","ServicePMType":"","SubType":"TestSubType","StandardService":"","NumberOfTechnicians":"2","PreferredTechnician":"","StatusNotes":"","Parts":[{"PartLineNumber":"898493","PartLineType":"PM","PartNumber":"32798404","ProductCode":"","PartDescription":"Test Part1 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"atestd"},{"PartLineNumber":"898494","PartLineType":"PM","PartNumber":"32798405","ProductCode":"","PartDescription":"Test Part2 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"2"},{"PartLineNumber":"898495","PartLineType":"PM","PartNumber":"32798406","ProductCode":"","PartDescription":"Test Part3 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"2"}],"EPRFlag":"","WorkOrderNotes":"Internal Comments","TotalDuration":"3","SRTs":[{"SRTGroup":"Group1","SRTProcedure":"Procedure1","PartNumber":"32798404","SRTDescription":"SRT1 Description","SRTTime":"0.6","SRTQuantity":"2"},{"SRTGroup":"Group2","SRTProcedure":"Procedure2","PartNumber":"32798404","SRTDescription":"SRT2 Description","SRTTime":"0.6","SRTQuantity":"2"},{"SRTGroup":"Group3","SRTProcedure":"Procedure3","PartNumber":"32798404","SRTDescription":"SRT3 Description","SRTTime":"0.6","SRTQuantity":"2"}],"InvoiceDate":"","TaskGroup":""},{"ERPWorkOrder":"494401","CustomerCode":"102686","PaymentType":"","Prepaid":"PM Prepay","SiteId":"2","SiteLocation":"In Shop","LaborMultiplier":"","SiteContactId":"3","SupervisorFirstName":"","SupervisorLastName":"","ERPContractNumber":"","Type":"External","PSN":"78","Complaint":"","Cause":"","Correction":"","ScheduledDate":"","PromisedDate":"","TransactionType":"PM","ServicePMType":"","SubType":"TestSubType","StandardService":"","NumberOfTechnicians":"2","PreferredTechnician":"","StatusNotes":"","Parts":[{"PartLineNumber":"898493","PartLineType":"PM","PartNumber":"32798404","ProductCode":"","PartDescription":"Test Part1 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"2"},{"PartLineNumber":"898494","PartLineType":"PM","PartNumber":"32798405","ProductCode":"","PartDescription":"Test Part2 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"2"},{"PartLineNumber":"898495","PartLineType":"PM","PartNumber":"32798406","ProductCode":"","PartDescription":"Test Part3 Description","PartLocation":"","PartQuantityOrdered":"3","PartQuantityUsed":"2"}],"EPRFlag":"","WorkOrderNotes":"Internal Comments","TotalDuration":"3","SRTs":[{"SRTGroup":"Group1","SRTProcedure":"Procedure1","PartNumber":"32798404","SRTDescription":"SRT1 Description","SRTTime":"0.6","SRTQuantity":"2"},{"SRTGroup":"Group2","SRTProcedure":"Procedure2","PartNumber":"32798404","SRTDescription":"SRT2 Description","SRTTime":"0.6","SRTQuantity":"2"},{"SRTGroup":"Group3","SRTProcedure":"Procedure3","PartNumber":"32798404","SRTDescription":"SRT3 Description","SRTTime":"0.6","SRTQuantity":"2"}],"InvoiceDate":"","TaskGroup":""}]}';
        //Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
        //Test User
        
        FSL_CL_SOWrapper objWrap = new FSL_CL_SOWrapper();
        FSL_CL_SOWrapper.DataArea objDataarea = new FSL_CL_SOWrapper.DataArea();
        objDataarea.ERPWorkOrder = '49440';
        
        WorkType wt = new WorkType();
        wt.name = 'PM';
        wt.EstimatedDuration = 1;
        insert wt;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.FSL_ERP_Customer_Code__c = '102686';
        acc.Name = 'Test Acc';
        acc.Cmi_account_status__c = 'Active';
        acc.BillingStreet = '1466 N, National Rd, testing';
        acc.BillingCity = 'Columbus';
        acc.BillingState = 'Indiana';
        acc.BillingCountry= 'United States';
        acc.BillingPostalCode = '47201';
        acc.Type = 'Customer';
        //added by Harsha
        acc.FSL_Source_ERP__c = 'BMS';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Travis';
        con.LastName = 'Grigg';
        con.AccountId = acc.Id;
        con.FSL_Contact_Id__c = '10';
        con.Phone = '7879883045';
        con.Email = 'test2@cummins.com';
        con.IAM_Contact_Status__c = 'Inactive';
        //con.Mobile_Phone__c='1234567890'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone ='1234567890';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        // con.IAM_Contact_source__c = 'BMS';
        insert con;
        
        /*
        IAM_CDH_Cross_references__c objSite1 = new IAM_CDH_Cross_references__c();
        objSite1.Name = 'TestNew';
        objSite1.IAM_Account__c = acc.Id;
        objSite1.FSL_MoveX_Contact_Id__c = '10';
        objSite1.FSL_MoveX_Site_Id__c = '1';
        objSite1.FSL_City__c = 'Brisbane';
        //siteList.add(objSite1);
        insert objSite1;
        */
        Asset asset1 = new Asset();
        system.runas(listOfUser.get(0)) {
            Schema.Location loc = new Schema.Location();
            loc.Name = 'TestNew';
            loc.FSL_Account__c = acc.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
            
            Schema.Address addr = new Schema.Address();
            addr.parentId = loc.id;
            addr.Account__c = acc.Id;
            addr.Street = '1466 N, National Rd, testing';
            addr.FSL_Site_Name__c = 'TestNew';
            addr.FSL_Site_ID__c = '1';
            addr.City = 'Brisbane';
            insert addr;
            
            
            asset1.Name = '342819';
            asset1.Type_PSN__c = 'External-78';
            asset1.Type__c = 'Engines';
            asset1.AccountId = acc.Id;
            asset1.FSL_Site__c = addr.Id;
            //asset1.Site__C = objSite.Id;
            insert asset1;
        }
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory In Shop OR Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '02850-02651-FPG';
        objServiceTerritory.FSL_Service_Territory_Code__c = '1234-1234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        Test.startTest();
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder.AccountId = acc.Id;
        objWorkOrder.WorkTypeId = workType.Id;
        objWorkOrder.AssetId = asset1.Id;
        objWorkOrder.Shop_Work_Order__c='49440';
        //objWorkOrder.Type__c = 'Internal';
        insert objWorkOrder;
        Test.stoptest();
        FSL_SubType__c st = new FSL_SubType__c();
        st.Name ='TestsubType';
        insert st;  
        // insert st;  
        
        RestRequest request = new RestRequest();
        request.requestUri ='/CreatePMWorkOrder/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        RestContext.response = new RestResponse();
        FSL_CL_CreateSOEndpoint.postPMWorkOrder();
        
        System.assertEquals(false, [SELECT Id FROM CSS_Integration_Error__c WHERE Service_Name__c = 'FSL_CL_CreateSOEndpoint'].isEmpty(), 'Error should be there.');
    }
}