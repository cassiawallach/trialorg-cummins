/*
its a wrapper class for passing the values:
*/
public class OSM_BAMS_WS_RefundResponse_Wrapper{
    
    public String Status;
    public String refundStatusToBAMS;
    public String Request;
    public String Response;
    public String ReturnCodeDescription;
    public Integer totalServiceCallTime;
    public Integer totalAuthCallTime;
    public Boolean exceptionFlag;
    public String errorMessage;
     
    public OSM_BAMS_OrderRefundNodes OrderRefundResponseNodes;
    
}