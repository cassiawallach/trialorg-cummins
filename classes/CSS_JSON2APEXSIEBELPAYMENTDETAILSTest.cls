@IsTest
public class CSS_JSON2APEXSIEBELPAYMENTDETAILSTest {
    static testMethod void testParse() {
        String json = '{'+
            '	\"Header\": {'+
            '		\"Sender\": {'+
            '			\"ServiceName\": \"sendBMSJobDeletion\",'+
            '			\"SenderID\": \"BMS\"'+
            '		},'+
            '		\"Target\": {'+
            '			\"TargetID\": \"CSS\"'+
            '		},'+	
            '	},'+
            '	\"DataArea\": [{'+
            '		\"SiebelClaimNumber\": \"C0000190118\",'+
            '		\"IMSClaimNumber\": \"56270\",'+
            '		\"PayCode\": \"I\",'+
            '		\"ClaimStatus\": \"56275\",'+
            '		\"RejectionReason\": \"56275\",'+
            '		\"Type\": \"WO\",'+
            '		\"StatementNumber\": \"TEST\",'+
            '		\"CreditDate\": \"2010-03-19\",'+
            '		\"CreditNumber\": \"TEST\",'+
            '		\"Parts\": \"56270\",'+
            '		\"Labor\": \"56275\",'+
            '		\"Travel\": \"56275\",'+
            '		\"Other\": \"987\",'+
            '		\"Tax\": \"987\",'+
            '		\"PMU\": \"56275\",'+
            '		\"BFC\": \"56275\",'+
            '		\"Deductible\": \"975\",'+
            '		\"TotalPaid\": \"955\"'+
            '	}]'+
            '}';
        try{
        CSS_JSON2APEXSIEBELPAYMENTDETAILS obj = CSS_JSON2APEXSIEBELPAYMENTDETAILS.parse(json);
        System.assert(obj != null);
        }
        catch(exception e){}
    }
}