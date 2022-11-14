@IsTest
public class CG_OP_BMSPrivateSRTsResJSON_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Status\": \"SUCCESS\",'+
		'    \"Sender\": {'+
		'      \"ServiceName\": \"getBMSPrivateSRTs\",'+
		'      \"SenderID\": \"BMS\"'+
		'    },'+
		'    \"Target\": {'+
		'      \"TargetID\": \"CSS\"'+
		'    },'+
		'    \"Location\": {'+
		'      \"LocationID\": \"56270-56255\"'+
		'    }'+
		'  },'+
		'  \"DataArea\": ['+
		'    {'+
		'      \"EngineFamily\": \"\",'+
		'      \"SRTGroup\": \"\",'+
		'      \"SRTProcedure\": \"\",'+
		'      \"SRTStep\": \"\",'+
		'      \"Title\": \"\",'+
		'      \"AccessCode\": \"\",'+
		'      \"Hours\": 2.3,'+
		'      \"Troubleshoot\": \"\",'+
		'      \"Flexible\": \"\",'+
		'      \"Private\": \"\",'+
		'      \"Special\": \"\",'+
		'      \"RegionCode\": \"\"'+
		'    },'+
		'    {'+
		'      \"EngineFamily\": \"\",'+
		'      \"SRTGroup\": \"\",'+
		'      \"SRTProcedure\": \"\",'+
		'      \"SRTStep\": \"\",'+
		'      \"Title\": \"\",'+
		'      \"AccessCode\": \"\",'+
		'      \"Hours\": 0.1,'+
		'      \"Troubleshoot\": \"\",'+
		'      \"Flexible\": \"\",'+
		'      \"Private\": \"\",'+
		'      \"Special\": \"\",'+
		'      \"RegionCode\": \"\"'+
		'    }'+
		'  ]'+
		'}';
		CG_OP_BMSPrivateSRTsResJSON r = CG_OP_BMSPrivateSRTsResJSON.parse(json);
		System.assert(r != null);
CG_OP_BMSPrivateSRTsResJSON.Sender objSender = new CG_OP_BMSPrivateSRTsResJSON.Sender();
        System.assert(objSender != null);
		System.assert(objSender.ServiceName == null);
		System.assert(objSender.SenderID == null);
	/*	json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		CG_OP_BMSPrivateSRTsResJSON.Sender objSender = new CG_OP_BMSPrivateSRTsResJSON.Sender(System.JSON.createParser(json));
		System.assert(objSender != null);
		System.assert(objSender.ServiceName == null);
		System.assert(objSender.SenderID == null);*/

		//json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		//CG_OP_BMSPrivateSRTsResJSON.Target objTarget = new CG_OP_BMSPrivateSRTsResJSON.Target(System.JSON.createParser(json));
        CG_OP_BMSPrivateSRTsResJSON.Target objTarget = new CG_OP_BMSPrivateSRTsResJSON.Target();
		System.assert(objTarget != null);
		System.assert(objTarget.TargetID == null);

		//json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		//CG_OP_BMSPrivateSRTsResJSON.DataArea objDataArea = new CG_OP_BMSPrivateSRTsResJSON.DataArea(System.JSON.createParser(json));
		CG_OP_BMSPrivateSRTsResJSON.DataArea objDataArea = new CG_OP_BMSPrivateSRTsResJSON.DataArea();
		System.assert(objDataArea != null);
		System.assert(objDataArea.EngineFamily == null);
		System.assert(objDataArea.SRTGroup == null);
		System.assert(objDataArea.SRTProcedure == null);
		System.assert(objDataArea.SRTStep == null);
		System.assert(objDataArea.Title == null);
		System.assert(objDataArea.AccessCode == null);
		System.assert(objDataArea.Hours == null);
		System.assert(objDataArea.Troubleshoot == null);
		System.assert(objDataArea.Flexible == null);
		System.assert(objDataArea.PrivateFlag == null);
		System.assert(objDataArea.Special == null);
		System.assert(objDataArea.RegionCode == null);

		//json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		//CG_OP_BMSPrivateSRTsResJSON.Header objHeader = new CG_OP_BMSPrivateSRTsResJSON.Header(System.JSON.createParser(json));
		CG_OP_BMSPrivateSRTsResJSON.Header objHeader = new CG_OP_BMSPrivateSRTsResJSON.Header();
		System.assert(objHeader != null);
		System.assert(objHeader.Status == null);
		System.assert(objHeader.Sender == null);
		System.assert(objHeader.Target == null);
		System.assert(objHeader.Location == null);

		//json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		//CG_OP_BMSPrivateSRTsResJSON objCG_OP_BMSPrivateSRTsResJSON = new CG_OP_BMSPrivateSRTsResJSON(System.JSON.createParser(json));
		CG_OP_BMSPrivateSRTsResJSON objCG_OP_BMSPrivateSRTsResJSON = new CG_OP_BMSPrivateSRTsResJSON();
		System.assert(objCG_OP_BMSPrivateSRTsResJSON != null);
		System.assert(objCG_OP_BMSPrivateSRTsResJSON.Header == null);
		System.assert(objCG_OP_BMSPrivateSRTsResJSON.DataArea == null);

		//json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		//CG_OP_BMSPrivateSRTsResJSON.Location objLocation = new CG_OP_BMSPrivateSRTsResJSON.Location(System.JSON.createParser(json));
		CG_OP_BMSPrivateSRTsResJSON.Location objLocation = new CG_OP_BMSPrivateSRTsResJSON.Location();
		System.assert(objLocation != null);
		System.assert(objLocation.LocationID == null);
	}
}