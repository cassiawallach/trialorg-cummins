@IsTest
Public Class CSS_WS_J2A_StmxMx_Test{
    
    Static TestMethod Void testParse(){
        String json = '{' +
        '    \"documentType\":\"Transaction Type\",' +
        '    \"transactionNumber\":\"123456789\",' +
        '    \"transactionDate\":\"9/21/2016\",' +
        '    \"extendedAmount\":\"900\",' +
        '    \"customerNumber\":\"98765432\",' +
        '    \"billToCustomerName\":\"Bill Customer Name\",' +
        '    \"shipToCustomerName\":\"Ship Customer Name\",' +
        '    \"timbreFiscal\":\"49823483238472834j12342j3h123g412g3jh4gggfghfhfhgf23423\",' +
        '    \"idDocument\":\"CSSMX-0079216\",' +
        '    \"salesOrder\":\"MX-0079216\"' +
        '}';
        CSS_WS_J2A_StmxMx obj = CSS_WS_J2A_StmxMx.parse(json);
        System.assert(obj != null);
    }
}