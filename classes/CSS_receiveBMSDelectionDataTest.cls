@isTest(SeeAllData=True)
public class CSS_receiveBMSDelectionDataTest {
public static testMethod void testJobOrderData(){
        Test.startTest();
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder = css_testdata.createJobOrder(false);
        //jobOrder.Name = 'CC123456';
        jobOrder = CSS_TestData.createJobOrder(false);
        jobOrder.Status__c = 'Created/Not Assigned';
        insert jobOrder;

        String jobName = [SELECT Name FROM CSS_Job_Order__c WHERE Id =: jobOrder.Id].Name;

   // String JSONReq = '{"DataArea":[{"CSSJobId":"'+jobName+'","DistributorCode":"224244-232","BranchCode":"7878","CustomerCode":"7387287328","OrderType":"tesst78","BMSReferenceNumber":"8928928","Action":"DELETE","Reason":"Job deleted in BMS"}]}';
    String JSONReq = '{"Header":{"Sender":{"ServiceName":"sendBMSJobDeletion","SenderID": "BMS"},"Target": {"TargetID": "CSS"},"Location": {"LocationID": "02400-02394"}},"DataArea": {"CSSJobId": "'+jobName+'","DistributorCode": "02400","BranchCode": "02394","CustomerCode": "C100002045","OrderType": "WO/WOQT","BMSReferenceNumber": "98687687","Action": "DELETE","Reason": "Job deleted in BMS."}}';
    RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/DeleteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;

        //string results = CSS_receiveINSITEDataR2.updateJobOrderData();
        CSS_receiveBMSDelectionData.updateJobOrderData();
        Test.stopTest();
    }
}