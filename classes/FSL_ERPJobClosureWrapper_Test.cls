@isTest
public class FSL_ERPJobClosureWrapper_Test {
    @isTest
    static void testParse() {
        String json = '{'+
            '  \"Header\": {'+
            '    \"Sender\": {'+
            '      \"ServiceName\": \"sendBMSJobDeletion\",'+
            '      \"SenderID\": \"BMS\"'+
            '    },'+
            '    \"Target\": {'+
            '      \"TargetID\": \"CSS\"'+
            '    },'+
            '    \"Location\": {'+
            '      \"LocationID\": \"02400-02394\"'+
            '    }'+
            '  },'+
            '  \"DataArea\": {'+
            '    \"CSSJobId\": \"00074131\",'+
            '    \"DistributorCode\": \"02400\",'+
            '    \"BranchCode\": \"02394\",'+
            '    \"CustomerCode\": \"C100002045\",'+
            '    \"OrderType\": \"WO/WOQT\",'+
            '    \"BMSReferenceNumber\": \"98687687\",'+
            '    \"Action\": \"DELETE\",'+
            '    \"Reason\": \"Job deleted in BMS.\"'+
            '  }'+
            '}';
        FSL_ERPJobClosureWrapper obj = FSL_ERPJobClosureWrapper.parse(json);
        System.assert(obj != null);
    }
}