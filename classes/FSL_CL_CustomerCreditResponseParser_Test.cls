@isTest
public class FSL_CL_CustomerCreditResponseParser_Test {
	@isTest static void testParse() {
		String json = '{\"DataArea\":{\"CustomerNumber\":\"1310000\",\"CreditMessageDetails\":[{\"CreditMessage\":\"\",\"CreditMessageCode\":\"N\"},{\"CreditMessage\":\"\",\"CreditMessageCode\":\"\"}]},\"Header\":{\"Sender\":{\"ServiceName\":\"GetMROMessages\",\"SenderID\":\"CSS\",\"MessageID\":\"ee2642dd-eea9-45d0-a8c1-797245e1e889\"},\"Status\":\"SUCCESS\",\"Target\":{\"TargetID\":\"MOVEX\"},\"ReturnCodeDescription\":\"Request processed successfully\",\"Location\":{\"LocationID\":\"05340-05351\"}}}';
		FSL_CL_CustomerCreditResponseParser obj = FSL_CL_CustomerCreditResponseParser.parse(json);
		System.assert(obj != null);
	}
}