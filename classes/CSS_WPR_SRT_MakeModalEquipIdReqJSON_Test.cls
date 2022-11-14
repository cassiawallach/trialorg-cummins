@IsTest
public class CSS_WPR_SRT_MakeModalEquipIdReqJSON_Test {
	
	static testMethod void testParse() {
		String json = '{  '+
		'   \"Header\":{  '+
		'      \"Sender\":{  '+
		'         \"MessageID\":\"unique message ID at SF\",'+
		'         \"SenderID\":\"SF\",'+
		'         \"ServiceName\":\"MakeAndModel\"'+
		'      },'+
		'      \"Target\":{  '+
		'         \"TargetID\":\"SRT\"'+
		'      }'+
		'   },'+
		'   \"DataArea\":{  '+
		'      \"LastRunDate\":\"2017-04-01\",'+
		'      \"LangCode\":\"en\"'+
		'   }'+
		'}';
        
		CSS_WPR_SRT_MakeModalEquipIdReqJSON obj = CSS_WPR_SRT_MakeModalEquipIdReqJSON.parse(json);
		System.assert(obj != null);
	}
}