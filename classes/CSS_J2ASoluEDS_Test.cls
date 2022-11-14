@isTest
public class CSS_J2ASoluEDS_Test {
	static testMethod void testParse() {
        String json = '{"solutionNumber":"K75314690","solutionTitle":"Injector solenoid driver cylinder 9 current below normal or open circuit","coreIssue":"The ECM has detected the current is below normal or there is an open circuit at injector solenoid driver cylinder 9","modificationDate":"2016-07-15 13:31", "status":"Released","verification":"verification","resolution":"resolution", "poleLogicSolution":true,"key":"key","message":"message","Components":[ {"failureId":"1","value":"value"}], "verCompoundSolutions":[{"solutionNumber":"solutionNumber","solutionTitle":"solutionTitle", "coreIssue":"coreIssue","modificationDate":"2016-07-18T18:25:43.511Z", "status":"status", "verification":"verification","resolution":"resolution", "poleLogicSolution":false,"key":"key","Components":[{ "failureId":"F05000100","value":"Fuel Injector"}]}], "RepCompoundSolutions":[{"solutionNumber":"K48942473","solutionTitle":"Short or open circuit in the fuel Injector driver solenoid", "coreIssue":"The fuel injector driver solenoid has a short or open circuit:","modificationDate":"2016-07-06 22:47", "status":"Released", "verification":"Conditions","resolution":"For a malfunctioning fuel injector pigtail connector. replace the fuel injector pigtail connector","poleLogicSolution": false,"key":"key", "Components":[{ "failureId":"F05000100","value":"Fuel Injector"}]}]}';
		/*String json = '{'+
		'  \"solutionNumber\": \"K75314690\",'+
		'  \"solutionTitle\": \"Injector solenoid driver cylinder 9 current below normal or open circuit<br />\",'+
		'  \"coreIssue\": \"The ECM has detected the current is below normal, or there is an open circuit at injector solenoid driver cylinder 9.<br />\\n\",'+
		'  \"modificationDate\": \"2015-06-15 13:31\",'+
		'  \"status\": \"Released\",'+
		'  \"verification\": \"<strong>Conditions</strong><ul><li>\\t\\tTurn keyswitch ON.</li><li>\\t\\tConnect INSITEâ„¢ electronic service tool.</li></ul><strong>Action</strong><br /><br />Operate the engine and observe the fault codes.<br /><ul><li>\\t\\tStart the engine and let it idle for 1 minute.</li><li>\\t\\tUse INSITEâ„¢ electronic service tool to read the fault codes.</li></ul><strong>Specification</strong><ul><li>\\t\\tIf Fault Code 1622 is active, or inactive with more than one count logged within the last 25 hours of engine operation, then proceed to next <strong>Action</strong>.</li><li>\\t\\tIf Fault Codes 1548 and 1622 are both active, or inactive with more than one count logged within the last 25 hours of engine operation, then proceed to the <strong>next </strong>solution.</li></ul><strong>Action</strong><br /><br /><span><span>Make sure the following engine harness connections are properly made:</span></span><ul><li>\\t\\t<span>Injector solenoid or engine harness has a short or open circuit </span></li></ul><br />\",'+
		'  \"poleLogicSolution\": false,'+
		'  \"verCompoundSolutions\": ['+
		'    {'+
		'      \"solutionNumber\": \"K48942473\",'+
		'      \"solutionTitle\": \"Short or open circuit in the fuel Injector driver solenoid\",'+
		'      \"coreIssue\": \"The fuel injector driver solenoid has a short or open circuit:<br /><br />Single fuel injector malfunctions include:<ul><li>High resistance in a single fuel injector or injector solenoid</li><li>Extremely low resistance in an fuel injector solenoid (injector shorted internally but not to ground)</li></ul>Causes of multiple fuel injector fault codes in the same bank of fuel injectors are:<ul><li>Short circuit in any of the fuel injectors in the bank - shorts-to-ground</li></ul>\",'+
		'      \"modificationDate\": \"2015-08-06 22:47\",'+
		'      \"status\": \"Released\",'+
		'      \"verification\": \"<div><div><div><strong>Conditions</strong></div></div></div><ul><li>Turn keyswitch OFF.</li><li>Disconnect the engine harness connector from the ECM.</li><li>Disconnect the engine harness from the fuel injector connector.</li></ul><strong>Action</strong><br /><br />To reduce the possibility of pin and harness damage, use the recommended test leads when taking a measurement.<br /><br />Inspect the pins and connector for damage. Refer to Procedure: <a href=\\\"/apex/css_qsolRedirect?doctype=pro&amp;docid=019-361&amp;pgroup=EBU\\\" target=\\\"_blank\\\">019-361</a>.<br /><br />Check the resistance of the fuel injector solenoid.<ul><li>Measure the resistance between the injector solenoid SIGNAL pin and the fuel injector solenoid RETURN pin on the fuel injector solenoid pigtail connector for the fuel injector being tested.</li></ul> <div>Refer to the circuit diagram or wiring diagram for connector pin identification.</div><div>For general resistance measurement techniques. Refer to Procedure: <a href=\\\"/apex/css_qsolRedirect?doctype=pro&amp;docid=019-360&amp;pgroup=EBU\\\" target=\\\"_blank\\\">019-360</a>.<br /> <div><strong>Specification</strong></div><ul><li>If the resistance is not within 0.5 ohms and 5 ohms for the injector being measured, then a shorted fuel injector or fuel injector wiring and connector has been detected.</li></ul><strong>Action</strong><ul><li>Cut off the fuel injector wiring connector pigtail. Refer to Procedure: <a href=\\\"/apex/css_qsolRedirect?doctype=pro&amp;docid=019-559&amp;pgroup=EBU\\\" target=\\\"_blank\\\">019-559</a>.</li><li>Measure the resistance between the fuel injector solenoid SIGNAL pin and the fuel injector solenoid RETURN pin at the wires that were cut for the fuel injector being tested.</li></ul><strong>Specifications</strong><ul><li>If the resistance is not within 0.5 ohms and 5 ohms, then a malfunction of the fuel injector has been detected.</li><li>If the resistance is within 0.5 ohms and 5 ohms, then a malfunction of the fuel injector wiring harness pigtail connector has been detected.</li></ul></div>\",'+
		'      \"resolution\": \"<ul><li>For a malfunctioning fuel injector pigtail connector. replace the fuel injector pigtail connector. Refer to Procedure: <a href=\\\"/apex/css_qsolRedirect?doctype=pro&amp;docid=006-026&amp;pgroup=EBU\\\" target=\\\"_blank\\\">006-026</a>.</li><li>For a malfunctioning fuel injector, replace the fuel injector.  Refer to Procedure: <a href=\\\"/apex/css_qsolRedirect?doctype=pro&amp;docid=006-026&amp;pgroup=EBU\\\" target=\\\"_blank\\\">006-026</a>.</li></ul>\",'+
		'      \"poleLogicSolution\": false,'+
		'      \"components\": ['+
		'        {'+
		'          \"failureId\": \"F05000100\",'+
		'          \"value\": \"Fuel Injector\"'+
		'        }'+
		'      ]'+
		'    }'+
		'  ]'+
		'}';*/
		CSS_J2ASolution_EDS obj = CSS_J2ASolution_EDS.parse(json);
		System.assert(obj != null);
	}
}