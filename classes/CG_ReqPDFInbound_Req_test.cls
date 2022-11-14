@istest
public class CG_ReqPDFInbound_Req_test {
    static testmethod void testmethod1()
    {
        string json='{ "DataArea": { "CSSJobID": "CSSJobID", "DistributorCode": "DistributorCode", "BranchCode": "BranchCode", "CustomerCode": "CustomerCode", "BMSReferenceNumber": "BMSReferenceNumber", "OrderType": "OrderType", "CustomerPO": "CustomerPO", "Action": "Action", "SecurityCode": "SecurityCode", "InvoiceUser": "InvoiceUser" }, "Header": { "Sender": { "ServiceName": "ServiceName", "SenderID": "SenderID" }, "Location": { "LocationID": "LocationID" }, "Target": { "TargetID": "TargetID" } } }';
        CG_ReqPDFInbound_Req.parse(json);
       
    }

}