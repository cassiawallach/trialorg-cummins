@isTest
public class CSS_SendJobInfo_Test {
    
    Static User adminUser = new User();
    Static User user1 = new User();
    Static String recordType_Id = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId(); 
    Id p1 = [select id from profile where name='CSS_Dealer_Data_ExChange_Admin'].id;
    
    @testSetup
    Static void createTestData(){
        
        adminUser = CSS_TestData.createTestUser(true);
        //adminUser.Username ='kasfjdksjfkajfdsk@abcsj.com'; 
        if(adminUser.Id != null)
            update adminUser;
        Account acc;
        Contact con;
        List<Account> accList = new List<Account>();
        
        // Creating test data
        system.runAs(adminUser){
            
            //Negative use case
            RestRequest request = new RestRequest();
            request.addHeader('Content-Type', 'application/json');
            //request.requestUri ='https://cumminscss--cssbrkfx.cs54.my.salesforce.com/services/apexrest/SendJobInfo/';
            request.requestUri ='https://cumminscss--cssbrkfx.my.salesforce.com/services/apexrest/DataXSOCreateUpdate/';
            request.httpMethod = 'POST';
              String myJSON1 = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "56270","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "56270","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';

            request.requestBody = Blob.valueOf(myJSON1);

            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow = CSS_SendJobInfo.sendJobInformation();
            // Create Account Test data  
            // Added type ='Distributor Account' by Priyanka for look up filter of parent account
            acc = new Account(Name='parentAccount',type ='Distributor Account', CSS_DistributorCode__c='1111', IAM_Service_Provider_Code__c='56270',RecordTypeId=recordType_Id,Data_Exchange_Enabled__c=true,Vehicle_Unit_Data_Send_to_CSS__c=true,Customer_Data_Send_to_CSS__c=true,ESN_Service_History_Send_to_CSS__c=true);
            insert acc;
            accList.add(new Account(Name='childAccount1',Parentid=acc.id, CSS_DE_Parent__c=acc.Id, IAM_Service_Provider_Code__c='88976',RecordTypeId=recordType_Id));
            accList.add(new Account(Name='childAccount2',Parentid=acc.id, CSS_DE_Parent__c=acc.Id,CSS_DistributorCode__c='02860',
                                    Data_Exchange_Enabled__c=true,Customer_Data_Send_to_CSS__c=true,RecordTypeId=recordType_Id,
                                    Vehicle_Unit_Data_Send_to_CSS__c=true,ESN_Service_History_Send_to_CSS__c=true));
            insert accList;
            //Create contact Test data 
            con = new Contact(LastName = 'Daniel', AccountId = acc.Id,Email = 'lakshmi.p@gmail.com',IAM_Cummins_login_ID__c='testcon.lakshmi@truck.com',CMI_Contact_Type__c = 'Secondary',IAM_Contact_Status__c = 'Active',FirstName ='lakshmi',Phone='000-000-0000');
            //insert con; 
        }
        //user1 = CSS_TestData_WithoutSharing.getTestUser(true, 'testUser1', con.Id);
    }
    
  /*  static testmethod void testSendJobInfoPosVal(){
      //createTestData();
        list<User> userlist = new list<User>();
        Profile p = [Select Id,Name from Profile where Name = 'CSS_Dealer_Data_ExChange_Admin']; 
        //UserRole empRole = [Select Id From UserRole Where Name = 'Dealer New Customer User' Limit 1];
        UserRole empRole = [Select Id From UserRole limit 1];// Where PortalType = 'CustomerPortal' Limit 1];
        Contact con = new Contact(LastName = 'prasu123',Email = 'prasu.p@gmail.com',IAM_Cummins_login_ID__c='testcon.lakshmi@truck.com',CMI_Contact_Type__c = 'Secondary',IAM_Contact_Status__c = 'Active',FirstName ='prasu',Phone='000-000-0000');
            insert con; 
         User user1 = new User(
            Username = System.now().millisecond() + 'prashanthi'+ 'test@test.com',
           //ContactId=con.id,
            ProfileId = p.Id,
             contactid=con.id,
            UserRoleId = empRole.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing',//testLastName,
            CommunityNickname = 'prashanthi'+'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
             isActive=true
        );
        userlist.add(user1);
        //insert userlist;
        List<User> userList1 = [SELECT LastName FROM User WHERE LastName='Testing' and isActive=true];        
        system.runAs(userList1[0]){
            Test.startTest();            
            // Set up a test request
            RestRequest request = new RestRequest();
            request.addHeader('Content-Type', 'application/json');
            request.requestUri ='https://cumminscss--cssbrkfx.cs54.my.salesforce.com/services/apexrest/SendJobInfo/';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;          
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow = CSS_SendJobInfo.sendJobInformation();
            
            //test exception by putting non-existant field in header
            request.requestBody = Blob.valueOf('{"Header": {"SAMPLEFIELD":"SAMPLE","ServiceName": "SendJobInfo","ServiceVersion": "1.1","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "od385","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;          
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjown = CSS_SendJobInfo.sendJobInformation();
            
            //null ServiceName
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": null,"ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;                      
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow1 = CSS_SendJobInfo.sendJobInformation();
            
            //null ToolID
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": null,"SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;                      
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow2 = CSS_SendJobInfo.sendJobInformation();
            
            //null SPCode
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": null,"SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;                      
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow3 = CSS_SendJobInfo.sendJobInformation();    
            
            //invalid user coverage
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;               
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow4 = CSS_SendJobInfo.sendJobInformation(); 
            
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;                   
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow5 = CSS_SendJobInfo.sendJobInformation();   

            //update accList;
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;                      
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow6 = CSS_SendJobInfo.sendJobInformation(); 
                        
            Test.stopTest();    
        }
    }*/
       
    static testmethod void testSendJobInfoPos(){
        //createTestData();
        List<User> userList = [SELECT LastName FROM User WHERE LastName='Testing' and isActive=true]; 
        //Account accFrighetLiner = [SELECT id,name FROM Account where Name='Parent Account' Limit 1]; 
        //Contact contactwithAcc = [SELECT id,name FROM Contact where AccountId=:accFrighetLiner.id Limit 1];
        //User user1 = [SELECT id,LastName,Username FROM User WHERE ContactId=:contactwithAcc.id Limit 1]; 
        CSS_Job_Order__c jobInfo = new CSS_Job_Order__c();   
         jobInfo.JobLocation__c = '29550-29550';
            
         //jobInfo.Account__c = accFrighetLiner.id;   
         jobInfo.Status__c = 'Intake';   
         jobInfo.Data_Exchange_Enabled__c = true;   
                    insert jobInfo; 
        system.runAs(userList[0]){            
            Test.startTest();            
            List<Contact> cons = new List<Contact>();
            List<Account> accList = [SELECT Id, Name,Data_Exchange_Enabled__c FROM Account WHERE Name LIKE 'childAccount2'];
            for(Account acc : accList){
                cons.add(new Contact(LastName='contact'+acc.Name, AccountId=acc.Id,Email = 'lakshmi.p@gmail.com',CMI_Contact_Type__c = 'Secondary',IAM_Contact_Status__c = 'Active',IAM_Cummins_login_ID__c='testcon.lakshmi@truck.com',FirstName ='lakshmi',Phone='000-000-0000'));
            }
            //insert cons;            
            
            //CSS_TestData_WithoutSharing.getTestUser(true, 'testUserChild', cons[0].Id, 'CSS_Dealer_Advanced');          
            // Set up a test request
            
            RestRequest request = new RestRequest();
            request.addHeader('Content-Type', 'application/json');
            request.requestUri ='https://cumminscss--cssbrkfx.cs54.my.salesforce.com/services/apexrest/SendJobInfo/';
            request.httpMethod = 'POST';
            String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "22322","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "22322","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": 1"","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            request.requestBody = Blob.valueOf(myJSON);                  
            RestContext.request = request;
            String myJSON1 = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "56270","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "56270","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "1","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            CSS_SendJobInfoResWrapper sendjow = CSS_SendJobInfo.sendJobInformation();
            request.requestBody = Blob.valueOf(myJSON1);                  

            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjows = CSS_SendJobInfo.sendJobInformation();  
            CSS_SendJobInfo.grantShareServJobs(userList[0].Id, jobInfo.Id, 'cause');
            Test.stopTest();   
        }
    }
    
    static testmethod void grantShareServJobsmethod(){
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
        //String id = String.valueOf(jo.id);
        test.startTest();
        CSS_SendJobInfo.grantShareServJobs(jo.id,jo.id,'rowCause');
        test.stopTest();
        
    }

    static testmethod void testSendJobInfoPosVal1(){ 
            //createTestData();
           // Account accFrighetLiner = [SELECT id,name FROM Account where Name='childAccount1' Limit 1]; 
            //Contact contatwithAcc = [SELECT id,name FROM Contact where AccountId=:accFrighetLiner.id Limit 1];     
        User user1 = [SELECT id,LastName,Username FROM User WHERE LastName='Testing' and isActive=true LIMIT 1];//WHERE ContactId=:contactwithAcc.id Limit 1];     
           // system.runAs(user1){ 
                
            Test.startTest();            
            // Set up a test request
            RestRequest request = new RestRequest();
            request.addHeader('Content-Type', 'application/json');
            request.requestUri ='https://cumminscss--cssbrkfx.cs54.my.salesforce.com/services/apexrest/DataXSOCreateUpdate/';
            request.httpMethod = 'POST';
            String myJSON1 = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "56270","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "56270","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "1","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            request.requestBody = Blob.valueOf(myJSON1);                  
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow = CSS_SendJobInfo.sendJobInformation();
            String myJSON2 = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "56270","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "56270","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "1","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';

            //test exception by putting non-existant field in header
            request.requestBody = Blob.valueOf(myJSON2);                  
            RestContext.request = request;
                try{
                    CSS_SendJobInfoResWrapper sendjown = CSS_SendJobInfo.sendJobInformation();
                }
                Catch(Exception e){
                    
                }
            
            //null ServiceName
            String myJSON3 = '{"Header": {"ServiceName": "","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "56270","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "56270","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';

            request.requestBody = Blob.valueOf(myJSON3);
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow1 = CSS_SendJobInfo.sendJobInformation();
            
            //null ToolID
            String myJSON4 = '{"Header": {"ServiceName": "","ToolID": "","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "56270","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "56270","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';

            request.requestBody = Blob.valueOf(myJSON4);
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow2 = CSS_SendJobInfo.sendJobInformation();
            
            //null SPCode
            String myJSON5 = '{"Header": {"ServiceName": "","ToolID": "","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            request.requestBody = Blob.valueOf(myJSON5);
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow3 = CSS_SendJobInfo.sendJobInformation();    
            
            //invalid user coverage
            String myJSON6 = '{"Header": {"ServiceName": "","ToolID": "","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
                
            request.requestBody = Blob.valueOf(myJSON5);
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow4 = CSS_SendJobInfo.sendJobInformation(); 
                
            
            Test.stopTest();   
    //}
       
}

 /*   static testmethod void testSendJobAccount1(){
        
        User usr = [select id from User where accountid!=null limit 1];
        System.runAs ( usr ) {
            Test.startTest();            
            // Set up a test request
            RestRequest request = new RestRequest();
            request.addHeader('Content-Type', 'application/json');
            request.requestUri ='https://cumminscss--cssbrkfx.cs54.my.salesforce.com/services/apexrest/SendJobInfo/';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;          
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow = CSS_SendJobInfo.sendJobInformation();
            
            //test exception by putting non-existant field in header
            request.requestBody = Blob.valueOf('{"Header": {"SAMPLEFIELD":"SAMPLE","ServiceName": "SendJobInfo","ServiceVersion": "1.1","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "od385","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;          
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjown = CSS_SendJobInfo.sendJobInformation();
            
            //null ServiceName
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": null,"ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;                      
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow1 = CSS_SendJobInfo.sendJobInformation();
            
            //null ToolID
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": null,"SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;                      
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow2 = CSS_SendJobInfo.sendJobInformation();
            
            //null SPCode
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": null,"SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;                      
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow3 = CSS_SendJobInfo.sendJobInformation();    
            
            //invalid user coverage
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;               
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow4 = CSS_SendJobInfo.sendJobInformation(); 
            
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;                   
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow5 = CSS_SendJobInfo.sendJobInformation();   

            //update accList;
            request.requestBody = Blob.valueOf('{"Header": {"ServiceName": "SendJobInfo","ServiceVersion": "1.0","ToolID": "Dealer Work Order","SPCode": "56270","SenderID": "testcust","TargetID": "CSS"},"DataArea": {"CUST_DATA": {"CustomerName": "TestCustomer","DateAvailService": "2017-01-06","ShopWO": "WO9876"},"UNIT_DATA": {"PSN": "79464646","UnitNumber": "638839","Application": "Automotive","ServiceModelNM": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "TRUE","FailureDate": "2017-01-06","MileageOrKms": "20000","MileageMeasure": "<Miles/KM>","Hours": "40"},"SERVICEHIST": [{"Source": "123","JobDate": "2017-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "20000","MileageMeasure": "<Miles/KM/Hours>"}, {"Source": "123","JobDate": "2016-01-06","CustomerName": "FDNY","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "32456-02456","WorkSummary": "<what was done during this Job>","FaultCodeSymptom": "<Fault Codes resolves/work on>","Mileage": "40000","MileageMeasure": "<Miles/KM/Hours>"}]}}') ;                      
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow6 = CSS_SendJobInfo.sendJobInformation(); 
            Test.stopTest();   
        }
    }*/
    
    
    static testmethod void testSendJobAccountNegative(){
        
        Id p = [select id from profile where name='CSS_Dealer_Advanced'].id;
        
        Account A = new Account();
        A.Name = 'OEM-DTNA HQ';
        A.BillingCity = 'City';
        A.BillingStreet = 'Street';
        A.BillingCountry = 'Canada';
        A.Data_Exchange_Enabled__c = true;
        insert A;
        
        Contact con = new Contact(LastName ='testCon',AccountId = A.Id, firstname = 'testing', IAM_Cummins_login_ID__c = 'test@cummins.com');
        insert con;
        
        
        User user = new User(alias = 'test123', email='test123@noemail.com',
                             emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                             localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                             ContactId = con.Id,
                             timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert user;
        
        User U = [ SELECT id, accountid, ContactId, profileid, IsActive from user where username='tester@noemail.com'];
        system.debug('userMir'+U);
        
        
        system.runAs(U){
            
            
            Account acc1 = new Account();
            Acc1.Name = 'test';
            acc1.css_de_parent__c = A.id;
            Acc1.BillingCity = 'City';
            Acc1.BillingStreet = 'Street';
            Acc1.BillingCountry = 'Canada';
            Acc1.BillingPostalCode = '90001';
            acc1.RecordTypeId=recordType_Id;
            acc1.IAM_Service_Provider_Code__c = '24676';
            acc1.Data_Exchange_Enabled__c = true;
            acc1.Customer_Data_Send_to_CSS__c = true;
            acc1.Vehicle_Unit_Data_Send_to_CSS__c = true;
            acc1.ESN_Service_History_Send_to_CSS__c = true;
            insert acc1;
            System.debug('acc1------->'+acc1); 
            
            list<account> acctlist1=[select id,name,css_de_parent__c from account];
            system.debug('acctlist1>>'+acctlist1);
            
            Contact con1 = new Contact(LastName ='testCon',AccountId = acc1.Id);
            insert con1;
            
            
            Test.startTest();            
            RestRequest request = new RestRequest();
            request.addHeader('Content-Type', 'application/json');
            request.requestUri ='https://cumminscss--cssbrkfx.cs54.my.salesforce.com/services/apexrest/DataXSOCreateUpdate/';
            request.httpMethod = 'POST';
            String myJSON1 = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "56270","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "56270","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles","Hours":"40"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            
            request.requestBody = Blob.valueOf(myJSON1);
            
            RestContext.request = request;
            try{
                CSS_SendJobInfoResWrapper sendjow = CSS_SendJobInfo.sendJobInformation();
            }
            Catch(Exception e){
                System.debug('-----exception'+e.getMessage());
            }
            Test.stopTest(); 
            
        }
    }
    
    static testmethod void testSendJobInfoNegative(){ 
        //createTestData();
        // Account accFrighetLiner = [SELECT id,name FROM Account where Name='childAccount1' Limit 1]; 
        //Contact contactwithAcc = [SELECT id,name FROM Contact where AccountId=:accFrighetLiner.id Limit 1];     
        User user1 = [SELECT id,LastName,Username FROM User WHERE LastName='Testing' and isActive=true LIMIT 1];//WHERE ContactId=:contactwithAcc.id Limit 1];     
        system.runAs(user1){ 
            Test.startTest();            
            // Set up a test request
            RestRequest request = new RestRequest();
            request.addHeader('Content-Type', 'application/json');
            request.requestUri ='https://cumminscss--cssbrkfx.cs54.my.salesforce.com/services/apexrest/DataXSOCreateUpdate/';
            request.httpMethod = 'POST';
            String myJSON1 = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "56270","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "56270","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            request.requestBody = Blob.valueOf(myJSON1);                  
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow = CSS_SendJobInfo.sendJobInformation();
            
            String myJSON2 = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "56270","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "56270","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';

            //test exception by putting non-existant field in header
            request.requestBody = Blob.valueOf(myJSON2);                  
            RestContext.request = request;
                try{
                    CSS_SendJobInfoResWrapper sendjown = CSS_SendJobInfo.sendJobInformation();
                }
                Catch(Exception e){
                    
                }
            
            Test.stopTest();   
        }
        
    }
    static testmethod void testSendJobInfoNegative1(){ 
        //createTestData();
        // Account accFrighetLiner = [SELECT id,name FROM Account where Name='childAccount1' Limit 1]; 
        //Contact contactwithAcc = [SELECT id,name FROM Contact where AccountId=:accFrighetLiner.id Limit 1];     
        User user1 = [SELECT id,LastName,Username FROM User WHERE LastName='Testing' and isActive=true LIMIT 1];//WHERE ContactId=:contactwithAcc.id Limit 1];     
        system.runAs(user1){ 
            Test.startTest();            
            // Set up a test request
            RestRequest request = new RestRequest();
            request.addHeader('Content-Type', 'application/json');
            request.requestUri ='https://cumminscss--cssbrkfx.cs54.my.salesforce.com/services/apexrest/DataXSOCreateUpdate/';
            request.httpMethod = 'POST';
            String myJSON1 = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "56270","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
            request.requestBody = Blob.valueOf(myJSON1);                  
            RestContext.request = request;
            CSS_SendJobInfoResWrapper sendjow = CSS_SendJobInfo.sendJobInformation();
            
            String myJSON2 = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "56270","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';

            //test exception by putting non-existant field in header
            request.requestBody = Blob.valueOf(myJSON2);                  
            RestContext.request = request;
                try{
                    CSS_SendJobInfoResWrapper sendjown = CSS_SendJobInfo.sendJobInformation();
                }
                Catch(Exception e){
                    
                }
            
            Test.stopTest();   
        }
        
    }
}