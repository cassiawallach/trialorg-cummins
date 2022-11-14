Public Class CSS_WS_J2A_Amount{
    Public String claimNumber;
    Public String claimStatus;
    Public String rejectionReason;
    Public String typeNumber;
    Public String statementNumber;
    Public String creditDate;
    Public String creditNumber;
    Public String parts;
    Public String labor;
    Public String travel;
    Public String other;
    Public String tax;
    Public String PMU;
    Public String BFC;
    Public String deductible;
    Public String totalPaid;
    Public String IMSClaimNumber;
    Public String payCode;
    
    Public Static CSS_WS_J2A_Amount parse(String json){
        return (CSS_WS_J2A_Amount) System.JSON.deserialize(json, CSS_WS_J2A_Amount.class);
    }
}