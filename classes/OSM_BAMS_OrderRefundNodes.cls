//OSM_BAMS_WS_OrderRefundResponseNodes
public class OSM_BAMS_OrderRefundNodes {
 //Response nodes for Success
    public string Security;
    public string Timestamp;
    public string Created;
    public string replyMessage;
    public string merchantReferenceCode;
    public string requestID;
    public string decision;
    public string reasonCode;
    public string requestToken;
    public string purchaseTotals;
    public string currency_pt;
    public string ccAuthReply;
    public string reasonCode_ccAuth;
    public string amount_ccAuth;
    public string authorizationCode;
    public string avsCode;
    public string avsCodeRaw;
    public string authorizedDateTime;
    public string processorResponse;
    public string reconciliationID_ccAuth;
    public string accountBalance;
    public string ownerMerchantID;
    public string ccCaptureReply;
    public string reasonCode_ccCap;
    public string requestDateTime;
    public string amount_ccCap;
    public string reconciliationID_ccCap;
     
    //Response nodes for Failure
    public string Fault;
    public string faultcode;
    public string faultstring;
}