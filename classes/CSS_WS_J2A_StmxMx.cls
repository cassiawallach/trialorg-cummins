Public Class CSS_WS_J2A_StmxMx{

    Public String documentType;
    Public String transactionNumber;
    Public String transactionDate;
    Public String extendedAmount;
    Public String customerNumber;
    Public String billToCustomerName;
    Public String shipToCustomerName;
    Public String timbreFiscal;
    Public String idDocument;
    Public String salesOrder;
    
    Public Static CSS_WS_J2A_StmxMx parse(String json){
        return (CSS_WS_J2A_StmxMx) System.JSON.deserialize(json, CSS_WS_J2A_StmxMx.class);
    }
}