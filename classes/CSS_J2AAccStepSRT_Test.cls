@isTest
public class CSS_J2AAccStepSRT_Test {
static testMethod void testParse() {
		String json = '{'+
		'   \"DataArea\":    {'+
		'      \"CaseResponse\":       ['+
		'                  {'+
		'            \"SRTTitle\": \"Air Conditioner Condenser - Move for Access\",'+
		'            \"SRTContent\": \"Note:  Also applies to grill mounted condensor.\",'+
		'            \"SRTTime\": 0.7,'+
		'            \"SRTAccessCode\": \"D\",'+
		'            \"SRTGroupProcedure\": \"17-102\"'+
		'         },'+
		'         {\"SRTTitle\": \"DUMMY\"},'+
		'         {\"SRTTitle\": \"DUMMY\"}'+
		'      ],'+
		'      \"ResponseMessage\": \"\"'+
		'   },'+
		'   \"Header\":    {'+
		'      \"ReturnCodeDescription\": \"\",'+
		'      \"Status\": \"Success\"'+
		'   }'+
		'}';
		CSS_J2AAccessStepDetails_SRT obj = CSS_J2AAccessStepDetails_SRT.parse(json);
		System.assert(obj != null);
	}

}