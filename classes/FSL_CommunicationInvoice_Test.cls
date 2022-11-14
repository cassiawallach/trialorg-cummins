@isTest
public class FSL_CommunicationInvoice_Test {
    @testSetup
    static void testSetup(){        
        WorkOrder so = new WorkOrder();
        so.Shop_Work_Order__c = '12345';
        insert so;
        System.debug(so);
        
        Account ac = new Account();
        ac.Name = 'Test';
        ac.Authorize_Work_Started__c =true;
        ac.Equipment_Available__c =true;
        ac.Invoice_Ready__c =true;
        ac.Service_Work_Completed__c =true;
        ac.Troubleshooting_Started__c =true;
        
        ac.Authorize_Work_Started__c = true;
        ac.Equipment_Available__c = true;
        ac.Invoice_Ready__c = true;
        ac.Service_Work_Completed__c = true;
        ac.Troubleshooting_Started__c = true;
        insert ac;
      
        
        Contact c = new Contact();
        c.FirstName='test1';
        c.LastName='test';
        c.Phone = '234567890';
        c.MobilePhone = '234567890';
        c.FSL_Contact_Id__c  = '9876543210';
        c.LastName = 'test lastname';
        c.IAM_Contact_Status__c = 'Active';
        c.AccountId = ac.Id;
        insert c;
        
        ServiceOrderContact__c soc = new ServiceOrderContact__c();
        soc.Service_Order__c = so.Id;
        soc.Payer_Account__c = ac.Id;
        soc.Payer_Contact__c = c.Id;
        soc.Account__c = ac.Id;
        insert soc;
        System.debug(soc);
    }    
    static testMethod void testPositive(){  
        WorkOrder so = [select Id, WorkOrderNumber, Shop_Work_Order__c from WorkOrder limit 1];
        ServiceOrderContact__c soc = [select Id from ServiceOrderContact__c limit 1];
        
        String jobId = so.WorkOrderNumber;
        String refNum = so.Shop_Work_Order__c;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        String JSONBody = '{'+
            '"Header": {'+
            '"Status": "",'+
            '"Sender": {'+
            '"ServiceName": "CommunicationContacts",'+
            '"SenderID": "BMS"'+
            '},'+
            '"Target": "CSS",'+
            '"Location": " "'+
            '},'+
            '"DataArea": {'+
            '"DistributorCode": "34555",'+
            '"BranchCode": "34534",'+
            '"CSSJobId": "'+ jobId +'",'+
            '"OrderType": "WO",'+
            '"BMSReferenceNumber": "'+ refNum +'",'+
            '"PayerID": "",'+
            '"Status": "Invoice Ready",'+
            '"AdhocEmails": "",'+
            '"ContactIds": ['+
            '"9879879879",'+
            '"9879879877",'+
            '"9789798798",'+
            '"9876543210",'+
            '" "'+
            ']'+
            '}'+
            '}';
        
        req.requestURI = '/Communications/Text/CommunicationContacts/*';       
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONBody);
        RestContext.request = req;
        RestContext.response= res;
        
//        FSL_CommunicationInvoice.Sender sender = new FSL_CommunicationInvoice.Sender('TestServiceName','Test');
//        FSL_CommunicationInvoice.DataArea dataArea = new FSL_CommunicationInvoice.DataArea('test', sender, 'test', 'test');
            
        FSL_CommunicationInvoice.Sender sender = new FSL_CommunicationInvoice.Sender();
        FSL_CommunicationInvoice.DataArea dataArea = new FSL_CommunicationInvoice.DataArea();
        FSL_CommunicationInvoice.Header header = new FSL_CommunicationInvoice.Header();

        test.startTest();
        FSL_CommunicationInvoice fsl = new FSL_CommunicationInvoice();
        FSL_CommunicationInvoice.doPostOperation();
        FSL_CommunicationInvoice.CommunicationContactsWrapper ccw = new FSL_CommunicationInvoice.CommunicationContactsWrapper();
        ccw.CommunicationContactsWrapper(header, dataArea);
        Test.stopTest();

        System.debug(res.responseBody);        
//      System.assert();
    }
}