//Added by Krishna for Production Migration
@isTest
public class FSL_receiveSiteInfo_Test {
    
    @isTest
    static void testSiteRequest()
    {
        
        //Profile p = [SELECT Id FROM Profile WHERE Name='CSS Integration'];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'test', Email='standarduser@testorg.com.gdnz', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',ERP__c='BMS', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.gdnz',
                          State = 'Nevada', City = 'Naperville', Country = 'United States', 
                          street = '2526 looking', PostalCode = '12345');
        
        Insert u;
        system.runAs(u) {
            //String myJSON =  '{"Header":{"Status": "Success","Sender":{"ServiceName": "GetSiteInfo","SenderID": "Movex"},"Target": "CSS","Location": " "},"DataArea":[{"DistributorCode": " ","BranchCode": " ","SiteName": "Site A","SiteID": "17","CustomerCode": "1310102","Longitude": " ","Latitude": " ","Address1": "C/ ABELL POINT MARINA ","Address2": "SHINGLEY DR","Address3": "CANNONVALE","City": "AIRLIE BEACH","State": "South Australia","PostalCode": "4802","Country": "Australia","ContactID": "4","ContactName": "ANDY GRADINGER","ContactPhoneNo": "0409 677 209","EmailAddress": "ANDYGRADINGER@EMAIL.COM_TEST","LastUpdatedDate":"2019-05-10T05:23:41","EventFlag":"ADD"}]}';
            String myJSON = '{"Header":{"Status": "Success","Sender":{"ServiceName": "GetSiteInfo","SenderID": "BMS"},"Target": "CSS","Location": " "},"DataArea":[{"DistributorCode": " ","BranchCode": " ","SiteName": "Site A","SiteID": "17","CustomerCode": "1310102","Longitude": "","Latitude": "","Address1": "C/ ABELL POINT MARINA ","Address2": "SHINGLEY DR","Address3": "CANNONVALE","City": "AIRLIE BEACH","State": "South Australia","PostalCode": "4802","Country": "Australia","ContactID": "4","ContactName": "ANDY GRADINGER","ContactPhoneNo": "0409 677 209","EmailAddress": "ANDYGRADINGER@EMAIL.COM_TEST","LastUpdatedDate":"2019-05-10T05:23:41","EventFlag":"ADD"},{"DistributorCode": " ","BranchCode": " ","SiteName": "Site A","SiteID": "4","CustomerCode": "1310102","Longitude": "","Latitude": "","Address1": "C/ ABELL POINT MARINA ","Address2": "SHINGLEY DR","Address3": "CANNONVALE","City": "AIRLIE BEACH","State": "South Australia","PostalCode": "4802","Country": "Australia","ContactID": "4","ContactName": "ANDY GRADINGER","ContactPhoneNo": "0409 677 209","EmailAddress": "ANDYGRADINGER@EMAIL.COM_TEST","LastUpdatedDate":"2019-05-10T05:23:41","EventFlag":"ADD"},{"DistributorCode": " ","BranchCode": " ","SiteName": "Site A","SiteID": "","CustomerCode": "1310102","Longitude":"" ,"Latitude": "","Address1": "C/ ABELL POINT MARINA ","Address2": "SHINGLEY DR","Address3": "CANNONVALE","City": "AIRLIE BEACH","State": "South Australia","PostalCode": "4802","Country": "Australia","ContactID": "4","ContactName": "ANDY GRADINGER","ContactPhoneNo": "0409 677 209","EmailAddress": "ANDYGRADINGER@EMAIL.COM_TEST","LastUpdatedDate":"2019-05-10T05:23:41","EventFlag":"ADD"}]}';
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.FSL_ERP_Customer_Code__c = '1310102';
            acc.Name = 'Test Acc';
            acc.Cmi_account_status__c = 'Active';
            acc.Type = 'Customer';
            //added by Harsha
            acc.FSL_Source_ERP__c = 'BMS';
            insert acc;
            
            
            
            Contact con = new Contact();
            con.FirstName = 'Travis';
            con.LastName = 'Grigg';
            con.AccountId = acc.Id;
            con.FSL_Contact_Id__c = '40';
            con.Phone = '(042) 988-3045';
            con.Email = 'test@test.com';
            con.IAM_Contact_Status__c = 'Inactive';
            con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            // con.IAM_Contact_source__c = 'BMS';
            insert con;
            
            acc.FSL_Source_ERP__c = 'BMS';
            update acc;
            
            Schema.Location loc = new Schema.Location();
            loc.Name  = 'Site A';
            loc.FSL_Contact_ID__c = '2';
            loc.FSL_Account__c = acc.Id;
            insert loc;
            
            Schema.Address siteList = new Schema.Address();
            siteList.parentId = loc.id;
            siteList.FSL_Site_Name__c        = 'Site A';
            siteList.Street      = 'Test';
            siteList.PostalCode      = '47201-4802';
            siteList.FSL_Site_ID__c = '4';
            siteList.Status__c      = 'InActive';
            siteList.ParentId = loc.Id;
            siteList.Account__c = acc.Id;
            insert siteList;
            
            FSL_ERP_Country_Translation__mdt ect=new FSL_ERP_Country_Translation__mdt();
            ect.MasterLabel='Great Britain';
            ect.Country__c='United Kingdom';
            
            RestRequest request = new RestRequest();
            request.requestUri ='https://cs13.salesforce.com/services/apexrest/site/';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueof(myJSON);
            
            RestContext.request = request;
            RestContext.response = new RestResponse();
            FSL_receiveSiteInfo.doPostOperation();
            FSL_SiteDataWrapper.DataAreaVal st = new FSL_SiteDataWrapper.DataAreaVal();
            //string rslt = FSL_receiveSiteInfo.handleSiteRequest(request);
        }
    }
    @isTest
    static void testUpdateSiteRequest()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'test', Email='standarduser@testorg.com.gdnz', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',ERP__c='BMS', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.gdnz',
                          State = 'Nevada', City = 'Naperville', Country = 'United States', 
                          street = '2526 looking', PostalCode = '12345');
        
        Insert u;
        system.runAs(u) {
            
            //String myJSON =  '{"Header":{"Status": "Success","Sender":{"ServiceName": "GetSiteInfo","SenderID": "Movex"},"Target": "CSS","Location": " "},"DataArea":[{"DistributorCode": " ","BranchCode": " ","SiteName": "Site A","SiteID": "2","CustomerCode": "1310102","Longitude": " ","Latitude": " ","Address1": "C/ ABELL POINT MARINA ","Address2": "SHINGLEY DR","Address3": "CANNONVALE","City": "AIRLIE BEACH","State": "South Australia","PostalCode": "4802","Country": "Australia","ContactID": "3","ContactName": "ANDY GRADINGER","ContactPhoneNo": "0409 677 209","EmailAddress": "ANDYGRADINGER@EMAIL.COM","LastUpdatedDate":"2019-05-10T05:23:41","EventFlag":"UPDATE"}]}';
            String myJSON = '{"Header":{"Status": "Success","Sender":{"ServiceName": "GetSiteInfo","SenderID": "Movex"},"Target": "CSS","Location": " "},"DataArea":[{"DistributorCode": " ","BranchCode": " ","SiteName": "Site A","SiteID": "2","CustomerCode": "1310102","Longitude": "","Latitude": "","Address1": "C/ ABELL POINT MARINA ","Address2": "SHINGLEY DR","Address3": "CANNONVALE","City": "AIRLIE BEACH","State": "South Australia","PostalCode": "4802","Country": "Australia","ContactID": "3","ContactName": "ANDY GRADINGER","ContactPhoneNo": "0409 677 209","EmailAddress": "ANDYGRADINGER@EMAIL.COM","LastUpdatedDate":"2019-05-10T05:23:41","EventFlag":"Add"},{"DistributorCode": " ","BranchCode": " ","SiteName": "Site A","SiteID": "3","CustomerCode": "1310102","Longitude": "","Latitude": "","Address1": "C/ ABELL POINT MARINA ","Address2": "SHINGLEY DR","Address3": "CANNONVALE","City": "AIRLIE BEACH","State": "South Australia","PostalCode": "4802","Country": "Australia","ContactID": "3","ContactName": "ANDY GRADINGER","ContactPhoneNo": "0409 677 209","EmailAddress": "ANDYGRADINGER@EMAIL.COM","LastUpdatedDate":"2019-05-10T05:23:41","EventFlag":"Delete"},{"DistributorCode": " ","BranchCode": " ","SiteName": "Site A","SiteID": "6","CustomerCode": "","Longitude": "","Latitude":"","Address1": "C/ ABELL POINT MARINA ","Address2": "SHINGLEY DR","Address3": "CANNONVALE","City": "AIRLIE BEACH","State": "South Australia","PostalCode": "4802","Country": "Australia","ContactID": "3","ContactName": "ANDY GRADINGER","ContactPhoneNo": "0409 677 209","EmailAddress": "ANDYGRADINGER@EMAIL.COM","LastUpdatedDate":"2019-05-10T05:23:41","EventFlag":"UPDATE"}]}';
            Account acc = new Account();
            
            acc.FSL_ERP_Customer_Code__c = '1310102';
            //acc.FSL_ERP_Customer_Code__c = '321';
            acc.Name = 'Test Acc';
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            acc.CMI_Account_Status__c = 'Active';
            acc.Type = 'Customer';
            acc.FSL_Source_ERP__c = 'BMS';
            insert acc;
            
            Contact con = new Contact();
            con.FirstName = 'Travis';
            con.LastName  = 'Grigg';
            con.Phone     = '1234';
            con.Email     = 'test@test.com';
            con.FSL_Contact_Id__c = '2';
            con.AccountId = acc.Id;
            // con.IAM_Contact_source__c = 'BMS';
            con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            insert con;
            FSL_ERP_Country_Translation__mdt ect=new FSL_ERP_Country_Translation__mdt();
            ect.MasterLabel='Great Britain';
            ect.Country__c='United Kingdom';
            
            Schema.Location loc = new Schema.Location();
            loc.Name  = 'Site A';
            loc.FSL_Contact_ID__c = '3';
            loc.FSL_Account__c = acc.Id;
            insert loc;
            
            Schema.Address siteList = new Schema.Address();
            siteList.parentId = loc.id;
            siteList.FSL_Site_Name__c        = 'Site A';
            siteList.Street      = 'Test';
            siteList.PostalCode      = '4802';
            siteList.FSL_Site_ID__c = '3';
            siteList.Status__c      = 'Active';
            siteList.ParentId = loc.Id;
            siteList.Account__c = acc.Id;
            insert siteList;
            
            RestRequest request = new RestRequest();
            request.requestUri ='https://cs13.salesforce.com/services/apexrest/site/';
            request.httpMethod = 'POST';
            request.requestBody = Blob.valueof(myJSON);
            
            RestContext.request = request;
            RestContext.response = new RestResponse();
            FSL_receiveSiteInfo.doPostOperation();
            FSL_SiteDataWrapper.DataAreaVal st = new FSL_SiteDataWrapper.DataAreaVal();
            // FSL_receiveSiteInfo.handleSiteRequest(request);
        }
    }
}