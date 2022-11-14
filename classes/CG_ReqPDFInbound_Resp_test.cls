@istest
public class CG_ReqPDFInbound_Resp_test {
    static testmethod void testmethod1()
    {
        string json='{ "Header": { "Status": "Status", "Sender": { "SenderID": "SenderID", "ServiceName": "ServiceName", "MessageID": "MessageID" }, "Target": { "TargetID": "TargetID" }, "Location": { "LocationID": "LocationID" }, "ReturnCodeDescription": "CSS02-Service Name is missing in input" } }';
        CG_ReqPDFInbound_Resp.parse(json);
        
    }

}