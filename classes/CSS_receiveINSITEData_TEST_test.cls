@isTest
public class CSS_receiveINSITEData_TEST_test
{
    static testMethod void CSS_receiveINSITEData_TEST_test()
    {
        test.startTest();
                CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Created/Not Assigned';
        insert jobOrder;
        
        String jobName = [SELECT Name FROM CSS_Job_Order__c WHERE Id =: jobOrder.Id].Name;
        
        string JSONReq = '{"CUSTNAME" : "Paul","CJOD" : "'+jobName+'","TI" : "123ABC","UNT"  : "5435","ESN":"ABCDERDF","ERT":"123456", "TMS":"2012-04-23T18:25:43.511Z",';
        JSONReq += '"FaultCode": [{"FD": {"APD": [{"P": "340","R": ["65","75"]},{"P": "414","R": ["645","755"]}],';
        JSONReq += '"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}},"IMGNM": "IMG123","Mod": "0","PAT": "A"}]}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        //req.requestURI = '/services/apexrest/InsiteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestUri ='https://cumminscss--cssbrkfx.cs54.my.salesforce.com/services/apexrest/Insite/';
        req.requestBody = Blob.valueof(JSONReq);
        req.params.put('ACTION','SendDataReceiptAcknowledgement');
        RestContext.response= res;
        RestContext.request = req;
        CSS_receiveINSITEData_TEST.updateJobOrderData();
        test.stopTest();
    }
static testMethod void CSS_receiveINSITEData_TEST_test2()
    {
        test.startTest();
                CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Created/Not Assigned';
        insert jobOrder;
        
        String jobName = [SELECT Name FROM CSS_Job_Order__c WHERE Id =: jobOrder.Id].Name;
        
        string JSONReq = '{"CUSTNAME" : "Paul","CJOD" : "'+jobName+'","TI" : "123ABC","UNT"  : "5435","ESN":"ABCDERDF","ERT":"123456", "TMS":"2012-04-23T18:25:43.511Z",';
        JSONReq += '"FaultCode": [{"FD": {"APD": [{"P": "340","R": ["65","75"]},{"P": "414","R": ["645","755"]}],';
        JSONReq += '"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}},"IMGNM": "IMG123","Mod": "0","PAT": "A"}]}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        //req.requestURI = '/services/apexrest/InsiteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestUri ='https://cumminscss--cssbrkfx.cs54.my.salesforce.com/services/apexrest/Insite/';
        req.requestBody = Blob.valueof(JSONReq);
        //req.params.put('ACTION','SendDataReceiptAcknowledgement');
        RestContext.response= res;
        RestContext.request = req;
        CSS_receiveINSITEData_TEST.updateJobOrderData();
        test.stopTest();
    }    
     static testMethod void testgetFaultCodes()
    {
        List<string> fc = new list<string>{'fc1','fc2','fc3'};
        test.startTest();
    CSS_receiveINSITEData_TEST.getFaultCodes(fc);
        test.stopTest();
        }
    static testMethod void testinsIntegrationError()
    {
     test.startTest();
    CSS_receiveINSITEData_TEST.insIntegrationError('there is error');
           test.stopTest();
}
}