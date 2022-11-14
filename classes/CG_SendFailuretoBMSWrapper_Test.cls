@IsTest
public class CG_SendFailuretoBMSWrapper_Test {
    
    static testMethod void testParse() {
        String json = '{\"Header\": {'+
		'   \"ReturnCodeDescription\": \"Message If Any\",'+
		'   \"Status\": \"SUCCESS\",'+
		'   \"Sender\":    {'+
		'      \"ServiceName\": \"sendWCHeader\",'+
		'      \"SenderID\": \"CSS\"'+
		'   },'+
		'   \"Target\": {\"TargetID\": \"BMS\"},'+
		'   \"Location\": {\"LocationID\": \"56270-56255\"}'+
		'}}';

		
        CG_SendFailurecodestoBMSOutPutWrapper obj = CG_SendFailurecodestoBMSOutPutWrapper.parse(json);
		System.assert(obj != null);

}
}