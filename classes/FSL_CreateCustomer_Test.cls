@isTest
public class FSL_CreateCustomer_Test {
    @testSetup static void dataSetup() 
    {
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();    
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account';
        acc.FSL_ERP_Customer_Code__c = '1310102';
        acc.BillingStreet = '1466 N National Rd';
        acc.BillingCity = 'Columbus';
        acc.BillingState = 'Indiana';
        acc.BillingCountry= 'United States';
        acc.BillingPostalCode = '47201-7142';
        insert acc;
        
        Id cashAccRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'Test Account1';
        acc1.FSL_ERP_Customer_Code__c = '211054';
        acc1.BillingStreet = '1466 N National Rd';
        acc1.BillingCity = 'Columbus';
        acc1.BillingState = 'Indiana';
        acc1.BillingCountry= 'United States';
        acc1.BillingPostalCode = '47201';
        acc1.RecordTypeId = cashAccRecId;
        
        insert acc1;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        con.MobilePhone = '4872546895';
        insert con;
        
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
        
        IAM_CDH_Cross_references__c objSite = new IAM_CDH_Cross_references__c();
        objSite.Name = 'Test';
        objSite.IAM_Account__c = acc.Id;
        objSite.FSL_MoveX_Contact_Id__c = '10';
        objSite.FSL_MoveX_Site_Id__c = '2';
        insert objSite;
        
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
        wo.Repair_Site_Name__c = objSite.Id;
        // wo.Failure_Date__c = system.now().addDays(-29);
        wo.Payer__c = acc1.Id;
        insert wo;
        
        Id conRecId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con1=new Contact();
        con1.RecordTypeId = conRecId;
        con1.FirstName='Steve';
        con1.LastName='Johnson';
        con1.Phone='1234567890';
        con1.AccountId=acc1.id;
        con1.MobilePhone = '4872546895';
        insert con1;
        
        OperatingHours  oh1 = new OperatingHours ();
        oh1.Name = 'new';
        oh1.TimeZone = 'America/Chicago';
        insert oh1;
        
        ServiceTerritory sT1 = new ServiceTerritory(); 
        sT1.Name = 'ST001 Inshop';
        sT1.OperatingHoursId = oh1.Id;
        sT1.IsActive = true;
        sT1.Location_Code__c = '05340-05350';
        sT1.FSL_Service_Territory_Code__c = '05350';
        sT1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT1.Territory__c = 'AUSTRALIA';
        Insert sT1;
        
        Asset asst1 = new Asset();
        asst1.Name = '79797979';
        asst1.Type_PSN__c = 'Engines-79797979';
        insert asst1;
        
        FSL_ERP_Country_Translation__mdt fect=new FSL_ERP_Country_Translation__mdt();
        fect.Country__c='Ireland';
        fect.MasterLabel='Eire';
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi2@cummins.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', ERP__c = 'BMS', User_Location__c ='Bronx', Work_Group_Name__c = 'wg',
                                 LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi2@cummins.com', isActive = true);
        insert objUser1;
    }
    
    @isTest static void testCalloutWhenItsMOVEX() {
        test.startTest();
        WorkOrder wo = new WorkOrder();
        wo = [Select id,Account.FSL_ERP_Customer_Code__c from WorkOrder Limit 1];
        
        User usr = new User();
        usr = [SELECT Id, ERP__c  
               FROM User 
               WHERE UserName='css-cmi2@cummins.com' limit 1];
        usr.ERP__c = 'MOVEX';
        update usr;
        
        system.runas(usr) {
            String TargetERP = (String)usr.ERP__c;
            FSL_CreateCustomer.checkCustomerCode(wo.id);
        }
        test.stopTest();
    }
    
    @isTest static void testCalloutForCustomerCreate()
    {
        WorkOrder wo = new WorkOrder();
        wo = [Select id,Account.FSL_ERP_Customer_Code__c from WorkOrder Limit 1];
        
        User usr = new User();
        usr = [SELECT Id, ERP__c  
               FROM User 
               WHERE UserName='css-cmi2@cummins.com' limit 1];
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC('{"DataArea":{"CustomerCode":"","CSSJobID":"00002607"},"Header":{"Status":"SUCCESS","ReturnCodeDescription":"Customer details updated successfully"}}'));
        
        System.debug('$$$ WO ID' + wo.id);
        System.runAs(usr){
            String TargetERP = (String)usr.ERP__c;
            FSL_CreateCustomer.checkCustomerCode(wo.id);
            FSL_CreateCustomer.CallOutResponseWrap uc = FSL_CreateCustomer.updateCustomer('{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Target":{"TargetID":"MOVEX"},"Location":{"LocationID":"05340-05351"}},"DataArea":{"CustomerName":"MyTestCSS Customer","CustomerAddressline1":"Columbus1","CustomerAddressline2":"Columbus2","CustomerAddressline3":"Columbus3","AreaCode":"812","Phone":"2342344","City":"Columbus","State":"IN","PostalCode":"","PostalCodeSuffix":"","CustomerContact":"Test1","BranchCode":"05351","CountryCode":"","Language":"en","Application":"AUTO","CSSJobID":"00002607","ESN":"","ServiceModelName":"","IndividualItemNumber":"","PrimarySegment":""}}',wo.Id);
            FSL_CreateCustomer.CallOutResponseWrap uac = FSL_CreateCustomer.updateAccountCode('{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Target":{"TargetID":"MOVEX-UK"},"Location":{"LocationID":"05340-05351"}},"DataArea":{"CustomerName":"MyTestCSS Customer","CustomerAddressline1":"Columbus1","CustomerAddressline2":"Columbus2","CustomerAddressline3":"Columbus3","AreaCode":"812","Phone":"2342344","City":"Columbus","State":"IN","PostalCode":"","PostalCodeSuffix":"","CustomerContact":"Test1","BranchCode":"05351","CountryCode":"","Language":"en","Application":"130","CSSJobID":"00002607","ESN":"","ServiceModelName":"","IndividualItemNumber":"","PrimarySegment":""}}',wo.Id);
            FSL_CreateCustomer.checkPayerCode(wo.id);
            FSL_CreateCustomer.CallOutResponseWrap upc = FSL_CreateCustomer.updatePayerCode('{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Target":{"TargetID":"MOVEX"},"Location":{"LocationID":"05340-05351"}},"DataArea":{"CustomerName":"MyTestCSS Customer","CustomerAddressline1":"Columbus1","CustomerAddressline2":"Columbus2","CustomerAddressline3":"Columbus3","AreaCode":"812","Phone":"2342344","City":"Columbus","State":"IN","PostalCode":"","PostalCodeSuffix":"","CustomerContact":"Test1","BranchCode":"05351","CountryCode":"","Language":"en","Application":"AUTO","CSSJobID":"00002607","ESN":"","ServiceModelName":"","IndividualItemNumber":"","PrimarySegment":""}}',wo.Id);
            System.assertEquals('SUCCESS',uc.Status);
            System.assertEquals('SUCCESS',uac.Status);
            System.assertEquals('SUCCESS',upc.Status);
        }
        test.stopTest();
    }
    
    @isTest static void testCalloutForCustomerCreateFailure()
    {
        WorkOrder wo = new WorkOrder();
        wo = [Select id,Account.FSL_ERP_Customer_Code__c from WorkOrder Limit 1];
        
        User usr = new User();
        usr = [SELECT Id, ERP__c  
               FROM User 
               WHERE UserName='css-cmi2@cummins.com' limit 1];
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_Reclaim());
        
        System.debug('$$$ WO ID' + wo.id);
        System.runAs(usr){
            FSL_CreateCustomer.checkCustomerCode(null);
            FSL_CreateCustomer.updateCustomer(null,wo.id);
            FSL_CreateCustomer.updateAccountCode(null,wo.id);
            FSL_CreateCustomer.checkPayerCode(null);
            FSL_CreateCustomer.updatePayerCode(null,wo.id);
        }
        test.stopTest();
    }
    
    @isTest static void testCalloutForCustomerCreateError()
    {
        WorkOrder wo = new WorkOrder();
        wo = [Select id,Account.FSL_ERP_Customer_Code__c from WorkOrder Limit 1];
        
        User usr = new User();
        usr = [SELECT Id, ERP__c  
               FROM User 
               WHERE UserName='css-cmi2@cummins.com' limit 1];
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator_NC('{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Status":"ERROR","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"com.bea.wli.sb.pipeline.PipelineException"}}'));
        
        System.runAs(usr){
            FSL_CreateCustomer.CallOutResponseWrap uc = FSL_CreateCustomer.updateCustomer('{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Location":{"LocationID":"05340-05351"}},"DataArea":{"CustomerName":"MyTestCSS Customer","CustomerAddressline1":"Columbus1","CustomerAddressline2":"Columbus2","CustomerAddressline3":"Columbus3","AreaCode":"812","Phone":"2342344","City":"Columbus","State":"IN","PostalCode":"","PostalCodeSuffix":"","CustomerContact":"Test1","BranchCode":"05351","CountryCode":"","Language":"en","Application":"AUTO","CSSJobID":"00002607","ESN":"","ServiceModelName":"","IndividualItemNumber":"","PrimarySegment":""}}',wo.id);
            FSL_CreateCustomer.CallOutResponseWrap uac = FSL_CreateCustomer.updateAccountCode('{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Location":{"LocationID":"05340-05351"}},"DataArea":{"CustomerName":"MyTestCSS Customer","CustomerAddressline1":"Columbus1","CustomerAddressline2":"Columbus2","CustomerAddressline3":"Columbus3","AreaCode":"812","Phone":"2342344","City":"Columbus","State":"IN","PostalCode":"","PostalCodeSuffix":"","CustomerContact":"Test1","BranchCode":"05351","CountryCode":"","Language":"en","Application":"130","CSSJobID":"00002607","ESN":"","ServiceModelName":"","IndividualItemNumber":"","PrimarySegment":""}}',wo.id);
            FSL_CreateCustomer.CallOutResponseWrap upc = FSL_CreateCustomer.updatePayerCode('{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Location":{"LocationID":"05340-05351"}},"DataArea":{"CustomerName":"MyTestCSS Customer","CustomerAddressline1":"Columbus1","CustomerAddressline2":"Columbus2","CustomerAddressline3":"Columbus3","AreaCode":"812","Phone":"2342344","City":"Columbus","State":"IN","PostalCode":"","PostalCodeSuffix":"","CustomerContact":"Test1","BranchCode":"05351","CountryCode":"","Language":"en","Application":"AUTO","CSSJobID":"00002607","ESN":"","ServiceModelName":"","IndividualItemNumber":"","PrimarySegment":""}}',wo.id);
            System.assertEquals('ERROR',uc.Status);
            System.assertEquals('ERROR',uac.Status);
            System.assertEquals('ERROR',upc.Status);
        }
        test.stopTest();
    }
}