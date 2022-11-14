@isTest(SeeAllData=True)
public class CSS_receiveINSITEDataTest{

    public static testMethod void testJobOrderData(){
        Test.startTest();
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        //jobOrder.Name = 'CC123456';
        jobOrder.Status__c = 'Created/Not Assigned';
        insert jobOrder;
        
        String jobName = [SELECT Name FROM CSS_Job_Order__c WHERE Id =: jobOrder.Id].Name;
        
        string JSONReq = '{"CUSTNAME" : "Paul","CJOD" : "'+jobName+'","TI" : "123ABC","UNT"  : "5435","ESN":"ABCDERDF","ERT":"123456", "TMS":"2012-04-23T18:25:43.511Z",';
        JSONReq += '"FaultCode": [{"FD": {"APD": [{"P": "340","R": ["65","75"]},{"P": "414","R": ["645","755"]}],';
        JSONReq += '"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}},"IMGNM": "IMG123","Mod": "0","PAT": "A"}]}';
        
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/InsiteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;
        
        //string results = CSS_receiveINSITEData.updateJobOrderData();
        CSS_receiveINSITEData.updateJobOrderData();
        Test.stopTest();
    }
    
    
    public static testMethod void testJobOrderDataClosed(){
        Test.startTest();
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        //jobOrder.Name = 'CC123456';
        jobOrder.Status__c = 'Closed';
        insert jobOrder;
        
        String jobName = [SELECT Name FROM CSS_Job_Order__c WHERE Id =: jobOrder.Id].Name;
        
        string JSONReq = '{"CUSTNAME" : "Paul","CJOD" : "'+jobName+'","TI" : "123ABC","UNT"  : "5435","ESN":"ABCDERDF","ERT":"123456", "TMS":"2012-04-23T18:25:43.511Z",';
        JSONReq += '"FaultCode": [{"FD": {"APD": [{"P": "340","R": ["65","75"]},{"P": "414","R": ["645","755"]}],';
        JSONReq += '"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}},"IMGNM": "IMG123","Mod": "0","PAT": "A"}]}';
        
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/InsiteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;
        
        //string results = CSS_receiveINSITEData.updateJobOrderData();
        CSS_receiveINSITEData.updateJobOrderData();
        Test.stopTest();
    }
    
}