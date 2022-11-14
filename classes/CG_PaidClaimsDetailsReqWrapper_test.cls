@istest
public class CG_PaidClaimsDetailsReqWrapper_test {
    static testmethod void testmethod1()
    {
        string json='{ "DataArea": { "ClaimNumber": "c0989474", "IMSClaimNumber": "1820" }, "Header": { "Sender": { "MessageID": "MessageID", "ServiceName": "ServiceName", "SenderID": "SenderID" } } }';
       CG_PaidClaimsDetailsReqWrapper op= CG_PaidClaimsDetailsReqWrapper.parse(json);
        system.assert(op!=null);
        system.assert(op.Header!=null);
        system.assert(op.DataArea!=null);
    }

}