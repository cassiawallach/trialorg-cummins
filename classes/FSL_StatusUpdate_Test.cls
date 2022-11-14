@isTest
public class FSL_StatusUpdate_Test { 
    
    //Vamsi - 11/06/21 - test class execution for CPS-94 / INC2996052
    
    @isTest
    public static void fslTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '04892-I');
        u.ERP__C = 'BMS';
        insert u; 
        system.runAs(u) {
            FSL_StatusUpdate.getCurrentUserERP();
            FSL_StatusUpdate.fetchUser();
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
         Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '';
            acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
        
           FSL_StatusUpdate.getCustomMetaDataTypesForErrors('OSB-382500');
           FSL_StatusUpdate.getCustomMetaDataTypesForErrors('Invalid-OSB-12345');

            List < Contact > conList = new List < Contact > ();
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con = new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName = 'Steve';
            con.LastName = 'Johnson';
            con.Phone = '1234567890';
            con.AccountId = acc.id;
            con.FSL_Contact_Id__c = '1';
            
            conList.add(con);
            
            Contact payerCon = new Contact();
            payerCon.CMI_IsActive__c=true;
            payerCon.RecordTypeId = conRecId;
            payerCon.FirstName = 'Steve';
            payerCon.LastName = 'Johnson';
            payerCon.Phone = '1234567890';
            payerCon.AccountId = acc.id;
            payerCon.FSL_Contact_Id__c = '1';
            conList.add(payerCon);
            
            insert conList;
            
            OperatingHours oh = new OperatingHours();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            WorkType wt = new WorkType();
            wt.Name = 'Test work type';
            wt.EstimatedDuration = 60.00;
            insert wt;
            
            ServiceTerritory sT = new ServiceTerritory();
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '03520-04892'; 
            sT.FSL_Service_Territory_Code__c = '04892';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            Schema.Location loc = new Schema.Location();
            loc.Name = 'Test';
            loc.FSL_Account__c = acc.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
        
        Schema.Address addr = new Schema.Address();
            addr.FSL_Site_ID__c = '39';
            addr.Street = '345 Dr';
            addr.City = 'Brisbane';
            addr.State = 'South Australia';
            addr.Country = 'Australia';
            addr.FSL_Tax_District__c ='';
            addr.PostalCode = '5000093';
            addr.Latitude = 70.0;
            addr.Longitude = 175.0;
            //addr.CreatedById = u.id;
            addr.ParentId = loc.Id;
            addr.Account__c = acc.Id;
            insert addr;
            
            Asset ast = new Asset();
            ast.Name = '79788868';
            ast.Warranty_Start_Date__c = date.today();
            ast.Make__c = 'AUTOCAR';
            ast.Type_PSN__c = 'Engines-79788868';
            ast.Service_Model__c = 'ISL G CM2180';
            ast.VIN__c = '5VCACLLE0CH213818';
            ast.Product_Application_Code__c = '10';
            ast.Unit_Number__c = '789';
            ast.Model__c = 'Test';
            ast.VIN__c = 'dsnflksdjlksd';
            ast.Service_Model__c = 'ISX CM570';
            ast.Application_Code__c = '12';
            ast.FSL_Site__c = addr.id;//CT2-416
            ast.AccountId = acc.Id;
            ast.Type__c = 'Engines';
            insert ast;
            
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
            WorkOrder wo = new WorkOrder();
            wo.WorkTypeId = wt.id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Shop_Work_Order__c = '75148';
            wo.CSS_Hours__c = 12;
            wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
            wo.Process_Step__c = 'Intake';
            wo.Make__c = 'AUTOCAR12';
            wo.Model__c = 'Test2';
            //wo.Asset = ast;
            wo.AssetId = ast.Id;
            wo.AccountId = acc.Id;
            wo.ContactId = con.Id;
            wo.Scheduled__c = true;
            wo.CreatedDate = system.now().addDays(-29);
            wo.Available_for_Service__c = system.now().addDays(10);
            wo.FSL_Sub_Type__c = subTypeInfo.id;
            wo.Repair_Location__c = 'In Shop';
            wo.Purchase_Order__c = 'Testing';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.Payer__c = acc.Id;
            wo.Status = 'Intake';
            wo.Payer_ContactID__c = payerCon.Id;
            wo.FSL_Make_Model_Flag__c = true; //Newly added.
            insert wo;
            
            
            FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
            objstage.Manufacturer__c = wo.Make__c;
            objstage.ModelSeries__c = wo.Model__c;
            objstage.ProductApplicationCode__c = ast.Product_Application_Code__c;
            objstage.Type_PSN__c = 'Engines-79788868';
            objstage.PSN__c = ast.Name;
            insert objstage;
            
            list < FSL_MakeModel_Stage__c > lstFsl = new list < FSL_MakeModel_Stage__c > ();
            FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
            objMakeModelstg.ModelSeries__c = 'test';
            objMakeModelstg.PSN__c = 'test';
            objMakeModelstg.Manufacturer__c = 'test';
            objMakeModelstg.Type_PSN__c = 'Engines-797888682';
            lstFsl.add(objMakeModelstg);
            insert lstFsl;
            
            ERP_Message__c erpMessage = new ERP_Message__c();
            erpMessage.Service_Order__c = wo.id;
            erpMessage.Payer_Change__c = true;
            erpMessage.Customer_Credit_Message__c = '{"DataArea":{"CustomerNumber":"131SERV","CreditMessageDetails":[{"CreditMessage":"","CreditMessageCode":"Y"},{"CreditMessage":"","CreditMessageCode":""}]},"Header":{"Sender":{"ServiceName":"GetCustomerCreditMessage","SenderID":"CSS","MessageID":"c4d02883-2ef9-453c-b496-e5d182999d22"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
            insert erpMessage;
            
            List < CSS_Integration_Details__c > conDetails = new List < CSS_Integration_Details__c > ();
            CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
            conDetail.Name = 'OAGOAuth';
            conDetail.Username__c = 'Testing';
            conDetail.Passcode__c = '74784848Test';
            conDetail.End_Point__c = 'https://test.Com/gettoken';
            conDetails.add(conDetail);
            
            CSS_Integration_Details__c conDetail2 = new CSS_Integration_Details__c();
            conDetail2.Name = 'FSL_JobContactInfo';
            conDetail2.Username__c = 'Testing';
            conDetail2.Passcode__c = '7484488Testing';
            conDetail2.End_Point__c = 'https://test.Com/csswarranty/csscontact';
            conDetails.add(conDetail2);
            
            CSS_Integration_Details__c conDetail3 = new CSS_Integration_Details__c();
            conDetail3.Name = 'FSL_InBoundServiceRequest';
            conDetail3.Username__c = 'Testing';
            conDetail3.Passcode__c = '7484488Testing';
            conDetail3.End_Point__c = 'https://test.Com/css/bmsunit';
            // insert conDetail3;
            conDetails.add(conDetail3);
            //
            CSS_Integration_Details__c conDetail4 = new CSS_Integration_Details__c();
            conDetail4.Name = 'FSL_SiteInfo';
            conDetail4.Username__c = 'Testing';
            conDetail4.Passcode__c = '7484488Testing';
            conDetail4.End_Point__c = 'https://test.Com/csswarranty/csssite';
            conDetails.add(conDetail4);
            
            CSS_Integration_Details__c conDetail5 = new CSS_Integration_Details__c();
            conDetail5.Name = 'BMS';
            conDetail5.Username__c = 'Testing';
            conDetail5.Passcode__c = '7484488Testing';
            conDetail5.End_Point__c = 'https://test.Com/bmsworkorder';
            //insert conDetail2;
            conDetails.add(conDetail5);
            insert conDetails;
        
            CSS_Integration_Details__c conDetails6 = new CSS_Integration_Details__c();
            conDetails6.End_Point__c = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi-customers/contact';
            conDetails6.Passcode__c = 'faMaybrRymfn2y1WsujVuenuWFUW40H9m/277vM9gEi5h/CobsQkBCpGuxU/bZqfVypNQSGyuPQgCp5TrujLiQ==';
            conDetails6.Username__c = 'kOlPsxqWLAmrTLWTAEYHRs32PCN+htEsW47RbB0W8i4RQyqvcKIl9EkdAkW9qfrL5virpVrJ9VK/Ob1yKBmL5w==';
            conDetails6.Name = 'FSL_JobContactInfo';
            conDetails6.ApplicationName__c='FSL_JobContactInfo';
            conDetails6.Key__c='Ucob3wbjkcu3w4tIFlrGyvKC44gUviJGCgdM7ydnvbk=';
            conDetails6.AuthEnv__c='MuleAuth';
            conDetails6.Method_Type__c='POST';
            conDetails6.IsActive__c=true;
            insert conDetails6;
            
            FSL_Switch__c MWSwitch = new FSL_Switch__c();
            MWSwitch.Name = 'MWErrors_Switch';
            MWSwitch.IsActive__c = true;
            insert MWSwitch;
            
            WorkOrder woObj = [SELECT Id,WorkOrderNumber,ServiceTerritoryId,Shop_Work_Order__c,CSS_Hours__c,Branch_Code__c,Process_Step__c,
                             Make__c,Model__c,AssetId,AccountId,ContactId,Scheduled__c,Available_for_Service__c,FSL_Sub_Type__c,
                             Repair_Location__c,Purchase_Order__c,CreatedDate,Application__c,Payer__c,Status,Payer_ContactID__c,
                             FSL_Make_Model_Flag__c,ServiceTerritory.Location_Code__c,Contract_Number__c,MaintenancePlanNumber__c,Failure_Date__c,
                             FSL_Sub_Type__r.Name,General_Symptoms__c,Asset.Individual__c,Asset.Engine_Manufacturer__c,
                             Payer_ContactID__r.FSL_Contact_Id__c,Account.FSL_ERP_Customer_Code__c,Contact.FSL_Contact_Id__c,
                             Contact.firstName,Contact.lastname,Contact.phone,Contact.email,payer__r.fsl_erp_customer_code__c
                             FROM WORKORDER WHERE Id=:wo.Id LIMIT 1];
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_StatusUpdate.checkCustomerMessageCode(wo.id);
            FSL_StatusUpdate.getWorkOrder(wo.id);
            FSL_StatusUpdate.updateWorkOrder(woObj);
            FSL_StatusUpdate.insertMakeModelStaging(wo.id);
            FSL_StatusUpdate.doCallUpdateWorkOrder(wo.id);
            String UserErp = FSL_StatusUpdate.getCurrentUserERP();
            Test.stopTest();
        }
    }
    @isTest
    public static void fslTestWithIntakeCmplte_Test() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345',erp__c='BMS');
       
        insert u;
        u.ERP__C = 'BMS';
        system.runAs(u) {
            FSL_StatusUpdate.fetchUser();
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '1231-SERV';
            acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
            
            List < Contact > conList = new List < Contact > ();
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con = new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName = 'Steve Test';
            con.LastName = 'Johnson';
            con.Phone = '1234567890';
            con.AccountId = acc.id;
            con.FSL_Contact_Id__c = '1';
            
            conList.add(con);
            
            Contact payerCon = new Contact();
            payerCon.RecordTypeId = conRecId;
            payerCon.FirstName = 'Steve';
            payerCon.LastName = 'Johnson';
            payerCon.Phone = '1234567890';
            payerCon.AccountId = acc.id;
            payerCon.FSL_Contact_Id__c = '1';
            conList.add(payerCon);
            
            insert conList;
            
            OperatingHours oh = new OperatingHours();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            WorkType wt = new WorkType();
            wt.Name = 'Test work type';
            wt.EstimatedDuration = 60.00;
            insert wt;
            
            ServiceTerritory sT = new ServiceTerritory();
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '03520-04892';
            sT.FSL_Service_Territory_Code__c = '04892';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            //create location //CT2-416
            Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acc.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;

            //create Address //CT2-416
            Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addressObj.ParentId = locationObj.Id;
            addressObj.Account__c = acc.Id;
            
            insert addressObj;
            
            Asset ast = new Asset();
            ast.Name = '79788868';
            ast.Warranty_Start_Date__c = date.today();
            ast.Make__c = 'AUTOCAR';
            ast.Type_PSN__c = 'Engines-79788868';
            ast.Service_Model__c = 'ISL G CM2180';
            ast.VIN__c = '5VCACLLE0CH213818';
            ast.Product_Application_Code__c = '10';
            ast.Unit_Number__c = '789';
            ast.Model__c = 'Test';
            ast.VIN__c = 'dsnflksdjlksd';
            ast.Service_Model__c = 'ISX CM570';
            ast.Application_Code__c = '12';
            ast.FSL_Site__c = addressObj.id;//CT2-416 
            ast.AccountId = acc.Id;
            ast.ContactId = con.Id;
            ast.Type__c = 'Engines';
            insert ast;
            
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
            WorkOrder wo = new WorkOrder();
            wo.WorkTypeId = wt.id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Shop_Work_Order__c = '';
            wo.CSS_Hours__c = 12;
            wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
            wo.Process_Step__c = 'Intake';
            wo.Make__c = 'AUTOCAR12';
            wo.Model__c = 'Test2';
            wo.Asset = ast;
            //wo.AssetId = ast.Id;
            wo.AccountId = acc.Id;
            wo.ContactId = con.Id;
            wo.Scheduled__c = true;
            wo.CreatedDate = system.now().addDays(-29);
            wo.Available_for_Service__c = system.now().addDays(10);
            wo.FSL_Sub_Type__c = subTypeInfo.id;
            wo.Repair_Location__c = 'Mobile';
            wo.Purchase_Order__c = 'Testing';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.Payer__c = acc.Id;
            wo.Status = 'Intake Complete';
            wo.Payer_ContactID__c = payerCon.Id;
          //  wo.Repair_Site_Address__c = addressObj.Id;
            insert wo;
            
            
            FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
            objstage.Manufacturer__c = wo.Make__c;
            objstage.ModelSeries__c = wo.Model__c;
            objstage.ProductApplicationCode__c = ast.Product_Application_Code__c;
            objstage.PSN__c = ast.Name;
            objstage.Type_PSN__c = 'Engines-797888682';
            insert objstage;
            
            list < FSL_MakeModel_Stage__c > lstFsl = new list < FSL_MakeModel_Stage__c > ();
            FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
            objMakeModelstg.ModelSeries__c = 'test';
            objMakeModelstg.PSN__c = 'test';
            objMakeModelstg.Manufacturer__c = 'test';
            objMakeModelstg.Type_PSN__c = 'Engines-79788868';
            lstFsl.add(objMakeModelstg);
            insert lstFsl;
            
            system.debug('** WO' + wo);
            system.debug('** wo assert' + ast);
            system.debug('** wo assert id' + wo.Asset);
            system.debug('wo make' + wo.Make__c + 'wo model' + wo.Model__c + 'wo assert' + wo.Asset.Make__c + 'wo assert model' + wo.Asset.Model__c);
            ERP_Message__c erpMessage = new ERP_Message__c();
            erpMessage.Service_Order__c = wo.id;
            erpMessage.Payer_Change__c = true;
            erpMessage.Customer_Credit_Message__c = '{"DataArea":{"CustomerNumber":"131SERV","CreditMessageDetails":[{"CreditMessage":"","CreditMessageCode":"N"},{"CreditMessage":"","CreditMessageCode":""}]},"Header":{"Sender":{"ServiceName":"GetCustomerCreditMessage","SenderID":"CSS","MessageID":"c4d02883-2ef9-453c-b496-e5d182999d22"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
            insert erpMessage;
            
            List < CSS_Integration_Details__c > conDetails = new List < CSS_Integration_Details__c > ();
            CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
            conDetail.Name = 'OAGOAuth';
            conDetail.Username__c = 'Testing';
            conDetail.Passcode__c = '74784848Test';
            conDetail.End_Point__c = 'https://test.Com/gettoken';
            conDetails.add(conDetail);
            
            CSS_Integration_Details__c conDetail2 = new CSS_Integration_Details__c();
            conDetail2.Name = 'FSL_JobContactInfo';
            conDetail2.Username__c = 'Testing';
            conDetail2.Passcode__c = '7484488Testing';
            conDetail2.End_Point__c = 'https://test.Com/csswarranty/csscontact';
            conDetails.add(conDetail2);
            
            CSS_Integration_Details__c conDetail3 = new CSS_Integration_Details__c();
            conDetail3.Name = 'FSL_InBoundServiceRequest';
            conDetail3.Username__c = 'Testing';
            conDetail3.Passcode__c = '7484488Testing';
            conDetail3.End_Point__c = 'https://test.Com/css/bmsunit';
            // insert conDetail3;
            conDetails.add(conDetail3);
            
            CSS_Integration_Details__c conDetail4 = new CSS_Integration_Details__c();
            conDetail4.Name = 'FSL_SiteInfo';
            conDetail4.Username__c = 'Testing';
            conDetail4.Passcode__c = '7484488Testing';
            conDetail4.End_Point__c = 'https://test.Com/csswarranty/csssite';
            conDetails.add(conDetail4);
            
            CSS_Integration_Details__c conDetail5 = new CSS_Integration_Details__c();
            conDetail5.Name = 'BMS';
            conDetail5.Username__c = 'Testing';
            conDetail5.Passcode__c = '7484488Testing';
            conDetail5.End_Point__c = 'https://test.Com/bmsworkorder';
            //insert conDetail2;
            conDetails.add(conDetail5);
            insert conDetails;
            
            CSS_Integration_Details__c conDetails6 = new CSS_Integration_Details__c();
            conDetails6.End_Point__c = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi-customers/contact';
            conDetails6.Passcode__c = 'faMaybrRymfn2y1WsujVuenuWFUW40H9m/277vM9gEi5h/CobsQkBCpGuxU/bZqfVypNQSGyuPQgCp5TrujLiQ==';
            conDetails6.Username__c = 'kOlPsxqWLAmrTLWTAEYHRs32PCN+htEsW47RbB0W8i4RQyqvcKIl9EkdAkW9qfrL5virpVrJ9VK/Ob1yKBmL5w==';
            conDetails6.Name = 'FSL_JobContactInfo';
            conDetails6.ApplicationName__c='FSL_JobContactInfo';
            conDetails6.Key__c='Ucob3wbjkcu3w4tIFlrGyvKC44gUviJGCgdM7ydnvbk=';
            conDetails6.AuthEnv__c='MuleAuth';
            conDetails6.Method_Type__c='POST';
            conDetails6.IsActive__c=true;
            insert conDetails6;
            
            FSL_Switch__c MWSwitch = new FSL_Switch__c();
            MWSwitch.Name = 'MWErrors_Switch';
            MWSwitch.IsActive__c = true;
            insert MWSwitch;
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_StatusUpdate.checkCustomerMessageCode(wo.id);
            FSL_StatusUpdate.getWorkOrder(wo.id);
            FSL_StatusUpdate.updateWorkOrder(wo);
            FSL_StatusUpdate.insertMakeModelStaging(wo.id);
            FSL_StatusUpdate.doCallUpdateWorkOrder(wo.id);
            FSL_StatusUpdate.calloutCommentInbound(wo.Id);
            Test.stopTest();
        }
    }
    @isTest
    public static void fslTestWithAsset_Test() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345' );
        //u.ERP__C = 'MOVEX';
        insert u;
        system.runAs(u) {
           
            FSL_StatusUpdate.fetchUser();
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '';
            acc.Phone= '1234567890';
            acc.FSL_Primary_Market_Segment__c = 'HD Truck';
            acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
            
            List < Contact > conList = new List < Contact > ();
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con = new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName = 'Steve';
            con.LastName = 'Johnson';
            con.Phone = '1234567890';
            con.AccountId = acc.id;
            con.FSL_Contact_Id__c = '1';
            
            conList.add(con);
            
            Contact payerCon = new Contact();
            payerCon.RecordTypeId = conRecId;
            payerCon.FirstName = 'Steve';
            payerCon.LastName = 'Johnson';
            payerCon.Phone = '1234567890';
            payerCon.AccountId = acc.id;
            payerCon.FSL_Contact_Id__c = '1';
            conList.add(payerCon);
            
            insert conList;
            
            OperatingHours oh = new OperatingHours();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            WorkType wt = new WorkType();
            wt.Name = 'Test work type';
            wt.EstimatedDuration = 60.00;
            insert wt;
            
            ServiceTerritory sT = new ServiceTerritory();
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '03520-04892';
            sT.FSL_Service_Territory_Code__c = '04892';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            //create location //CT2-416
            Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acc.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;

            //create Address //CT2-416
            Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addressObj.ParentId = locationObj.Id;
            addressObj.Account__c = acc.Id;
            
            insert addressObj;
            
            Asset ast = new Asset();
            ast.Name = '79788868';
            ast.Warranty_Start_Date__c = date.today();
            ast.Make__c = 'AUTOCAR';
            ast.Type_PSN__c = 'Engines-79788868';
            ast.Service_Model__c = 'ISL G CM2180';
            ast.VIN__c = '5VCACLLE0CH213818';
            ast.Product_Application_Code__c = '10';
            ast.Unit_Number__c = '789';
            ast.Model__c = 'Test';
            ast.VIN__c = 'dsnflksdjlksd';
            ast.Service_Model__c = 'ISX CM570';
            ast.Application_Code__c = '12';
            ast.FSL_Site__c = addressObj.id;//CT2-416
            ast.AccountId = acc.Id;
            ast.Type__c = 'Engines';
            insert ast;
            
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
            WorkOrder wo = new WorkOrder();
            wo.WorkTypeId = wt.id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Shop_Work_Order__c = '75148';
            wo.CSS_Hours__c = 12;
            wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
            wo.Process_Step__c = 'Intake';
            wo.Make__c = 'AUTOCAR12';
            wo.Model__c = 'Test2';
           wo.Asset = ast;
            wo.AssetId = ast.Id;
            wo.AccountId = acc.Id;
            wo.ContactId = con.Id;
            wo.Scheduled__c = true;
            wo.CreatedDate = system.now().addDays(-29);
            wo.Available_for_Service__c = system.now().addDays(10);
            wo.FSL_Sub_Type__c = subTypeInfo.id;
            wo.Repair_Location__c = 'In Shop';
            wo.Purchase_Order__c = 'Testing';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.Payer__c = acc.Id;
            wo.Status = 'Intake Complete';
            wo.Payer_ContactID__c = payerCon.Id;
            insert wo;
            
            
            FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
            objstage.Manufacturer__c = wo.Make__c;
            objstage.ModelSeries__c = wo.Model__c;
            objstage.ProductApplicationCode__c = ast.Product_Application_Code__c;
            objstage.PSN__c = ast.Name;
            objstage.Type_PSN__c = 'Engines-79788868';
            insert objstage;
            
            list < FSL_MakeModel_Stage__c > lstFsl = new list < FSL_MakeModel_Stage__c > ();
            FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
            objMakeModelstg.ModelSeries__c = 'test';
            objMakeModelstg.PSN__c = 'test';
            objMakeModelstg.Manufacturer__c = 'test';
            objMakeModelstg.Type_PSN__c = 'Engines-797888682';
            lstFsl.add(objMakeModelstg);
            insert lstFsl;
            
            system.debug('** WO' + wo);
            system.debug('** wo assert' + ast);
            system.debug('** wo assert id' + wo.Asset);
            system.debug('wo make' + wo.Make__c + 'wo model' + wo.Model__c + 'wo assert' + wo.Asset.Make__c + 'wo assert model' + wo.Asset.Model__c);
            ERP_Message__c erpMessage = new ERP_Message__c();
            erpMessage.Service_Order__c = wo.id;
            erpMessage.Payer_Change__c = true;
            erpMessage.Customer_Credit_Message__c = '{"DataArea":{"CustomerNumber":"131SERV","CreditMessageDetails":[{"CreditMessage":"","CreditMessageCode":"N"},{"CreditMessage":"","CreditMessageCode":""}]},"Header":{"Sender":{"ServiceName":"GetCustomerCreditMessage","SenderID":"CSS","MessageID":"c4d02883-2ef9-453c-b496-e5d182999d22"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
            insert erpMessage;
            
            List < CSS_Integration_Details__c > conDetails = new List < CSS_Integration_Details__c > ();
            CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
            conDetail.Name = 'OAGOAuth';
            conDetail.Username__c = 'Testing';
            conDetail.Passcode__c = '74784848Test';
            conDetail.End_Point__c = 'https://test.Com/gettoken';
            conDetails.add(conDetail);
            
           /* CSS_Integration_Details__c conDetail2 = new CSS_Integration_Details__c();
            conDetail2.Name = 'FSL_JobContactInfo';
            conDetail2.Username__c = 'Testing';
            conDetail2.Passcode__c = '7484488Testing';
            conDetail2.End_Point__c = 'https://test.Com/csswarranty/csscontact';
            conDetails.add(conDetail2);
            */
            CSS_Integration_Details__c conDetail3 = new CSS_Integration_Details__c();
            conDetail3.Name = 'FSL_InBoundServiceRequest';
            conDetail3.Username__c = 'Testing';
            conDetail3.Passcode__c = '7484488Testing';
            conDetail3.End_Point__c = 'https://test.Com/css/bmsunit';
            // insert conDetail3;
            conDetails.add(conDetail3);
            
            CSS_Integration_Details__c conDetail4 = new CSS_Integration_Details__c();
            conDetail4.Name = 'FSL_SiteInfo';
            conDetail4.Username__c = 'Testing';
            conDetail4.Passcode__c = '7484488Testing';
            conDetail4.End_Point__c = 'https://test.Com/csswarranty/csssite';
            conDetails.add(conDetail4);
            
            CSS_Integration_Details__c conDetail5 = new CSS_Integration_Details__c();
            conDetail5.Name = 'BMS';
            conDetail5.Username__c = 'Testing';
            conDetail5.Passcode__c = '7484488Testing';
            conDetail5.End_Point__c = 'https://test.com/bmsworkorder';
            //insert conDetail2;
            conDetails.add(conDetail5);
            insert conDetails;
            
            CSS_Integration_Details__c conDetails6 = new CSS_Integration_Details__c();
            conDetails6.End_Point__c = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi-customers/contact';
            conDetails6.Passcode__c = 'faMaybrRymfn2y1WsujVuenuWFUW40H9m/277vM9gEi5h/CobsQkBCpGuxU/bZqfVypNQSGyuPQgCp5TrujLiQ==';
            conDetails6.Username__c = 'kOlPsxqWLAmrTLWTAEYHRs32PCN+htEsW47RbB0W8i4RQyqvcKIl9EkdAkW9qfrL5virpVrJ9VK/Ob1yKBmL5w==';
            conDetails6.Name = 'FSL_JobContactInfo';
            conDetails6.ApplicationName__c='FSL_JobContactInfo';
            conDetails6.Key__c='Ucob3wbjkcu3w4tIFlrGyvKC44gUviJGCgdM7ydnvbk=';
            conDetails6.AuthEnv__c='MuleAuth';
            conDetails6.Method_Type__c='POST';
            conDetails6.IsActive__c=true;
            insert conDetails6;
            
            FSL_Switch__c MWSwitch = new FSL_Switch__c();
            MWSwitch.Name = 'MWErrors_Switch';
            MWSwitch.IsActive__c = true;
            insert MWSwitch;
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_StatusUpdate.checkCustomerMessageCode(wo.id);
            FSL_StatusUpdate.getWorkOrder(wo.id);
            FSL_StatusUpdate.updateWorkOrder(FSL_StatusUpdate.getWorkOrder(wo.id));
            FSL_StatusUpdate.insertMakeModelStaging(wo.id);
            FSL_StatusUpdate.doCallUpdateWorkOrder(wo.id);
            Test.stopTest();
        }
    }
    @isTest
    public static void fslTestERP_MOVEX_Test() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345', ERP__c = 'MOVEX');
        insert u;
        system.runAs(u) {
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.FSL_ERP_Customer_Code__c = '130SERV';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus'; 
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.Email_Notification_Frequency__c = 'Nightly';
            
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con = new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName = 'Steve';
            con.LastName = 'Johnson';
            con.Phone = '1234567890';
            con.AccountId = acc.id;
            con.FSL_Contact_Id__c = '1';
            insert con;
            
            
            
            OperatingHours oh = new OperatingHours();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            WorkType wt = new WorkType();
            wt.Name = 'Test work type';
            wt.EstimatedDuration = 60.00;
            insert wt;
            
            ServiceTerritory sT = new ServiceTerritory();
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '03520-04892';
            sT.FSL_Service_Territory_Code__c = '04892';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            //create location //CT2-416
            Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acc.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;

            //create Address //CT2-416
            Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addressObj.ParentId = locationObj.Id;
            addressObj.Account__c = acc.Id;
            
            insert addressObj;
            
            Asset ast = new Asset();
            ast.Name = '79788868';
            ast.Warranty_Start_Date__c = date.today();
            ast.Make__c = 'AUTOCAR';
            ast.Type_PSN__c = 'Engines-79788868';
            ast.Service_Model__c = 'ISL G CM2180';
            ast.VIN__c = '5VCACLLE0CH213818';
            ast.Product_Application_Code__c = '10';
            ast.Unit_Number__c = '789';
            ast.Model__c = 'Test';
            ast.VIN__c = 'dsnflksdjlksd';
            ast.Service_Model__c = 'ISX CM570';
            ast.Application_Code__c = '12';
            ast.FSL_Site__c = addressObj.id;//CT2-416
            ast.AccountId = acc.Id;
            ast.Type__c = 'Engines';
            insert ast;
            
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
            WorkOrder wo = new WorkOrder();
            wo.WorkTypeId = wt.id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Shop_Work_Order__c = '75148';
            wo.CSS_Hours__c = 12;
            wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
            wo.Process_Step__c = 'Intake';
            wo.Make__c = 'AUTOCAR12';
            wo.Model__c = 'Test2';
            wo.FSL_Make_Model_Flag__c = TRUE;
            //wo.Asset = ast;
            wo.AssetId = ast.Id;
            wo.AccountId = acc.Id;
            wo.ContactId = con.Id;
            wo.Scheduled__c = true;
            wo.CreatedDate = system.now().addDays(-29);
            wo.Available_for_Service__c = system.now().addDays(10);
            wo.FSL_Sub_Type__c = subTypeInfo.id;
            wo.Repair_Location__c = 'In Shop';
            wo.Purchase_Order__c = 'Testing';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.Payer__c = acc.Id;
            wo.Status = 'Intake';
            wo.Repair_Location__c = 'Mobile';
          //  wo.Repair_Site_Address__c = addressObj.Id;
            insert wo;
            
            
            FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
            objstage.Manufacturer__c = wo.Make__c;
            objstage.ModelSeries__c = wo.Model__c;
            objstage.ProductApplicationCode__c = ast.Product_Application_Code__c;
            objstage.PSN__c = ast.Name;
            objstage.Type_PSN__c = 'Engines-79788868';
            insert objstage;
            
            list < FSL_MakeModel_Stage__c > lstFsl = new list < FSL_MakeModel_Stage__c > ();
            FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
            objMakeModelstg.ModelSeries__c = 'test';
            objMakeModelstg.PSN__c = 'test';
            objMakeModelstg.Manufacturer__c = 'test';
            objMakeModelstg.Type_PSN__c = 'Engines-797888682';
            lstFsl.add(objMakeModelstg);
            insert lstFsl;
            
            system.debug('** WO' + wo);
            system.debug('** wo assert' + ast);
            system.debug('** wo assert id' + wo.Asset);
            system.debug('wo make' + wo.Make__c + 'wo model' + wo.Model__c + 'wo assert' + wo.Asset.Make__c + 'wo assert model' + wo.Asset.Model__c);
            ERP_Message__c erpMessage = new ERP_Message__c();
            erpMessage.Service_Order__c = wo.id;
            erpMessage.Payer_Change__c = true;
            erpMessage.Customer_Credit_Message__c = '{"DataArea":{"CustomerNumber":"131SERV","CreditMessageDetails":[{"CreditMessage":"","CreditMessageCode":"N"},{"CreditMessage":"","CreditMessageCode":""}]},"Header":{"Sender":{"ServiceName":"GetCustomerCreditMessage","SenderID":"CSS","MessageID":"c4d02883-2ef9-453c-b496-e5d182999d22"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
            insert erpMessage;
            
            List < CSS_Integration_Details__c > conDetails = new List < CSS_Integration_Details__c > ();
            CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
            conDetail.Name = 'OAGOAuth';
            conDetail.Username__c = 'Testing';
            conDetail.Passcode__c = '74784848Test';
            conDetail.End_Point__c = 'https://test.Com/gettoken';
            conDetails.add(conDetail);
            
            CSS_Integration_Details__c conDetail2 = new CSS_Integration_Details__c();
            conDetail2.Name = 'FSL_JobContactInfo';
            conDetail2.Username__c = 'Testing';
            conDetail2.Passcode__c = '7484488Testing';
            conDetail2.End_Point__c = 'https://test.Com/csswarranty/csscontact';
            conDetails.add(conDetail2);
            
            CSS_Integration_Details__c conDetail3 = new CSS_Integration_Details__c();
            conDetail3.Name = 'FSL_InBoundServiceRequest';
            conDetail3.Username__c = 'Testing';
            conDetail3.Passcode__c = '7484488Testing';
            conDetail3.End_Point__c = 'https://test.Com/css/bmsunit';
            // insert conDetail3;
            conDetails.add(conDetail3);
            
            CSS_Integration_Details__c conDetail4 = new CSS_Integration_Details__c();
            conDetail4.Name = 'FSL_SiteInfo';
            conDetail4.Username__c = 'Testing';
            conDetail4.Passcode__c = '7484488Testing';
            conDetail4.End_Point__c = 'https://test.Com/csswarranty/csssite';
            conDetails.add(conDetail4);
            
            CSS_Integration_Details__c conDetail5 = new CSS_Integration_Details__c();
            conDetail5.Name = 'BMSCustomer';
            conDetail5.Username__c = 'Testing';
            conDetail5.Passcode__c = '7484488Testing';
            conDetail5.End_Point__c = 'https://test.Com/bmsworkorder';
            //insert conDetail2;
            conDetails.add(conDetail5);
            insert conDetails;
            
            FSL_Switch__c MWSwitch = new FSL_Switch__c();
            MWSwitch.Name = 'MWErrors_Switch';
            MWSwitch.IsActive__c = true;
            insert MWSwitch;
            
            WorkOrder woObj = [SELECT Id,WorkOrderNumber,ServiceTerritoryId,Shop_Work_Order__c,CSS_Hours__c,Branch_Code__c,Process_Step__c,
                               Make__c,Model__c,AssetId,AccountId,ContactId,Scheduled__c,Available_for_Service__c,FSL_Sub_Type__c,
                               Repair_Location__c,Purchase_Order__c,CreatedDate,Application__c,Payer__c,Status,Payer_ContactID__c,
                               FSL_Make_Model_Flag__c,ServiceTerritory.Location_Code__c,Contract_Number__c,MaintenancePlanNumber__c,Failure_Date__c,
                               FSL_Sub_Type__r.Name,General_Symptoms__c,Asset.Individual__c,Asset.Engine_Manufacturer__c,
                               Payer_ContactID__r.FSL_Contact_Id__c,Account.FSL_ERP_Customer_Code__c,Contact.FSL_Contact_Id__c,Contact.firstName,contact.lastname,
                               Contact.Phone,Asset.Unit_Number__c,Asset.Model__c,Asset.Make__c,Asset.Service_Model__c,Asset.Engine_Family_Code__c,Asset.Name,
                               Contact.email,Payer__r.FSL_ERP_Customer_Code__c,Repair_Site_Address__c
                               FROM WORKORDER WHERE Id=:wo.Id LIMIT 1];
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_StatusUpdate.checkCustomerMessageCode(wo.id);
            FSL_StatusUpdate.getWorkOrder(wo.id);
            FSL_StatusUpdate.updateWorkOrder(woObj);
            FSL_StatusUpdate.insertMakeModelStaging(wo.id);
            FSL_StatusUpdate.doCallUpdateWorkOrder(wo.id);
           
            Test.stopTest();
        }
    }
    @isTest
    public static void fslTestERP_MOVEXWithAst_Test() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345', ERP__c = 'MOVEX');
        insert u;
        system.runAs(u) {
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '130SERV';
            acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
            
            Account acc2 = new Account();
            acc2.RecordTypeId = accRecId;
            acc2.Name = 'Test Account2';
            acc2.FSL_ERP_Customer_Code__c = '131SERV';
            acc2.BillingStreet = '1465 N National Rd';
            acc2.BillingCity = 'Columbus';
            acc2.BillingState = 'Indiana';
            acc2.BillingCountry= 'United States';
            acc2.BillingPostalCode = '47202';
            acc2.Email_Notification_Frequency__c = 'Nightly';
            insert acc2; //payer
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con = new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName = 'Steve';
            con.LastName = 'Johnson';
            con.Phone = '1234567890';
            con.AccountId = acc.id;
            con.FSL_Contact_Id__c = '1';
            insert con;
            
            
            
            OperatingHours oh = new OperatingHours();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            WorkType wt = new WorkType();
            wt.Name = 'Test work type';
            wt.EstimatedDuration = 60.00;
            insert wt;
            
            ServiceTerritory sT = new ServiceTerritory();
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '03520-04892';
            sT.FSL_Service_Territory_Code__c = '04892';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            //create location //CT2-416
            Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acc.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;

            //create Address //CT2-416
            Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addressObj.ParentId = locationObj.Id;
            addressObj.Account__c = acc.Id;
            
            insert addressObj;
            
            Asset ast = new Asset();
            ast.Name = '79788868';
            ast.Warranty_Start_Date__c = date.today();
            ast.Make__c = 'AUTOCAR';
            ast.Type_PSN__c = 'Engines-79788868';
            ast.Service_Model__c = 'ISL G CM2180';
            ast.VIN__c = '5VCACLLE0CH213818';
            ast.Product_Application_Code__c = '10';
            ast.Unit_Number__c = '789';
            ast.Model__c = 'Test';
            ast.VIN__c = 'dsnflksdjlksd';
            ast.Service_Model__c = 'ISX CM570';
            ast.Application_Code__c = '12';
            // ast.FSL_Site__c = addressObj.id;//CT2-416
            ast.AccountId = acc.Id;
            ast.Type__c = 'FIREPUMP';
            insert ast;
            
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
            //Added for test class issue - Rama
            Test.startTest();
            
            Id woRecId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('Intake').getRecordTypeId();

            WorkOrder wo = new WorkOrder();
            wo.WorkTypeId = wt.id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Shop_Work_Order__c = '75148';
            wo.CSS_Hours__c = 12;
            wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
            wo.Process_Step__c = 'Intake';
            wo.Make__c = 'AUTOCAR12';
            wo.Model__c = 'Test2';
            wo.FSL_Make_Model_Flag__c = TRUE;
            wo.Asset = ast;
            wo.AssetId = ast.Id;
            wo.AccountId = acc.Id;
            wo.ContactId = con.Id;
            wo.Scheduled__c = true;
            wo.CreatedDate = system.now().addDays(-29);
            wo.Available_for_Service__c = system.now().addDays(10);
            wo.FSL_Sub_Type__c = subTypeInfo.id;
            wo.Repair_Location__c = 'In Shop';
            wo.Purchase_Order__c = 'Testing';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.Payer__c = acc2.Id;
            wo.Status = 'Intake';
            wo.Type__c = 'External';
            wo.RecordTypeId = woRecId;
            insert wo;
            
            
            FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
            objstage.Manufacturer__c = wo.Make__c;
            objstage.ModelSeries__c = wo.Model__c;
            objstage.ProductApplicationCode__c = ast.Product_Application_Code__c;
            objstage.PSN__c = ast.Name;
            objstage.Type_PSN__c = 'Engines-79788868';
            insert objstage;
            
            list < FSL_MakeModel_Stage__c > lstFsl = new list < FSL_MakeModel_Stage__c > ();
            FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
            objMakeModelstg.ModelSeries__c = 'test';
            objMakeModelstg.PSN__c = 'test';
            objMakeModelstg.Manufacturer__c = 'test';
            objMakeModelstg.Type_PSN__c = 'Engines-797888682';
            lstFsl.add(objMakeModelstg);
            insert lstFsl;
            
            FSL_Switch__c MWSwitch = new FSL_Switch__c();
            MWSwitch.Name = 'MWErrors_Switch';
            MWSwitch.IsActive__c = true;
            insert MWSwitch;
            
            system.debug('** WO' + wo);
            system.debug('** wo assert' + ast);
            system.debug('** wo assert id' + wo.Asset);
            system.debug('wo make' + wo.Make__c + 'wo model' + wo.Model__c + 'wo assert' + wo.Asset.Make__c + 'wo assert model' + wo.Asset.Model__c);
            ERP_Message__c erpMessage = new ERP_Message__c();
            erpMessage.Service_Order__c = wo.id;
            erpMessage.Payer_Change__c = true;
            erpMessage.Customer_Credit_Message__c = '{"DataArea":{"CustomerNumber":"131SERV","CreditMessageDetails":[{"CreditMessage":"","CreditMessageCode":"N"},{"CreditMessage":"","CreditMessageCode":""}]},"Header":{"Sender":{"ServiceName":"GetCustomerCreditMessage","SenderID":"CSS","MessageID":"c4d02883-2ef9-453c-b496-e5d182999d22"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
            insert erpMessage;

            List < CSS_Integration_Details__c > conDetails = new List < CSS_Integration_Details__c > ();
            CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
            conDetail.Name = 'OAGOAuth';
            conDetail.Username__c = 'Testing';
            conDetail.Passcode__c = '74784848Test';
            conDetail.End_Point__c = 'https://test.Com/gettoken';
            conDetails.add(conDetail);
            
            CSS_Integration_Details__c conDetail2 = new CSS_Integration_Details__c();
            conDetail2.Name = 'FSL_JobContactInfo';
            conDetail2.Username__c = 'Testing';
            conDetail2.Passcode__c = '7484488Testing';
            conDetail2.End_Point__c = 'https://test.Com/csswarranty/csscontact';
            conDetails.add(conDetail2);
            
            CSS_Integration_Details__c conDetail3 = new CSS_Integration_Details__c();
            conDetail3.Name = 'FSL_InBoundServiceRequest';
            conDetail3.Username__c = 'Testing';
            conDetail3.Passcode__c = '7484488Testing';
            conDetail3.End_Point__c = 'https://test.Com/css/bmsunit';
            // insert conDetail3;
            conDetails.add(conDetail3);
            
            CSS_Integration_Details__c conDetail4 = new CSS_Integration_Details__c();
            conDetail4.Name = 'FSL_SiteInfo';
            conDetail4.Username__c = 'Testing';
            conDetail4.Passcode__c = '7484488Testing';
            conDetail4.End_Point__c = 'https://test.Com/csswarranty/csssite';
            conDetails.add(conDetail4);
            
            CSS_Integration_Details__c conDetail5 = new CSS_Integration_Details__c();
            conDetail5.Name = 'BMS';
            conDetail5.Username__c = 'Testing';
            conDetail5.Passcode__c = '7484488Testing';
            conDetail5.End_Point__c = 'https://test.Com/bmsworkorder';
            //insert conDetail2;
            conDetails.add(conDetail5);
            
            CSS_Integration_Details__c conDetail6 = new CSS_Integration_Details__c();
            conDetail6.Name = 'FSL_CreateCustomer';
            conDetail6.Username__c = 'Testing';
            conDetail6.Passcode__c = '7484488Testing';
            conDetail6.End_Point__c = 'https://test.Com/cmi-customers/customer';
            //insert conDetail2;
            conDetails.add(conDetail6);
            insert conDetails;
            FSL_StatusUpdate.getCustomMetaDataTypesForErrors('OSB-382500');
            FSL_StatusUpdate.getCustomMetaDataTypesForErrors('Invalid-OSB-12345');
            //Moving this up for test class - Rama
            //Test.startTest();

             WorkOrder woObj = [SELECT Id,WorkOrderNumber,ServiceTerritoryId,Shop_Work_Order__c,CSS_Hours__c,Branch_Code__c,Process_Step__c,
                               Make__c,Model__c,AssetId,AccountId,ContactId,Scheduled__c,Available_for_Service__c,FSL_Sub_Type__c,
                               Repair_Location__c,Purchase_Order__c,CreatedDate,Application__c,Payer__c,Status,Payer_ContactID__c,
                               FSL_Make_Model_Flag__c,ServiceTerritory.Location_Code__c,Contract_Number__c,MaintenancePlanNumber__c,Failure_Date__c,
                               FSL_Sub_Type__r.Name,General_Symptoms__c,Asset.Individual__c,Asset.Engine_Manufacturer__c,
                               Payer_ContactID__r.FSL_Contact_Id__c,Account.FSL_ERP_Customer_Code__c,Contact.FSL_Contact_Id__c,Contact.firstName,contact.lastname,
                               Contact.Phone,Asset.Unit_Number__c,Asset.Model__c,Asset.Make__c,Asset.Service_Model__c,Asset.Engine_Family_Code__c,Asset.Name,
                               Contact.email,Payer__r.FSL_ERP_Customer_Code__c,Repair_Site_Address__c
                               FROM WORKORDER WHERE Id=:wo.Id LIMIT 1];
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_StatusUpdate.checkCustomerMessageCode(wo.id);
            FSL_StatusUpdate.getWorkOrder(wo.id);
            FSL_StatusUpdate.processStepUpdateWO(wo);
           // FSL_StatusUpdate.updateWorkOrder(wo);
            FSL_StatusUpdate.insertMakeModelStaging(wo.id);
            FSL_StatusUpdate.doCallUpdateWorkOrder(wo.id);
            FSL_StatusUpdate.calloutCommentInbound(wo.Id);
            String UserErp = FSL_StatusUpdate.getCurrentUserERP();

            Test.stopTest();
        }
    }
    @isTest
    public static void fslTestERP_MOVEX_NoCustCode_Test() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345', ERP__c = 'MOVEX');
        insert u;
        system.runAs(u) {
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
            List < Account > accList = new List < Account > ();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '';
            acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
            
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con = new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName = 'Steve';
            con.LastName = 'Johnson';
            con.Phone = '1234567890';
            con.AccountId = acc.id;
            con.FSL_Contact_Id__c = '1';
            insert con;
            
            OperatingHours oh = new OperatingHours();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            WorkType wt = new WorkType();
            wt.Name = 'Test work type';
            wt.EstimatedDuration = 60.00;
            insert wt;
            
            ServiceTerritory sT = new ServiceTerritory();
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '03520-04892';
            sT.FSL_Service_Territory_Code__c = '04892';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            //create location //CT2-416
            Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acc.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;

            //create Address //CT2-416
            Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addressObj.ParentId = locationObj.Id;
            addressObj.Account__c = acc.Id;
            
            insert addressObj;

            //create Address //CT2-416
            Schema.Address addressObj2 = new Schema.Address();
            addressObj2.FSL_Site_ID__c = '39';
            addressObj2.Street = '345 Dr';
            addressObj2.City = 'Brisbane';
            addressObj2.State = 'South Australia';
            addressObj2.Country = 'Australia';
            addressObj2.FSL_Tax_District__c ='';
            
            addressObj2.PostalCode = '5000093';
            addressObj2.Latitude = 70.0;
            addressObj2.Longitude = 175.0;
            //addressObj2.CreatedById = u.id;
            addressObj2.ParentId = locationObj.Id;
            addressObj2.Account__c = acc.Id;
            
            insert addressObj2;
            
            Asset ast = new Asset();
            ast.Name = '79788868';
            ast.Warranty_Start_Date__c = date.today();
            ast.Make__c = 'AUTOCAR';
            ast.Type_PSN__c = 'Engines-79788868';
            ast.Service_Model__c = 'ISL G CM2180';
            ast.VIN__c = '5VCACLLE0CH213818';
            ast.Product_Application_Code__c = '10';
            ast.Unit_Number__c = '789';
            ast.Model__c = 'Test';
            ast.VIN__c = 'dsnflksdjlksd';
            ast.Service_Model__c = 'ISX CM570';
            ast.Application_Code__c = '12';
            ast.FSL_Site__c = addressObj.id;//CT2-416
            ast.AccountId = acc.Id;
            ast.Type__c = 'Engines';
            insert ast;
            
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
            WorkOrder wo = new WorkOrder();
            wo.WorkTypeId = wt.id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Shop_Work_Order__c = '75148';
            wo.CSS_Hours__c = 12;
            wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
            wo.Process_Step__c = 'Intake';
            wo.Make__c = 'AUTOCAR12';
            wo.Model__c = 'Test2';
            //wo.Asset = ast;
            wo.AssetId = ast.Id;
            wo.AccountId = acc.Id;
            wo.ContactId = con.Id;
            wo.Scheduled__c = true;
            wo.CreatedDate = system.now().addDays(-29);
            wo.Available_for_Service__c = system.now().addDays(10);
            wo.FSL_Sub_Type__c = subTypeInfo.id;
            wo.Repair_Location__c = 'Mobile';
          //  wo.Repair_Site_Address__c = addressObj2.Id;//CT2-416
            wo.Purchase_Order__c = 'Testing';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.Payer__c = acc.Id;
            wo.ContactId = con.Id;
            //wo.Status = 'Intake';
            insert wo;
            
            FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
            objstage.Manufacturer__c = wo.Make__c;
            objstage.ModelSeries__c = wo.Model__c;
            objstage.ProductApplicationCode__c = ast.Product_Application_Code__c;
            objstage.PSN__c = ast.Name;
            objstage.Type_PSN__c = 'Engines-79788868';
            insert objstage;
            
            list < FSL_MakeModel_Stage__c > lstFsl = new list < FSL_MakeModel_Stage__c > ();
            FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
            objMakeModelstg.ModelSeries__c = 'test';
            objMakeModelstg.PSN__c = 'test';
            objMakeModelstg.Manufacturer__c = 'test';
            objMakeModelstg.Type_PSN__c = 'Engines-797888682';
            lstFsl.add(objMakeModelstg);
            insert lstFsl;
            
            system.debug('** WO' + wo);
            system.debug('** wo assert' + ast);
            system.debug('** wo assert id' + wo.Asset);
            system.debug('wo make' + wo.Make__c + 'wo model' + wo.Model__c + 'wo assert' + wo.Asset.Make__c + 'wo assert model' + wo.Asset.Model__c);
            ERP_Message__c erpMessage = new ERP_Message__c();
            erpMessage.Service_Order__c = wo.id;
            erpMessage.Payer_Change__c = true;
            erpMessage.Customer_Credit_Message__c = '{"DataArea":{"CustomerNumber":"131SERV","CreditMessageDetails":[{"CreditMessage":"","CreditMessageCode":"N"},{"CreditMessage":"","CreditMessageCode":""}]},"Header":{"Sender":{"ServiceName":"GetCustomerCreditMessage","SenderID":"CSS","MessageID":"c4d02883-2ef9-453c-b496-e5d182999d22"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
            insert erpMessage;
            
            List < CSS_Integration_Details__c > conDetails = new List < CSS_Integration_Details__c > ();
            CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
            conDetail.Name = 'OAGOAuth';
            conDetail.Username__c = 'Testing';
            conDetail.Passcode__c = '74784848Test';
            conDetail.End_Point__c = 'https://test.Com/gettoken';
            conDetails.add(conDetail);
            
            /*CSS_Integration_Details__c conDetail2 = new CSS_Integration_Details__c();
            conDetail2.Name = 'FSL_JobContactInfo';
            conDetail2.Username__c = 'Testing';
            conDetail2.Passcode__c = '7484488Testing';
            conDetail2.End_Point__c = 'https://test.Com/csswarranty/csscontact';
            conDetails.add(conDetail2);*/
            
            CSS_Integration_Details__c conDetail3 = new CSS_Integration_Details__c();
            conDetail3.Name = 'FSL_InBoundServiceRequest';
            conDetail3.Username__c = 'Testing';
            conDetail3.Passcode__c = '7484488Testing';
            conDetail3.End_Point__c = 'https://test.Com/css/bmsunit';
            // insert conDetail3;
            conDetails.add(conDetail3);
            
            CSS_Integration_Details__c conDetail4 = new CSS_Integration_Details__c();
            conDetail4.Name = 'FSL_SiteInfo';
            conDetail4.Username__c = 'Testing';
            conDetail4.Passcode__c = '7484488Testing';
            conDetail4.End_Point__c = 'https://test.Com/csswarranty/csssite';
            conDetails.add(conDetail4);
            
            CSS_Integration_Details__c conDetail5 = new CSS_Integration_Details__c();
            conDetail5.Name = 'BMSCustomer';
            conDetail5.Username__c = 'Testing';
            conDetail5.Passcode__c = '7484488Testing';
            conDetail5.End_Point__c = 'https://test.Com/bmsworkorder';
            //insert conDetail2;
            conDetails.add(conDetail5);
            insert conDetails;

            CSS_Integration_Details__c conDetails6 = new CSS_Integration_Details__c();
            conDetails6.End_Point__c = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi-customers/contact';
            conDetails6.Passcode__c = 'faMaybrRymfn2y1WsujVuenuWFUW40H9m/277vM9gEi5h/CobsQkBCpGuxU/bZqfVypNQSGyuPQgCp5TrujLiQ==';
            conDetails6.Username__c = 'kOlPsxqWLAmrTLWTAEYHRs32PCN+htEsW47RbB0W8i4RQyqvcKIl9EkdAkW9qfrL5virpVrJ9VK/Ob1yKBmL5w==';
            conDetails6.Name = 'FSL_JobContactInfo';
            conDetails6.ApplicationName__c='FSL_JobContactInfo';
            conDetails6.Key__c='Ucob3wbjkcu3w4tIFlrGyvKC44gUviJGCgdM7ydnvbk=';
            conDetails6.AuthEnv__c='MuleAuth';
            conDetails6.Method_Type__c='POST';
            conDetails6.IsActive__c=true;
            insert conDetails6;
            
			FSL_Switch__c MWSwitch = new FSL_Switch__c();
            MWSwitch.Name = 'MWErrors_Switch';
            MWSwitch.IsActive__c = true;
            insert MWSwitch;
            FSL_StatusUpdate.getCustomMetaDataTypesForErrors('OSB-382500');
            FSL_StatusUpdate.getCustomMetaDataTypesForErrors('Invalid-OSB-12345');
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_StatusUpdate.checkCustomerMessageCode(wo.id);
            FSL_StatusUpdate.getWorkOrder(wo.id);            
            FSL_StatusUpdate.updateWorkOrder(wo);
            FSL_StatusUpdate.insertMakeModelStaging(wo.id);
            FSL_StatusUpdate.doCallUpdateWorkOrder(wo.id);
            Test.stopTest();
        }
    }
   /* @isTest
    //Commenting for test class errors - Rama
    public static void fslTest_One_Test() {
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        acc.FSL_ERP_Customer_Code__c = '130SERV';
        acc.BillingStreet = '1466 N National Rd';
        acc.BillingCity = 'Columbus';
        acc.BillingState = 'Indiana';
        acc.BillingCountry= 'United States';
        acc.BillingPostalCode = '47201';
        acc.Email_Notification_Frequency__c = 'Nightly';
        insert acc;
        
        Account acc2 = new Account();
        acc2.RecordTypeId = accRecId;
        acc2.Name = 'Test Account2';
        acc2.FSL_ERP_Customer_Code__c = '';
        acc2.BillingStreet = '1465 N National Rd';
        acc2.BillingCity = 'Columbus';
        acc2.BillingState = 'Indiana';
        acc2.BillingCountry= 'United States';
        acc2.BillingPostalCode = '47202';
        acc2.Email_Notification_Frequency__c = 'Nightly';
        insert acc2; //payer
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con = new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName = 'Steve';
        con.LastName = 'Johnson';
        con.Phone = '1234567890';
        con.AccountId = acc.Id;
        con.FSL_Contact_Id__c = '10';
        con.Email = 'test@cummins.com';
        insert con;
        
        
        
        OperatingHours oh = new OperatingHours();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        WorkType wt = new WorkType();
        wt.Name = 'Test work type';
        wt.EstimatedDuration = 60.00;
        insert wt;
        
        ServiceTerritory sT = new ServiceTerritory();
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '03520-04892';
        sT.FSL_Service_Territory_Code__c = '04892';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;
        
        //create location //CT2-416
        Schema.Location locationObj = new Schema.Location();
        locationObj.Name = 'Test';
        locationObj.FSL_Account__c = acc.Id;
        locationObj.FSL_Contact_ID__c = '10';
        insert locationObj;

        //create Address //CT2-416
        Schema.Address addressObj = new Schema.Address();
        addressObj.FSL_Site_ID__c = '39';
        addressObj.Street = '345 Dr';
        addressObj.City = 'Brisbane';
        addressObj.State = 'South Australia';
        addressObj.Country = 'Australia';
        addressObj.FSL_Tax_District__c ='';
        
        addressObj.PostalCode = '5000093';
        addressObj.Latitude = 70.0;
        addressObj.Longitude = 175.0;
        //addressObj.CreatedById = u.id;
        addressObj.ParentId = locationObj.Id;
        addressObj.Account__c = acc.Id;
        
        insert addressObj;

        //create Address //CT2-416
        Schema.Address addressObj2 = new Schema.Address();
        addressObj2.FSL_Site_ID__c = '39';
        addressObj2.Street = '345 Dr';
        addressObj2.City = 'Brisbane';
        addressObj2.State = 'South Australia';
        addressObj2.Country = 'Australia';
        addressObj2.FSL_Tax_District__c ='';
        
        addressObj2.PostalCode = '5000093';
        addressObj2.Latitude = 70.0;
        addressObj2.Longitude = 175.0;
        //addressObj2.CreatedById = u.id;
        addressObj2.ParentId = locationObj.Id;
        addressObj2.Account__c = acc.Id;
        
        insert addressObj2;

        Asset ast = new Asset();
        ast.Name = '79788868';
        ast.Warranty_Start_Date__c = date.today();
        ast.Make__c = 'AUTOCAR';
        ast.Application_Code__c = '12';
        ast.Type_PSN__c = 'Engines-79788868';
        ast.Service_Model__c = 'ISL G CM2180';
        ast.VIN__c = '5VCACLLE0CH213818';
        ast.Product_Application_Code__c = '10';
        ast.Unit_Number__c = '789';
        ast.Model__c = 'Test';
        ast.FSL_Site__c = addressObj.id;//CT2-416
        ast.AccountId = acc.Id;
        ast.ContactId = con.Id;
        ast.Type__c = 'Engines';
        insert ast;
        
        FSL_SubType__c subTypeInfo = new FSL_SubType__c();
        subTypeInfo.Name = 'R1';
        subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
        subTypeInfo.Branch_Code__c = 04892;
        subTypeInfo.Status__c = 'Active';
        insert subTypeInfo;
        
        Id woRecId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByName().get('EVL ServiceOrder').getRecordTypeId();

        WorkOrder wo = new WorkOrder();
        wo.WorkTypeId = wt.id;
       // wo.ServiceTerritoryId = sT.Id;
        wo.Shop_Work_Order__c = '75148';
        wo.CSS_Hours__c = 12;
        wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
        wo.Make__c = 'AUTOCAR12';
        wo.Model__c = 'Test2';
        wo.Asset = ast;
        wo.AssetId = ast.Id;
        wo.AccountId = acc.Id;
        wo.ContactId = con.Id;
        wo.Scheduled__c = true;
        wo.Communication_Type__c = 'Manual Communication';
        wo.Manual_Communication__c = 'Service Work Proceeding';
        wo.CreatedDate = system.now().addDays(-29);
        wo.Available_for_Service__c = system.now().addDays(10);
        wo.FSL_Sub_Type__c = subTypeInfo.Id;
        wo.Repair_Location__c = 'Mobile';
        wo.Repair_Site_Address__c = addressObj2.Id;//CT2-416
        wo.Purchase_Order__c = 'Testing';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.Payer__c = acc2.Id;
        wo.General_Symptoms__c = 'Testing_Sri';
        wo.Type__C = 'Dealer';
        wo.RecordTypeId = woRecId;
         insert wo;
              
        FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
        objstage.Manufacturer__c = wo.Make__c;
        objstage.ModelSeries__c = wo.Model__c;
        objstage.ProductApplicationCode__c = ast.Product_Application_Code__c;
        objstage.PSN__c = ast.Name;
        objstage.Type_PSN__c = 'Engines-797888682';
        insert objstage;
        
        list < FSL_MakeModel_Stage__c > lstFsl = new list < FSL_MakeModel_Stage__c > ();
        FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
        objMakeModelstg.ModelSeries__c = 'test';
        objMakeModelstg.PSN__c = 'test';
        objMakeModelstg.Manufacturer__c = 'test';
        objMakeModelstg.Type_PSN__c = 'Engines-79788868';
        lstFsl.add(objMakeModelstg);
        insert lstFsl;
        
        system.debug('** WO' + wo);
        system.debug('** wo assert' + ast);
        system.debug('** wo assert id' + wo.Asset);
        system.debug('wo make' + wo.Make__c + 'wo model' + wo.Model__c + 'wo assert' + wo.Asset.Make__c + 'wo assert model' + wo.Asset.Model__c);
        ERP_Message__c erpMessage = new ERP_Message__c();
        erpMessage.Service_Order__c = wo.id;
        erpMessage.Payer_Change__c = true;
        erpMessage.Customer_Credit_Message__c = '{"DataArea":{"CustomerNumber":"131SERV","CreditMessageDetails":[{"CreditMessage":"","CreditMessageCode":"N"},{"CreditMessage":"","CreditMessageCode":""}]},"Header":{"Sender":{"ServiceName":"GetCustomerCreditMessage","SenderID":"CSS","MessageID":"c4d02883-2ef9-453c-b496-e5d182999d22"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
        insert erpMessage;
        
        List < CSS_Integration_Details__c > conDetails = new List < CSS_Integration_Details__c > ();
        CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
        conDetail.Name = 'OAGOAuth';
        conDetail.Username__c = 'Testing';
        conDetail.Passcode__c = '74784848Test';
        conDetail.End_Point__c = 'https://test.Com/gettoken';
        conDetails.add(conDetail);
        
        CSS_Integration_Details__c conDetail3 = new CSS_Integration_Details__c();
        conDetail3.Name = 'FSL_InBoundServiceRequest';
        conDetail3.Username__c = 'Testing';
        conDetail3.Passcode__c = '7484488Testing';
        conDetail3.End_Point__c = 'https://test.Com/css/bmsunit';
        // insert conDetail3;
        conDetails.add(conDetail3);
        
        CSS_Integration_Details__c conDetail4 = new CSS_Integration_Details__c();
        conDetail4.Name = 'FSL_SiteInfo';
        conDetail4.Username__c = 'Testing';
        conDetail4.Passcode__c = '7484488Testing';
        conDetail4.End_Point__c = 'https://test.Com/csswarranty/csssite';
        conDetails.add(conDetail4);
        
        CSS_Integration_Details__c conDetail5 = new CSS_Integration_Details__c();
        conDetail5.Name = 'BMS';
        conDetail5.Username__c = 'Testing';
        conDetail5.Passcode__c = '7484488Testing';
        conDetail5.End_Point__c = 'https://test.Com/bmsworkorder';
        //insert conDetail2;
        conDetails.add(conDetail5);
        insert conDetails;
        
        CSS_Integration_Details__c conDetails6 = new CSS_Integration_Details__c();
        conDetails6.End_Point__c = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi-customers/contact';
        conDetails6.Passcode__c = 'faMaybrRymfn2y1WsujVuenuWFUW40H9m/277vM9gEi5h/CobsQkBCpGuxU/bZqfVypNQSGyuPQgCp5TrujLiQ==';
        conDetails6.Username__c = 'kOlPsxqWLAmrTLWTAEYHRs32PCN+htEsW47RbB0W8i4RQyqvcKIl9EkdAkW9qfrL5virpVrJ9VK/Ob1yKBmL5w==';
        conDetails6.Name = 'FSL_JobContactInfo';
        conDetails6.ApplicationName__c='FSL_JobContactInfo';
        conDetails6.Key__c='Ucob3wbjkcu3w4tIFlrGyvKC44gUviJGCgdM7ydnvbk=';
        conDetails6.AuthEnv__c='MuleAuth';
        conDetails6.Method_Type__c='POST';
        conDetails6.IsActive__c=true;
        insert conDetails6;
        
        FSL_Switch__c MWSwitch = new FSL_Switch__c();
        MWSwitch.Name = 'MWErrors_Switch';
        MWSwitch.IsActive__c = true;
        insert MWSwitch;

        WorkOrder woObj = [SELECT Id,WorkOrderNumber,ServiceTerritoryId,Shop_Work_Order__c,CSS_Hours__c,Branch_Code__c,Process_Step__c,
                           Make__c,Model__c,AssetId,AccountId,ContactId,Scheduled__c,Available_for_Service__c,FSL_Sub_Type__c,
                           Repair_Location__c,Purchase_Order__c,CreatedDate,Application__c,Payer__c,Status,Payer_ContactID__c,Repair_Site_Address__c,
                           FSL_Make_Model_Flag__c,ServiceTerritory.Location_Code__c,Contract_Number__c,MaintenancePlanNumber__c,Failure_Date__c,
                           FSL_Sub_Type__r.Name,General_Symptoms__c,
                           Asset.Individual__c,Asset.Engine_Manufacturer__c,Asset.Unit_Number__c,Asset.Model__c,Asset.Make__c,Asset.Service_Model__c,
                           Asset.Engine_Family_Code__c,Asset.Name,
                           Payer_ContactID__r.FSL_Contact_Id__c,Account.FSL_ERP_Customer_Code__c,Contact.FSL_Contact_Id__c,
                           Contact.firstName,Contact.lastname,Contact.phone,Contact.email,Payer__r.FSL_ERP_Customer_Code__c
                           FROM WORKORDER WHERE Id=:wo.Id LIMIT 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_StatusUpdate.checkCustomerMessageCode(wo.id);
        FSL_StatusUpdate.getWorkOrder(wo.id);
        FSL_StatusUpdate.updateWorkOrder(woObj);
        FSL_StatusUpdate.insertMakeModelStaging(wo.id);
        FSL_StatusUpdate.doCallUpdateWorkOrder(wo.id);
        Test.stopTest(); 
    }*/
    @isTest
    static void negativeTestFewMethods_Test () {
        
        
        List<Account> accList = new List<Account>();
        
        Account acc = populateAccount(FALSE);
        acc.BillingStreet = '1466 N National Rd';
        acc.BillingCity = 'Columbus';
        acc.BillingState = 'Indiana';
        acc.BillingCountry= 'United States';
        acc.BillingPostalCode = '47201';
        acc.Email_Notification_Frequency__c = 'Nightly';
        Account acc1 = populateAccount(FALSE);
        acc1.BillingStreet = '1466 N National Rd';
        acc1.BillingCity = 'Columbus';
        acc1.BillingState = 'Indiana';
        acc1.BillingCountry= 'United States';
        acc1.BillingPostalCode = '47201';
        acc1.Email_Notification_Frequency__c = 'Nightly';
        acc1.FSL_ERP_Customer_Code__c = '';
        acc1.FSL_Source_ERP__c = 'BMS';
        accList.add(acc);
        accList.add(acc1);
        insert accList;
        List < Contact > conList = new List < Contact > ();
        
        Contact con = popualteContact(acc, FALSE);
         
        conList.add(con);
        
        Contact payerCon =popualteContact(acc, FALSE);
        payerCon.IAM_Contact_Status__c = 'Active'; 
        conList.add(payerCon);
        
        Contact payerCon1 =popualteContact(acc1, FALSE);
        payerCon1.IAM_Contact_Status__c = 'Active'; 
        conList.add(payerCon1);
        System.debug('**   accountId on payerCon ------------------>:' + payerCon.AccountId);
        insert conList;
        
        
        
        
        OperatingHours oh = new OperatingHours();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        WorkType wt = new WorkType();
        wt.Name = 'Test work type';
        wt.EstimatedDuration = 60.00;
        insert wt;
        
        ServiceTerritory sT = new ServiceTerritory();
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '03520-04892';
        sT.FSL_Service_Territory_Code__c = '04892';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;
        
        //create location //CT2-416
        Schema.Location locationObj = new Schema.Location();
        locationObj.Name = 'Test';
        locationObj.FSL_Account__c = acc.Id;
        locationObj.FSL_Contact_ID__c = '10';
        insert locationObj;

        //create Address //CT2-416
        Schema.Address addressObj = new Schema.Address();
        addressObj.FSL_Site_ID__c = '39';
        addressObj.Street = '345 Dr';
        addressObj.City = 'Brisbane';
        addressObj.State = 'South Australia';
        addressObj.Country = 'Australia';
        addressObj.FSL_Tax_District__c ='';
        
        addressObj.PostalCode = '5000093';
        addressObj.Latitude = 70.0;
        addressObj.Longitude = 175.0;
        //addressObj.CreatedById = u.id;
        addressObj.ParentId = locationObj.Id;
        addressObj.Account__c = acc.Id;
        
        insert addressObj;

        //create Address //CT2-416
        Schema.Address addressObj2 = new Schema.Address();
        addressObj2.FSL_Site_ID__c = '39';
        addressObj2.Street = '345 Dr';
        addressObj2.City = 'Brisbane';
        addressObj2.State = 'South Australia';
        addressObj2.Country = 'Australia';
        addressObj2.FSL_Tax_District__c ='';
        
        addressObj2.PostalCode = '5000093';
        addressObj2.Latitude = 70.0;
        addressObj2.Longitude = 175.0;
        //addressObj2.CreatedById = u.id;
        addressObj2.ParentId = locationObj.Id;
        addressObj2.Account__c = acc.Id;
        
        insert addressObj2;

        Asset ast = new Asset();
        ast.Name = '79788868';
        ast.Warranty_Start_Date__c = date.today();
        ast.Make__c = 'AUTOCAR';
        ast.Application_Code__c = '12';
        ast.Type_PSN__c = 'Engines-79788868';
        ast.Service_Model__c = 'ISL G CM2180';
        ast.VIN__c = '5VCACLLE0CH213818';
        ast.Product_Application_Code__c = '10';
        ast.Unit_Number__c = '789';
        ast.Model__c = 'Test';
        ast.FSL_Site__c = addressObj.id;//CT2-416
        ast.AccountId = acc.Id;
        ast.ContactId = con.Id;
        ast.Type__c = 'Engines';
        insert ast;
        
        FSL_SubType__c subTypeInfo = new FSL_SubType__c();
        subTypeInfo.Name = 'R1';
        subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
        subTypeInfo.Branch_Code__c = 04892;
        subTypeInfo.Status__c = 'Active';
        insert subTypeInfo;
        
        WorkOrder wo = new WorkOrder();
        wo.WorkTypeId = wt.id;
        wo.ServiceTerritoryId = sT.Id;
        wo.Shop_Work_Order__c = '75148';
        wo.CSS_Hours__c = 12;
        wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
        wo.Process_Step__c = 'Intake';
        wo.Make__c = 'AUTOCAR12';
        wo.Model__c = 'Test2';
        wo.Asset = ast;
        wo.AssetId = ast.Id;
        wo.AccountId = acc.Id;
        wo.ContactId = con.Id;
        wo.Payer_ContactID__c = con.Id;
        wo.Scheduled__c = true;
        wo.CreatedDate = system.now().addDays(-29);
        wo.Available_for_Service__c = system.now().addDays(10);
        wo.FSL_Sub_Type__c = subTypeInfo.Id;
        wo.Repair_Location__c = 'Mobile';
      //  wo.Repair_Site_Address__c = addressObj2.Id;//CT2-416
        wo.Purchase_Order__c = 'Testing';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.Payer__c = acc1.Id;
        wo.Payer_ContactID__c = payerCon1.Id;
        System.debug('**   accountId on Payer__c ------------------>:' + acc.Id);
        wo.General_Symptoms__c = 'Testing_Sri';
        insert wo;
        
        
        
        FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
        objstage.Manufacturer__c = wo.Make__c;
        objstage.ModelSeries__c = wo.Model__c;
        objstage.ProductApplicationCode__c = ast.Product_Application_Code__c;
        objstage.PSN__c = ast.Name;
        objstage.Type_PSN__c = 'Engines-79788868';
        insert objstage;
        
        list < FSL_MakeModel_Stage__c > lstFsl = new list < FSL_MakeModel_Stage__c > ();
        FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
        objMakeModelstg.ModelSeries__c = 'test';
        objMakeModelstg.PSN__c = 'test';
        objMakeModelstg.Manufacturer__c = 'test';
        objMakeModelstg.Type_PSN__c = 'Engines-797888682';
        lstFsl.add(objMakeModelstg);
        insert lstFsl;
        
        system.debug('** WO' + wo);
        system.debug('** wo assert' + ast);
        system.debug('** wo assert id' + wo.Asset);
        system.debug('wo make' + wo.Make__c + 'wo model' + wo.Model__c + 'wo assert' + wo.Asset.Make__c + 'wo assert model' + wo.Asset.Model__c);
        ERP_Message__c erpMessage = new ERP_Message__c();
        erpMessage.Service_Order__c = wo.id;
        erpMessage.Payer_Change__c = true;
        erpMessage.Customer_Credit_Message__c = '{"DataArea":{"CustomerNumber":"131SERV","CreditMessageDetails":[{"CreditMessage":"","CreditMessageCode":"N"},{"CreditMessage":"","CreditMessageCode":""}]},"Header":{"Sender":{"ServiceName":"GetCustomerCreditMessage","SenderID":"CSS","MessageID":"c4d02883-2ef9-453c-b496-e5d182999d22"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
        insert erpMessage;
        
        List < CSS_Integration_Details__c > conDetails = new List < CSS_Integration_Details__c > ();
        CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
        conDetail.Name = 'OAGOAuth';
        conDetail.Username__c = 'Testing';
        conDetail.Passcode__c = '74784848Test';
        conDetail.End_Point__c = 'https://test.Com/gettoken';
        conDetails.add(conDetail);
        
        CSS_Integration_Details__c conDetail2 = new CSS_Integration_Details__c();
        conDetail2.Name = 'FSL_JobContactInfo';
        conDetail2.Username__c = 'Testing';
        conDetail2.Passcode__c = '7484488Testing';
        conDetail2.End_Point__c = 'https://test.Com/csswarranty/csscontact';
        conDetails.add(conDetail2);
        
        
        CSS_Integration_Details__c conDetail3 = new CSS_Integration_Details__c();
        conDetail3.Name = 'FSL_InBoundServiceRequest';
        conDetail3.Username__c = 'Testing';
        conDetail3.Passcode__c = '7484488Testing';
        conDetail3.End_Point__c = 'https://test.Com/css/bmsunit';
        // insert conDetail3;
        conDetails.add(conDetail3);
        
        CSS_Integration_Details__c conDetail4 = new CSS_Integration_Details__c();
        conDetail4.Name = 'FSL_SiteInfo';
        conDetail4.Username__c = 'Testing';
        conDetail4.Passcode__c = '7484488Testing';
        conDetail4.End_Point__c = 'https://test.Com/csswarranty/csssite';
        conDetails.add(conDetail4);
        
        CSS_Integration_Details__c conDetail5 = new CSS_Integration_Details__c();
        conDetail5.Name = 'BMS';
        conDetail5.Username__c = 'Testing';
        conDetail5.Passcode__c = '7484488Testing';
        conDetail5.End_Point__c = 'https://test.Com/bmsworkorder';
        //insert conDetail2;
        conDetails.add(conDetail5);
        insert conDetails;
        FSL_CreateCustomer.CallOutResponseWrap Accwrap = new FSL_CreateCustomer.CallOutResponseWrap();
        Accwrap.accObj = acc;
        FSL_CreateCustomer.CallOutResponseWrap Accwrap1 = new FSL_CreateCustomer.CallOutResponseWrap();
        Accwrap1.accObj = acc1;
        wo.Account = acc;
        wo.Payer__r = acc1;
        FSL_JobContactInfo.CallOutResponseWrap wrap = new FSL_JobContactInfo.CallOutResponseWrap();
        wrap.conObj = con;
        FSL_JobContactInfo.CallOutResponseWrap wrap1 = new FSL_JobContactInfo.CallOutResponseWrap();
        wrap1.conObj = payerCon;
        FSL_CL_SiteCreateUpdate.CallOutResponseWrap siteWrap = new FSL_CL_SiteCreateUpdate.CallOutResponseWrap();
        siteWrap.siteObj = addressObj;//CT2-416
        FSLInBoundService.CallOutResponseWrap asstWrap = new FSLInBoundService.CallOutResponseWrap();
        asstWrap.asstObj = ast;
        
        FSL_Switch__c MWSwitch = new FSL_Switch__c();
        MWSwitch.Name = 'MWErrors_Switch';
        MWSwitch.IsActive__c = true;
        insert MWSwitch;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        
        FSL_StatusUpdate.onContactCheckFail(wo, acc, acc1, Accwrap, Accwrap1);
        FSL_StatusUpdate.onPayerContactCheckFail(wo, acc, acc1, con, Accwrap, Accwrap1, wrap);
        FSL_StatusUpdate.onSiteCheckFail(wo, acc, acc1, con, payerCon, Accwrap, Accwrap1, wrap, wrap1);
        FSL_StatusUpdate.onAssetCheckFail(wo, acc, acc1, con, payerCon, addressObj, Accwrap, Accwrap1, wrap, wrap1, siteWrap);//CT2-416
        FSL_StatusUpdate.onWorkOrderCheckFail(wo, acc, acc1, con, payerCon, addressObj, ast, Accwrap, Accwrap1, wrap, wrap1, siteWrap, asstWrap);//CT2-416
        
        //added by harsha 04-22-2020        
        FSL_StatusUpdate.calloutCommentInbound(wo.ID);
        /**Change*/
        System.debug('** wo------------>:' + JSON.serialize(wo));
        FSL_StatusUpdate.updateWorkOrder(wo);
         
        Test.stopTest();
        
    }
    static Account populateAccount (Boolean isInsert) {
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        acc.FSL_ERP_Customer_Code__c = '';
        acc.Email_Notification_Frequency__c = 'Nightly';        
        if (isInsert) {
            insert acc;    
        }
       return acc;      
    }
    static Contact popualteContact (Account acc, Boolean isInsert) {
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con = new Contact();
        con.RecordTypeId = conRecId;
        con.CMI_IsActive__c= true;
        con.FirstName = 'Steve';
        con.LastName = 'Johnson';
        con.Phone = '1234567890';
        con.AccountId = acc.id;
        con.FSL_Contact_Id__c = '1';
        if (isInsert) {
            insert con;
        }
        return con;
        
    }
    
        @isTest
    public static void fslTestERP_MOVEX_MobileTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345', ERP__c = 'MOVEX');
        insert u;
        system.runAs(u) {
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '';
            acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
        
        Schema.Location loc = new Schema.Location();
            loc.Name = 'Test';
            loc.FSL_Account__c = acc.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
        
        Schema.Address addr = new Schema.Address();
            addr.FSL_Site_ID__c = '39';
            addr.Street = '345 Dr';
            addr.City = 'Brisbane';
            addr.State = 'South Australia';
            addr.Country = 'Australia';
            addr.FSL_Tax_District__c ='';
            
            addr.PostalCode = '5000093';
            addr.Latitude = 70.0;
            addr.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addr.ParentId = loc.Id;
            addr.Account__c = acc.Id;
            insert addr;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con = new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName = 'Steve';
            con.LastName = 'Johnson';
            con.Phone = '1234567890';
            con.AccountId = acc.id;
            con.FSL_Contact_Id__c = '1';
            insert con;
            
            
            
            OperatingHours oh = new OperatingHours();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            WorkType wt = new WorkType();
            wt.Name = 'Test work type';
            wt.EstimatedDuration = 60.00;
            insert wt;
            
            ServiceTerritory sT = new ServiceTerritory();
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '03520-04892';
            sT.FSL_Service_Territory_Code__c = '04892';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            
            
            Asset ast = new Asset();
            ast.Name = '79788868';
            ast.Warranty_Start_Date__c = date.today();
            ast.Make__c = 'AUTOCAR';
            ast.Type_PSN__c = 'Engines-79788868';
            ast.Service_Model__c = 'ISL G CM2180';
            ast.VIN__c = '5VCACLLE0CH213818';
            ast.Product_Application_Code__c = '10';
            ast.Unit_Number__c = '789';
            ast.Model__c = 'Test';
            ast.VIN__c = 'dsnflksdjlksd';
            ast.Service_Model__c = 'ISX CM570';
            ast.Application_Code__c = '12';
            ast.FSL_Site__c = addr.id;//CT2-416
            ast.AccountId = acc.Id;
            ast.Type__c = 'Products';
            insert ast;
            
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
            Schema.Address addr2 = new Schema.Address();
            addr2.FSL_Site_ID__c = '49';
            addr2.Street = '345 Dr';
            addr2.City = 'Brisbane';
            addr2.State = 'South Australia';
            addr2.Country = 'Australia';
            addr2.FSL_Tax_District__c ='';
            
            addr2.PostalCode = '5000093';
            addr2.Latitude = 70.0;
            addr2.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addr2.ParentId = loc.Id;
            addr2.Account__c = acc.Id;
            insert addr2;
            
            WorkOrder wo = new WorkOrder();
            wo.WorkTypeId = wt.id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Shop_Work_Order__c = '75148';
            wo.CSS_Hours__c = 12;
            wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
            wo.Process_Step__c = 'Intake';
            wo.Make__c = 'AUTOCAR12';
            wo.Model__c = 'Test2';
            wo.FSL_Make_Model_Flag__c = TRUE;
            //wo.Asset = ast;
            wo.AssetId = ast.Id;
            wo.AccountId = acc.Id;
            wo.ContactId = con.Id;
            wo.Scheduled__c = true;
            wo.CreatedDate = system.now().addDays(-29);
            wo.Available_for_Service__c = system.now().addDays(10);
            wo.FSL_Sub_Type__c = subTypeInfo.id;
            wo.Repair_Location__c = 'Mobile';
          //  wo.Repair_Site_Address__c = addr2.Id;
            wo.Purchase_Order__c = 'Testing';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.Payer__c = acc.Id;
            wo.Status = 'Intake';
            insert wo;
            
            
            FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
            objstage.Manufacturer__c = wo.Make__c;
            objstage.ModelSeries__c = wo.Model__c;
            objstage.ProductApplicationCode__c = ast.Product_Application_Code__c;
            objstage.PSN__c = ast.Name;
            objstage.Type_PSN__c = 'Engines-79788868';
            insert objstage;
            
            list < FSL_MakeModel_Stage__c > lstFsl = new list < FSL_MakeModel_Stage__c > ();
            FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
            objMakeModelstg.ModelSeries__c = 'test';
            objMakeModelstg.PSN__c = 'test';
            objMakeModelstg.Manufacturer__c = 'test';
            objMakeModelstg.Type_PSN__c = 'Engines-797888682';
            lstFsl.add(objMakeModelstg);
            insert lstFsl;
            
            system.debug('** WO' + wo);
            system.debug('** wo assert' + ast);
            system.debug('** wo assert id' + wo.Asset);
            system.debug('wo make' + wo.Make__c + 'wo model' + wo.Model__c + 'wo assert' + wo.Asset.Make__c + 'wo assert model' + wo.Asset.Model__c);
            ERP_Message__c erpMessage = new ERP_Message__c();
            erpMessage.Service_Order__c = wo.id;
            erpMessage.Payer_Change__c = true;
            erpMessage.Customer_Credit_Message__c = '{"DataArea":{"CustomerNumber":"131SERV","CreditMessageDetails":[{"CreditMessage":"","CreditMessageCode":"N"},{"CreditMessage":"","CreditMessageCode":""}]},"Header":{"Sender":{"ServiceName":"GetCustomerCreditMessage","SenderID":"CSS","MessageID":"c4d02883-2ef9-453c-b496-e5d182999d22"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
            insert erpMessage;
            
            List < CSS_Integration_Details__c > conDetails = new List < CSS_Integration_Details__c > ();
            CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
            conDetail.Name = 'OAGOAuth';
            conDetail.Username__c = 'Testing';
            conDetail.Passcode__c = '74784848Test';
            conDetail.End_Point__c = 'https://test.Com/gettoken';
            conDetails.add(conDetail);
            
            CSS_Integration_Details__c conDetail2 = new CSS_Integration_Details__c();
            conDetail2.Name = 'FSL_JobContactInfo';
            conDetail2.Username__c = 'Testing';
            conDetail2.Passcode__c = '7484488Testing';
            conDetail2.End_Point__c = 'https://test.Com/csswarranty/csscontact';
            conDetails.add(conDetail2);
            
            CSS_Integration_Details__c conDetail3 = new CSS_Integration_Details__c();
            conDetail3.Name = 'FSL_InBoundServiceRequest';
            conDetail3.Username__c = 'Testing';
            conDetail3.Passcode__c = '7484488Testing';
            conDetail3.End_Point__c = 'https://test.Com/css/bmsunit';
            // insert conDetail3;
            conDetails.add(conDetail3);
            
            CSS_Integration_Details__c conDetail4 = new CSS_Integration_Details__c();
            conDetail4.Name = 'FSL_SiteInfo';
            conDetail4.Username__c = 'Testing';
            conDetail4.Passcode__c = '7484488Testing';
            conDetail4.End_Point__c = 'https://test.Com/csswarranty/csssite';
            conDetails.add(conDetail4);
            
            CSS_Integration_Details__c conDetail5 = new CSS_Integration_Details__c();
            conDetail5.Name = 'BMSCustomer';
            conDetail5.Username__c = 'Testing';
            conDetail5.Passcode__c = '7484488Testing';
            conDetail5.End_Point__c = 'https://test.Com/bmsworkorder';
            //insert conDetail2;
            conDetails.add(conDetail5);
            insert conDetails;
            
            FSL_Switch__c MWSwitch = new FSL_Switch__c();
            MWSwitch.Name = 'MWErrors_Switch';
            MWSwitch.IsActive__c = true;
            insert MWSwitch;
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_StatusUpdate.checkCustomerMessageCode(wo.id);
            FSL_StatusUpdate.getWorkOrder(wo.id);
             FSL_StatusUpdate.updateWorkOrder(wo);
            FSL_StatusUpdate.insertMakeModelStaging(wo.id);
            FSL_StatusUpdate.doCallUpdateWorkOrder(wo.id);
                
            Test.stopTest();
        }
    }
    
    @isTest
    public static void fslTestWithIntakeCmplte_MOVEX_Test() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345',ERP__c = 'MOVEX');
       
        insert u;
        u.ERP__C = 'MOVEX';
        system.runAs(u) {
            FSL_StatusUpdate.fetchUser();
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '';
            acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
            
            Account acc1 = populateAccount(FALSE);
            acc1.BillingStreet = '1466 N National Rd';
            acc1.BillingCity = 'Columbus';
            acc1.BillingState = 'Indiana';
            acc1.BillingCountry= 'United States';
            acc1.BillingPostalCode = '47201';
            acc1.Email_Notification_Frequency__c = 'Nightly';
            acc1.FSL_ERP_Customer_Code__c = '';
            acc1.FSL_Source_ERP__c = 'BMS';
            insert acc1; 
            
            List < Contact > conList = new List < Contact > ();
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con = new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName = 'Steve Test';
            con.LastName = 'Johnson';
            con.Phone = '1234567890';
            con.AccountId = acc.id;
            con.FSL_Contact_Id__c = '1';
            
            conList.add(con);
            
            Contact payerCon = new Contact();
            payerCon.RecordTypeId = conRecId;
            payerCon.FirstName = 'Steve';
            payerCon.LastName = 'Johnson';
            payerCon.Phone = '1234567890';
            payerCon.AccountId = acc.id;
            payerCon.FSL_Contact_Id__c = '1';
            conList.add(payerCon);
            
            insert conList;
            
            OperatingHours oh = new OperatingHours();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            WorkType wt = new WorkType();
            wt.Name = 'Test work type';
            wt.EstimatedDuration = 60.00;
            insert wt;
            
            ServiceTerritory sT = new ServiceTerritory();
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '03520-04892';
            sT.FSL_Service_Territory_Code__c = '04892';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            //create location //CT2-416
            Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acc.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;

            //create Address //CT2-416
            Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addressObj.ParentId = locationObj.Id;
            addressObj.Account__c = acc.Id;
            
            insert addressObj;
            
            Asset ast = new Asset();
            ast.Name = '79788868';
            ast.Warranty_Start_Date__c = date.today();
            ast.Make__c = 'AUTOCAR';
            ast.Type_PSN__c = 'Engines-79788868';
            ast.Service_Model__c = 'ISL G CM2180';
            ast.VIN__c = '5VCACLLE0CH213818';
            ast.Product_Application_Code__c = '10';
            ast.Unit_Number__c = '789';
            ast.Model__c = 'Test';
            ast.VIN__c = 'dsnflksdjlksd';
            ast.Service_Model__c = 'ISX CM570';
            ast.Application_Code__c = '12';
            ast.FSL_Site__c = addressObj.id;//CT2-416 
            ast.AccountId = acc.Id;
            ast.ContactId = con.Id;
            ast.Type__c = 'Engines';
            insert ast;
            
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
            //Added test.start test for governor limits - Rama
            Test.startTest();
            WorkOrder wo = new WorkOrder();
            wo.WorkTypeId = wt.id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Shop_Work_Order__c = '';
            wo.CSS_Hours__c = 12;
            wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
            wo.Process_Step__c = 'Intake';
            wo.Make__c = 'AUTOCAR12';
            wo.Model__c = 'Test2';
           // wo.Asset = ast;
            wo.AssetId = ast.Id;
            wo.AccountId = acc.Id;
            wo.ContactId = con.Id;
            wo.Scheduled__c = true;
            wo.CreatedDate = system.now().addDays(-29);
            wo.Available_for_Service__c = system.now().addDays(10);
            wo.FSL_Sub_Type__c = subTypeInfo.id;
            wo.Repair_Location__c = 'Mobile';
            wo.Purchase_Order__c = 'Testing';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.Payer__c = acc.Id;
            wo.Status = 'Intake Complete';
            wo.Payer_ContactID__c = payerCon.Id;
           // wo.Repair_Site_Address__c = addressObj.Id;
            insert wo;
            
            
            FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
            objstage.Manufacturer__c = wo.Make__c;
            objstage.ModelSeries__c = wo.Model__c;
            objstage.ProductApplicationCode__c = ast.Product_Application_Code__c;
            objstage.PSN__c = ast.Name;
            objstage.Type_PSN__c = 'Engines-797888682';
            insert objstage;
            
            list < FSL_MakeModel_Stage__c > lstFsl = new list < FSL_MakeModel_Stage__c > ();
            FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
            objMakeModelstg.ModelSeries__c = 'test';
            objMakeModelstg.PSN__c = 'test';
            objMakeModelstg.Manufacturer__c = 'test';
            objMakeModelstg.Type_PSN__c = 'Engines-79788868';
            lstFsl.add(objMakeModelstg);
            insert lstFsl;
            
            system.debug('** WO' + wo);
            system.debug('** wo assert' + ast);
            system.debug('** wo assert id' + wo.Asset);
            system.debug('wo make' + wo.Make__c + 'wo model' + wo.Model__c + 'wo assert' + wo.Asset.Make__c + 'wo assert model' + wo.Asset.Model__c);
            ERP_Message__c erpMessage = new ERP_Message__c();
            erpMessage.Service_Order__c = wo.id;
            erpMessage.Payer_Change__c = true;
            erpMessage.Customer_Credit_Message__c = '{"DataArea":{"CustomerNumber":"131SERV","CreditMessageDetails":[{"CreditMessage":"","CreditMessageCode":"N"},{"CreditMessage":"","CreditMessageCode":""}]},"Header":{"Sender":{"ServiceName":"GetCustomerCreditMessage","SenderID":"CSS","MessageID":"c4d02883-2ef9-453c-b496-e5d182999d22"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
            insert erpMessage;
            
            List < CSS_Integration_Details__c > conDetails = new List < CSS_Integration_Details__c > ();
            CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
            conDetail.Name = 'OAGOAuth';
            conDetail.Username__c = 'Testing';
            conDetail.Passcode__c = '74784848Test';
            conDetail.End_Point__c = 'https://test.Com/gettoken';
            conDetails.add(conDetail);
            
            CSS_Integration_Details__c conDetail2 = new CSS_Integration_Details__c();
            conDetail2.Name = 'FSL_JobContactInfo';
            conDetail2.Username__c = 'Testing';
            conDetail2.Passcode__c = '7484488Testing';
            conDetail2.End_Point__c = 'https://test.Com/csswarranty/csscontact';
            conDetails.add(conDetail2);
            
            CSS_Integration_Details__c conDetail3 = new CSS_Integration_Details__c();
            conDetail3.Name = 'FSL_InBoundServiceRequest';
            conDetail3.Username__c = 'Testing';
            conDetail3.Passcode__c = '7484488Testing';
            conDetail3.End_Point__c = 'https://test.Com/css/bmsunit';
            // insert conDetail3;
            conDetails.add(conDetail3);
            
            CSS_Integration_Details__c conDetail4 = new CSS_Integration_Details__c();
            conDetail4.Name = 'FSL_SiteInfo';
            conDetail4.Username__c = 'Testing';
            conDetail4.Passcode__c = '7484488Testing';
            conDetail4.End_Point__c = 'https://test.Com/csswarranty/csssite';
            conDetails.add(conDetail4);
            
            CSS_Integration_Details__c conDetail5 = new CSS_Integration_Details__c();
            conDetail5.Name = 'BMS';
            conDetail5.Username__c = 'Testing';
            conDetail5.Passcode__c = '7484488Testing';
            conDetail5.End_Point__c = 'https://test.Com/bmsworkorder';
            //insert conDetail2;
            conDetails.add(conDetail5);
            insert conDetails;
            
            CSS_Integration_Details__c conDetails6 = new CSS_Integration_Details__c();
            conDetails6.End_Point__c = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi-customers/contact';
            conDetails6.Passcode__c = 'faMaybrRymfn2y1WsujVuenuWFUW40H9m/277vM9gEi5h/CobsQkBCpGuxU/bZqfVypNQSGyuPQgCp5TrujLiQ==';
            conDetails6.Username__c = 'kOlPsxqWLAmrTLWTAEYHRs32PCN+htEsW47RbB0W8i4RQyqvcKIl9EkdAkW9qfrL5virpVrJ9VK/Ob1yKBmL5w==';
            conDetails6.Name = 'FSL_JobContactInfo';
            conDetails6.ApplicationName__c='FSL_JobContactInfo';
            conDetails6.Key__c='Ucob3wbjkcu3w4tIFlrGyvKC44gUviJGCgdM7ydnvbk=';
            conDetails6.AuthEnv__c='MuleAuth';
            conDetails6.Method_Type__c='POST';
            conDetails6.IsActive__c=true;
            insert conDetails6;

            FSL_Switch__c MWSwitch = new FSL_Switch__c();
            MWSwitch.Name = 'MWErrors_Switch';
            MWSwitch.IsActive__c = true;
            insert MWSwitch;

            FSL_StatusUpdate.addEscapeChar(' \\\\ ');
            FSL_StatusUpdate.addEscapeChar(' "" ');
            FSL_StatusUpdate.addEscapeChar(' \r\n ');

            FSL_StatusUpdate.getCustomMetaDataTypesForErrors('OSB-382500');
            FSL_StatusUpdate.getCustomMetaDataTypesForErrors('Invalid-OSB-12345');
            

            FSL_CreateCustomer.CallOutResponseWrap Accwrap = new FSL_CreateCustomer.CallOutResponseWrap();
            Accwrap.accObj = acc;
            FSL_CreateCustomer.CallOutResponseWrap Accwrap1 = new FSL_CreateCustomer.CallOutResponseWrap();
            Accwrap1.accObj = acc1;
            wo.Account = acc;
            wo.Payer__r = acc1;
            FSL_JobContactInfo.CallOutResponseWrap wrap = new FSL_JobContactInfo.CallOutResponseWrap();
            wrap.conObj = con;
            FSL_JobContactInfo.CallOutResponseWrap wrap1 = new FSL_JobContactInfo.CallOutResponseWrap();
            wrap1.conObj = payerCon;
            FSL_CL_SiteCreateUpdate.CallOutResponseWrap siteWrap = new FSL_CL_SiteCreateUpdate.CallOutResponseWrap();
            siteWrap.siteObj = addressObj;//CT2-416
            FSLInBoundService.CallOutResponseWrap asstWrap = new FSLInBoundService.CallOutResponseWrap();
            asstWrap.asstObj = ast;

            FSL_StatusUpdate.onContactCheckFail(wo, acc, acc1, Accwrap, Accwrap1);
            FSL_StatusUpdate.onPayerContactCheckFail(wo, acc, acc1, con, Accwrap, Accwrap1, wrap);
            FSL_StatusUpdate.onSiteCheckFail(wo, acc, acc1, con, payerCon, Accwrap, Accwrap1, wrap, wrap1);
            FSL_StatusUpdate.onAssetCheckFail(wo, acc, acc1, con, payerCon, addressObj, Accwrap, Accwrap1, wrap, wrap1, siteWrap);//CT2-416
            WorkOrder wo1 = [SELECT Id,WorkOrderNumber,ServiceTerritoryId,Shop_Work_Order__c,CSS_Hours__c,Branch_Code__c,Process_Step__c,
                             Make__c,Model__c,AssetId,AccountId,ContactId,Scheduled__c,Available_for_Service__c,FSL_Sub_Type__c,
                             Repair_Location__c,Purchase_Order__c,CreatedDate,Application__c,Payer__c,Status,Payer_ContactID__c,
                             FSL_Make_Model_Flag__c,ServiceTerritory.Location_Code__c,Contract_Number__c,MaintenancePlanNumber__c,Failure_Date__c,
                             FSL_Sub_Type__r.Name,General_Symptoms__c,Asset.Individual__c,Asset.Engine_Manufacturer__c,
                             Payer_ContactID__r.FSL_Contact_Id__c,Account.FSL_ERP_Customer_Code__c,Contact.FSL_Contact_Id__c,
                             Contact.firstName,Contact.lastname,Contact.phone,Contact.email,payer__r.fsl_erp_customer_code__c,Repair_Site_Address__c
                             FROM WORKORDER WHERE Id=:wo.Id LIMIT 1];
            
            //Test.stopTest();

            //Test.startTest();

            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_StatusUpdate.checkCustomerMessageCode(wo.id);
           	FSL_StatusUpdate.getWorkOrder(wo.id);
            FSL_StatusUpdate.updateWorkOrder(FSL_StatusUpdate.getWorkOrder(wo.id));
            FSL_StatusUpdate.processStepUpdateWO(wo1);
			FSL_StatusUpdate.calloutCommentInbound(wo1.Id);
//            FSL_StatusUpdate.insertMakeModelStaging(wo.id);
//            FSL_StatusUpdate.doCallUpdateWorkOrder(wo.id);
            Test.stopTest();
        }
    }
}