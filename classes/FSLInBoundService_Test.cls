@isTest
public class FSLInBoundService_Test {
    
    public static testMethod void sendJsonRequestTest() {
 
        //Profile and User inserted
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345',ERP__c = 'BMS');
        insert u;
        system.runAs(u) {

//            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            
            //Account Details
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'East Bronx1';
            acc.CMI_Account_Status__c = 'Active';
            acc.PaymentType__c = 'Cash';
            acc.FSL_ERP_Customer_Code__c = '48923';
            acc.FSL_Credit_Limit__c = 78889.8;
            insert acc;
            
            //Contact Details
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.Phone='1234567890';
            con.Email = 'er234@its.jnj.com';
            con.AccountId=acc.id;
            con.FSL_Contact_Id__c='1';
            insert con;
            
            //Worktype
            worktype  wType = new worktype();
            wType.EstimatedDuration = Decimal.valueOf('40.02');
            wType.Name = 'Test';
            insert wType;
            
            //Asset
            Asset  ast = new Asset();
            ast.Account = acc;
            ast.Service_Model__c = 'ISL9 CM2350 L101';
            ast.Unit_Number__c = '1234';
            ast.Make__c = 'KENWORTH';
            ast.Model__c = 'T800';
            ast.Name = '79963830';
            ast.Unit_Type__c = 'EQ8349';
            ast.VIN__c = '1NKDX4TX6JJ180253';
            ast.Type_PSN__c = '796';
            ast.Application_Description__c = 'AUTOMOTIVE';
            ast.Application_Code__c = '130';
            ast.Engine_Family__c    ='56';
            ast.Individual__c = '0450090578';
            ast.Type__c = 'Engines';
            ast.Engine_Manufacturer__c = 'HYUNDAI';
            insert ast;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            //Service Territory
            ServiceTerritory serTer1 = new ServiceTerritory();
            serTer1.Name = 'ST005 Mobile';
            serTer1.OperatingHoursId = oh.Id;
            serTer1.IsActive = true;
            serTer1.Location_Code__c = '03522-04893';
            serTer1.FSL_Service_Territory_Code__c = '04893';
            serTer1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            serTer1.Territory__c = 'AUSTRALIA';
            insert serTer1; 
            
            ServiceTerritory serTer = new ServiceTerritory();
            serTer.Name = 'ST001 Mobile';
            serTer.OperatingHoursId = oh.Id;
            serTer.IsActive = true;
            serTer.Location_Code__c = '03520-04892';
            serTer.FSL_Service_Territory_Code__c = '04892';
            serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            serTer.Territory__c = 'AUSTRALIA';
            insert serTer;
        
            //CT2-416 : create location
        	Schema.Location locationObj = new Schema.Location();
       		locationObj.Name = 'Test cross reff1';
        	locationObj.FSL_Account__c = acc.Id;
        	locationObj.FSL_Contact_ID__c = '10';
        	insert locationObj;
        
        	Schema.Address addressObj = new Schema.Address();
        	addressObj.Street = '345 Dr';
        	addressObj.City = 'Brisbane';
        	addressObj.State = 'Indiana';
        	addressObj.PostalCode = '5000093';
        	addressObj.Country = 'United States';
        	addressObj.Geolocation__Latitude__s = 87.00;
        	addressObj.Geolocation__Longitude__s = 170.00;
        	addressObj.FSL_Site_ID__c = '39';
        	addressObj.FSL_Tax_District__c ='';
        	addressObj.ParentId = locationObj.Id;
        	addressObj.Account__c = acc.Id;
        	insert addressObj;

            List<workorder> woInfo = new List<workorder>();
            workorder wo1 = new workorder();
            wo1.AccountId = acc.Id;
            wo1.Process_Step__c = 'Intake';
            wo1.Asset = ast;
            wo1.Repair_Location__c = 'Mobile';
            wo1.Repair_Site_Address__c = addressObj.id; //CT2-416   
            wo1.EditComplaint__c = 'Testing';
            wo1.EditCause__c = 'Testing';
            wo1.EditCorrection__c = 'Testing';
            wo1.EditCoverage__c = 'Testing';
            wo1.ServiceTerritoryid = serTer.id;
            wo1.WorkTypeId = wType.Id;
            wo1.AssetId = ast.Id;
            //wo1.Case = cs;
            
            woInfo.add(wo1);
            insert woInfo;
            
            List<workorder> woInfo1 = new List<workorder>();
            workorder wo2 = new workorder();
            wo2.id = woInfo[0].id;
            wo2.EditComplaint__c = 'Testing Info';
            wo2.EditCause__c = 'Testing Info';
            wo2.EditCorrection__c = 'Testing Info';
            wo2.EditCoverage__c = 'Testing Info1';
            wo2.ServiceTerritoryid = serTer1.id;
            //wo2.Fuel_Burn__c =89;
            woInfo1.add(wo2);
            
            //Setting Mock Response
        	final String mockResponse = '{"DataArea":{"ESN":80088753,"UnitNumber":524,"IndividualItemNumber":"","ServiceModelName":"ISX15 CM2250 SN"},"Header":{"Sender":{"ServiceName":"GetUnitInfo","SenderID":"CSS","MessageID":"b5636c72-095f-46d4-953c-169281fc7a79"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX-UK"},"ReturnCodeDescription":"Unit updated successfully","Location":{"LocationID":"05306-40582-036"}}}';
        	final FSL_MockHttpResponseGenerator_NC httpMock = new FSL_MockHttpResponseGenerator_NC(mockResponse);
        	Test.setMock(HttpCalloutMock.class, httpMock);
            
            update woInfo1;
            try {
                FSLInBoundService.sendJsonRequest(woInfo1[0].id,acc.FSL_ERP_Customer_Code__c,con.Id,'test');
            }
            catch(exception e) {
                
            }
        }
    }
    
    public static testMethod void sendJsonRequestEXPTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345',ERP__c = 'BMS');
        insert u;
        system.runAs(u) {
            
           
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'East Bronx1';
            acc.CMI_Account_Status__c = 'Active';
            acc.PaymentType__c = 'Cash';
            acc.FSL_ERP_Customer_Code__c = '48923';
            acc.FSL_Credit_Limit__c = 78888.6;
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.Phone='1234567890';
            con.AccountId=acc.id;
            con.FSL_Contact_Id__c='1';
            insert con;
            
            worktype  wType = new worktype();
            wType.EstimatedDuration = Decimal.valueOf('40.02');
            wType.Name = 'Test';
            insert wType;
            
            Asset  ast = new Asset();
            ast.Account = acc;
            ast.Service_Model__c = 'ISL9 CM2350 L101';
            ast.Unit_Number__c = '1234';
            ast.Make__c = 'KENWORTH';
            ast.Model__c = 'T800';
            ast.Name = '79963830';
            ast.Unit_Type__c = 'EQ8349';
            ast.VIN__c = '1NKDX4TX6JJ180253';
            ast.Type_PSN__c = '796';
            ast.Application_Description__c = 'AUTOMOTIVE';
            ast.Application_Code__c = '130';
            ast.Engine_Family__c    ='56';
            // ast.Access_Code__c = 'B';
            ast.Individual__c = '';
            ast.Type__c = 'Engines';
            ast.Engine_Manufacturer__c = 'HYUNDAI';
            insert ast;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            ServiceTerritory serTer1 = new ServiceTerritory();
            serTer1.Name = 'ST005 Mobile';
            serTer1.OperatingHoursId = oh.Id;
            serTer1.IsActive = true;
            serTer1.Location_Code__c = '03522-04893';
            serTer1.FSL_Service_Territory_Code__c = '04893';
            serTer1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            serTer1.Territory__c = 'AUSTRALIA';
            insert serTer1; 
            
            ServiceTerritory serTer = new ServiceTerritory();
            serTer.Name = 'ST001 Mobile';
            serTer.OperatingHoursId = oh.Id;
            serTer.IsActive = true;
            serTer.Location_Code__c = '03520-04892';
            serTer.FSL_Service_Territory_Code__c = '04892';
            serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            serTer.Territory__c = 'AUSTRALIA';
            insert serTer;
            
            
            //CT2-416 : create location
        Schema.Location locationObj = new Schema.Location();
        locationObj.Name = 'Test cross reff1';
        locationObj.FSL_Account__c = acc.Id;
        locationObj.FSL_Contact_ID__c = '10';
        insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
        addressObj.Street = '345 Dr';
          addressObj.City = 'Brisbane';
            addressObj.State = 'Indiana';
            addressObj.PostalCode = '5000093';
        addressObj.Country = 'United States';
        addressObj.Geolocation__Latitude__s = 87.00;
        addressObj.Geolocation__Longitude__s = 170.00;
        addressObj.FSL_Site_ID__c = '39';
        addressObj.FSL_Tax_District__c ='';
        addressObj.ParentId = locationObj.Id;
        addressObj.Account__c = acc.Id;
        insert addressObj;

            Case  cs = new Case();
            cs.Status = 'Intake';
            //cs.Service_Territory__c = serTer.id;
            cs.AccountId = acc.id;
            cs.AssetId = ast.id;
            cs.Priority = 'Medium';
            insert cs;
            
            List<workorder> woInfo = new List<workorder>();
            workorder wo1 = new workorder();
            wo1.AccountId = acc.Id;
            wo1.Process_Step__c = 'Intake';
            wo1.Asset = ast;
            wo1.Repair_Location__c = 'Mobile';
            wo1.Repair_Site_Address__c = addressObj.id; //CT2-416
            wo1.EditComplaint__c = 'Testing';
            wo1.EditCause__c = 'Testing';
            wo1.EditCorrection__c = 'Testing';
            wo1.EditCoverage__c = 'Testing';
            wo1.ServiceTerritoryid = serTer.id;
            wo1.WorkTypeId = wType.Id;
            wo1.AssetId = ast.Id;
            wo1.Case = cs;
            woInfo.add(wo1);
            insert woInfo;
            //update woInfo;
            
            List<workorder> woInfo1 = new List<workorder>();
            workorder wo2 = new workorder();
            wo2.id = woInfo[0].id;
            wo2.Account = acc;
            // wo2.Asset = ast;
            wo2.ServiceTerritoryid = serTer1.id;
            wo2.ContactId = null;
            wo2.EditComplaint__c = 'Testing Info';
            wo2.EditCause__c = 'Testing Info';
            wo2.EditCorrection__c = 'Testing Info';
            wo2.EditCoverage__c = 'Testing Info1';
            wo2.ServiceTerritoryid = serTer1.id;
            wo2.Application__c = '130 - AUTOMOTIVE';
            wo2.Repair_Location__c = 'Mobile';
            // wo2.Asset.name = ast.Name;
            wo2.Mileage_Measure__c = '87';
            //wo2.Asset.Access_Code__c = 'B';
            // wo2.Asset.Registration__c = '12345';
            wo2.Repair_Site_Name__r = null;
            // wo2.Repair_Site_Name__r.FSL_MoveX_Site_Id__c = objSite.FSL_MoveX_Site_Id__c;
            wo2.Mileage__c = 123;
            wo2.CSS_Hours__c = 89;
            wo2.Failure_Date__c = system.Today();
            wo2.Warranty_Start_Date__c = system.Today();
            wo2.Fuel_Burn__c = 89;
            woInfo1.add(wo2);
            
            update woInfo1;
            //
            //Setting Mock Response
        	final String mockResponse = '{"DataArea":{"ESN":80088753,"UnitNumber":"","ServiceModelName":"T610"},"Header":{"Sender":{"ServiceName":"GetUnitInfo","SenderID":"CSS","MessageID":"a1e0802a-9366-4b0e-ab8c-90dfa5fe96e3"},"Status":"ERROR","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"ORA-01861: literal does not match format string","Location":{"LocationID":"02930-02198"}}}';
        	final FSL_MockHttpResponseGenerator_NC httpMock = new FSL_MockHttpResponseGenerator_NC(mockResponse);
        	Test.setMock(HttpCalloutMock.class, httpMock);
            try {
                Test.startTest();
                FSLInBoundService.TargetERP = 'BMS';
                FSLInBoundService.sendJsonRequest(woInfo1[0].id, acc.FSL_ERP_Customer_Code__c, con.Id, '0');
                Test.stopTest();
            }
            catch(exception e) {
                
            }
        }
    }
}