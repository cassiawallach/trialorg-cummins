@IsTest
public class CSS_SendGSQPartsRequestJ2A_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        ' \"Header\": {'+
        '  \"Sender\": {'+
        '   \"ServiceName\": \"SendGSQParts\",'+
        '   \"SenderID\": \"CSS\"'+
        '  },'+
        '  \"Target\": {'+
        '   \"TargetID\": \"BMS\"'+
        '  },'+
        '  \"Location\": {'+
        '   \"LocationID\": \"02400-02394\"'+
        '  }'+
        ' },'+
        ' \"DataArea\": {'+
        '    \"CSSJobId\": \"C00012345\",'+
        '    \"DistributorCode\": \"02400\",'+
        '    \"DistributorBranchCode\": \"02394\",'+
        '    \"OrderType\": \"WOQT\",'+
        '    \"BMSQuoteID\": \"123456\",'+
        '    \"PartDetails\": [ {'+
        '    \"ProductCodeOEM\": \"CECO\",'+
        '    \"PartNumberService\": \"431894700\",'+
        '    \"Quantity\": 4} ,'+
        '     {'+
        '    \"ProductCodeOEM\": \"CECO\",'+
        '    \"PartNumberService\": \"431894700\",'+
        '    \"Quantity\": 4} '+
        ']'+
        '}'+
        '}';
        CSS_SendGSQPartsRequestJ2A obj = CSS_SendGSQPartsRequestJ2A.parse(json);
        System.assert(obj != null);
    }
}