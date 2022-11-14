@IsTest
Public Class CSS_WS_J2A_Amount_Test{

    Static testMethod void testParse(){
        String json = '{'+
        '    \"claimNumber\":\"claimNumber\",' +
        '    \"claimStatus\":\"claimStatus\",' +
        '    \"rejectionReason\":\"rejectionReason\",' +
        '    \"typeNumber\":\"typeNumber\",' +
        '    \"statementNumber\":\"statementNumber\",' +
        '    \"creditDate\":\"creditDate\",' +
        '    \"creditNumber\":\"creditNumber\",' +
        '    \"parts\":\"parts\",' +
        '    \"travel\":\"travel\",' +
        '    \"other\":\"other\",' +
        '    \"tax\":\"tax\",' +
        '    \"PMU\":\"PMU\",' +
        '    \"BFC\":\"BFC\",' +
        '    \"deductible\":\"deductible\",' +
        '    \"totalPaid\":\"totalPaid\",' +
        '    \"IMSClaimNumber\":\"IMSClaimNumber\",' +
        '    \"payCode\":\"payCode\"' +
        '}';
        CSS_WS_J2A_Amount obj = CSS_WS_J2A_Amount.parse(json);
        System.assert(obj != null);
    }
}