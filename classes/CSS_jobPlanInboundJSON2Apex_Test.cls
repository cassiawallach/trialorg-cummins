@IsTest
public class CSS_jobPlanInboundJSON2Apex_Test {
    
    static testMethod void testParse() {
        String json = '{"Header":{"Target":{"TargetID":"SRT"},"Status":"200","Sender":{"ServiceName":"GetOverlapSRT","SenderID":"CSS","MessageID":null},"ReturnCodeDescription":"002","Location":{"LocationID":"t00"}}}';
        CSS_jobPlanInboundJSON2Apex obj = CSS_jobPlanInboundJSON2Apex.parse(json);
        System.assert(obj != null);
    }
}