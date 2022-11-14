@IsTest(SeeAllData=false)
public class CSM_IncidentSNOWUpdateQueueable_Test {
    
    public static testmethod void Testmethod_Positive()
    {
         Account accdata = new Account();
        accdata.name = 'Test Account1';
        insert accdata;
        
        Case caseRecdata = new Case();
        caseRecdata.Origin = 'Email';
        caseRecdata.Subject = 'Test';
        caseRecdata.Description = 'testing Data';
        caseRecdata.AccountId=accdata.Id;
        insert caseRecdata;
        List<Incident> inctlist = new List<Incident>();
        Incident incidentRec = new Incident();
        incidentRec.CSM_Ticket_Config_Item__c = 'Middleware';
        incidentRec.Impact = '3';
        incidentRec.Urgency = '3';
        incidentRec.Description = 'Testing';
        incidentRec.CSM_Ticket_Incident_Number__c = 'INC3547273';
        incidentRec.Service_Request__c=caseRecdata.id;
        incidentRec.Status='New';
        incidentRec.Subject='Test Data';
        incidentRec.SNow_Last_Synched_Date__c=System.today();
        inctlist.add(incidentRec);
        Insert inctlist;
        
        
        CSM_SNow_Initiator_wwid__mdt metaFile = new CSM_SNow_Initiator_wwid__mdt();
        metaFile.Service_Request_Origin__c = 'Email';
        metaFile.Initiator_wwid__c = 'OY876';
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        inte.Name = 'FSL_ServiceNow';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'FSL_ServiceNow';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        inte.Method_Type__c = 'POST';
        insert inte;
        
        CSS_Integration_Details__c integrationDetails = new CSS_Integration_Details__c();
        integrationDetails.Name = 'FSL_ServiceNowUpdate';
        integrationDetails.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        integrationDetails.ApplicationName__c = 'FSL_ServiceNowUpdate';
        integrationDetails.End_Point__c = 'abc.com';
        integrationDetails.IsActive__c = true;
        integrationDetails.Method_Type__c = 'POST';
        insert integrationDetails;
        
        CSS_Integration_Details__c integrationDetails5 = new CSS_Integration_Details__c();
        integrationDetails5.Name = 'FSL_ServiceNow_Get';
        integrationDetails5.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails5.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails5.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        integrationDetails5.ApplicationName__c = 'FSL_ServiceNow_Get';
        integrationDetails5.End_Point__c = 'abc.com';
        integrationDetails5.IsActive__c = true;
        integrationDetails5.Method_Type__c = 'GET';
        insert integrationDetails5;
        Test.setMock(HttpCalloutMock.class, new CSM_IncidentSNOWUpdateServiceMock('Success'));
        //IncidentSNOWUpdateService_Test.CSS_DoCalloutTestMethod(); 
        //FSL_SNOWResponsedata_Test.testParse();
       // incidentRec.SNow_Last_Synched_Date__c =Date.newInstance(2022,05,21);
        //incidentRec.Status ='Assigned';
        //update incidentRec;
        CG_OP_OAGWrapper accessTokenOPWrap = CG_WS_Mule.getAccessToken('ad724392-5594-4e85-b9eb-b0fc19c2fabe','CG_GetDiagTargetTime');
        String accessToken=accessTokenOPWrap.accessToken;
        System.debug('accessToken >>>>' + accessToken);
        
        //inctlist.add(incidentRec); 
        CSM_IncidentSNOWUpdateQueueable AppData= new CSM_IncidentSNOWUpdateQueueable(inctlist,accessToken);
        System.enqueueJob(AppData);
        
    }
     /* public static testMethod void testParse() {
        
   String json = '{'+
                '  \"result\": {'+
                '    \"IncidentNumber\": \"INC3558822\",'+
                '    \"Priority\": \"3\",'+
                '    \"Customer\": \"Email User\",'+
                '    \"CustomerWWID\": \"email.user\",'+
                '    \"ShortDescription\": \"Qapla. Dah tlhingan hol mu ghom a dalegh\",'+
                '    \"Category\": \"Application\",'+
                '    \"SubCategory\": \"Repair/Fix\",'+
                '    \"ConfigurationItem\": \"P360-Enterprise Product Data Hub\",'+
                '    \"State\": \"Closed\",'+
                '    \"AssignmentGroup\": \"Common Services - Data Services - MDM Application Support\",'+
                '    \"AssignedTo\": \"Kowsalya R\",'+
                '    \"AssignedToWWID\": \"sy674\",'+
                '    \"IncidentSysID\": \"7816687f1b41c550f1d9ed77624bcba3\",'+
                '    \"Thirdparty\": \"\",'+
                '    \"TicketNumber\": \"\",'+
                '    \"TicketURL\": \"\",'+
                '    \"URL\": \"https://cumminsdev.service-now.com/incident.do?sys_id=7816687f1b41c550f1d9ed77624bcba3\"'+
                '  }'+
                '}';

        string json ='+"{\"result\":{\"IncidentNumber\":\"INC3562892\",\"Priority\":\"2\",\"Customer\":\"ChevalierSpann\",\"CustomerWWID\":\"is519\",\"ShortDescription\":\"Qapla.Dahtlhinganholmughomadalegh\",\"Category\":\"Application\",\"SubCategory\":\"Repair/Fix\",\"ConfigurationItem\":\"CPGERP\",\"State\":\"Closed\",\"AssignmentGroup\":\"SupplyChainManagement-OracleAppsSupport-PSBU\",\"AssignedTo\":\"MohammadFaizanAmini\",\"AssignedToWWID\":\"mz433\",\"IncidentSysID\":\"4f4417b31b014550ba3bcb36624bcb8c\",\"Thirdparty\":\"\",\"TicketNumber\":\"\",\"TicketURL\":\"\",\"URL\":\"\"}}"+';
		//string json= '{\"result\":{\"IncidentNumber\":\"INC3562892\",\"Priority\":\"2\",\"Customer\":\"ChevalierSpann\",\"CustomerWWID\":\"is519\",\"ShortDescription\":\"Qapla.Dahtlhinganholmughomadalegh\",\"Category\":\"Application\",\"SubCategory\":\"Repair/Fix\",\"ConfigurationItem\":\"CPGERP\",\"State\":\"Closed\",\"AssignmentGroup\":\"SupplyChainManagement-OracleAppsSupport-PSBU\",\"AssignedTo\":\"MohammadFaizanAmini\",\"AssignedToWWID\":\"mz433\",\"IncidentSysID\":\"4f4417b31b014550ba3bcb36624bcb8c\",\"Thirdparty\":\"\",\"TicketNumber\":\"\",\"TicketURL\":\"\",\"URL\":\"https://cumminsdev.service-now.com/incident.do?sys_id=4f4417b31b014550ba3bcb36624bcb8c\"}}"+';
         System.debug('json 11111>>>'+ json); 
        json = json.replace('+"', '\"');
        System.debug('json SNOW Update Queueable Class>>>'+ json);
        FSL_SNOWResponsedata obj = FSL_SNOWResponsedata.parse(json);
		System.assert(obj != null);
	}*/
   ///this comments use for Deployment.  and Support to Missing cmp 
}