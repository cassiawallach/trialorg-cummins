@IsTest
public class CG_OP_GetFaultCodeOverWrap_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"faultCode\": \"2636\",'+
		'    \"pid\": \"S27\",'+
		'    \"spn\": \"641\",'+
		'    \"fmi\": \"9\",'+
		'    \"lamp\": \"Red\",'+
		'    \"srt\": \"\",'+
		'    \"description\": \"VGT Actuator Driver Circuit - Abnormal Update Rate\",'+
		'    \"compLocation\": \"The VGT actuator is located on the turbocharger bearing housing.\",'+
		'    \"circuitDescription\": \"The variable geometry turbocharger (VGT) is electronically activated by the VGT actuator. The VGT actuator is a smart device and receives information via the J1939 data link from the primary engine control module (ECM). The VGT actuator performs its own diagnostics and reports malfunctions back to the primary engine ECM, using the J1939 data link. The ECM then decodes the error message and converts it to a fault code.\",'+
		'    \"reason\": \"VGT Actuator Driver Circuit - Abnormal Update Rate. No communications on the J1939 data link between the engine ECM and the smart VGT controller.\",'+
		'    \"effect\": \"Possible reduced engine performance.\",'+
		'    \"sysName\": \"\",'+
		'    \"url\": \"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/procedures/454/454-fc2636.html\",'+
		'    \"engine\": \"454\"'+
		'}';
		CG_OP_GetFaultCodeOverviewRespWrapper r = CG_OP_GetFaultCodeOverviewRespWrapper.parse(json);
		System.assert(r != null);

		}
}