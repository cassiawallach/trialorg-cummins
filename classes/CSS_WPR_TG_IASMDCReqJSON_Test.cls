@IsTest
public class CSS_WPR_TG_IASMDCReqJSON_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"ServiceName\": \"SendIARecords\",'+
		'		\"ServiceVersion\": \"1.0\",'+
		'		\"Target\": \"MachineData\",'+
		'		\"SenderID\": \"CSS\",'+
		'		\"RunTime\": \"IAJobs-2017-06-19T18:38:24.024Z\"'+
		'	},'+
		'	\"DataArea\": ['+
		'		{'+
		'			\"Id\": \"a0p3B0000003HWdQAM\",'+
		'			\"IASNumber\": \"IAS-0000000348\",'+
		'			\"ServiceName\": \"GetAssessData\",'+
		'			\"ServiceVersion\": \"2.0\",'+
		'			\"ToolID\": \"ATLASMOBILE\",'+
		'			\"SenderID\": \"oi376\",'+
		'			\"TargetID\": \"CSS\",'+
		'			\"PSN\": \"79484646\",'+
		'			\"SERVICEMODELNAME\": \"ISX15 CM2250\",'+
		'			\"ERT\": \"15255\",'+
		'			\"MAKE\": \"PETERBILT\",'+
		'			\"MODEL\": \"389\",'+
		'			\"ACCESS\": \"B\",'+
		'			\"UserLocation\": \"12345-67890\",'+
		'			\"CustomerName\": \"PENSKE\",'+
		'			\"ComplaintText\": \"Oil Leak\",'+
		'			\"Algorithm\": \"Advanced\",'+
		'			\"CSSEnabled\": \"N\",'+
		'			\"CSSJobNumber\": \"CSS-00039545\",'+
		'			\"Status\": \"Success\",'+
		'			\"ReturnCodeDescription\": \"Fault Details Data sent successfully\",'+
		'			\"Version\": \"v02\",'+
		'			\"Result\": {'+
		'				\"unPrioritizedData\": ['+
		'					{'+
		'						\"upfc\": \"442\",'+
		'						\"rc\": \"6\"'+
		'					},'+
		'					{'+
		'						\"upfc\": \"1596\",'+
		'						\"rc\": \"4\"'+
		'					},'+
		'					{'+
		'						\"upfc\": \"1135\",'+
		'						\"rc\": \"4\"'+
		'					},'+
		'					{'+
		'						\"upfc\": \"426\",'+
		'						\"rc\": \"4\"'+
		'					},'+
		'					{'+
		'						\"upfc\": \"547\",'+
		'						\"rc\": \"4\"'+
		'					},'+
		'					{'+
		'						\"upfc\": \"232\",'+
		'						\"rc\": \"4\"'+
		'					},'+
		'					{'+
		'						\"upfc\": \"263\",'+
		'						\"rc\": \"4\"'+
		'					}'+
		'				],'+
		'				\"prioritizedData\": ['+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"\",'+
		'						\"rootCause2\": \"\",'+
		'						\"rootCause1\": \"Due to the nature of this fault additional troubleshooting information is required to isolate root cause\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"\",'+
		'						\"rc2Likelihood\": \"\",'+
		'						\"rc1Likelihood\": \"\",'+
		'						\"prifc\": \"441\",'+
		'						\"lhrs\": \"\"'+
		'					},'+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"\",'+
		'						\"rootCause2\": \"\",'+
		'						\"rootCause1\": \"Engine Wiring Harness\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"\",'+
		'						\"rc2Likelihood\": \"\",'+
		'						\"rc1Likelihood\": \"10%\",'+
		'						\"prifc\": \"2265\",'+
		'						\"lhrs\": \"2.15\"'+
		'					},'+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"\",'+
		'						\"rootCause2\": \"Connector Pin\",'+
		'						\"rootCause1\": \"Crankcase Pressure Sensor\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"\",'+
		'						\"rc2Likelihood\": \"6%\",'+
		'						\"rc1Likelihood\": \"47%\",'+
		'						\"prifc\": \"1844\",'+
		'						\"lhrs\": \"1.60\"'+
		'					},'+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"\",'+
		'						\"rootCause2\": \"\",'+
		'						\"rootCause1\": \"Fuel Rail Pressure Sensor\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"\",'+
		'						\"rc2Likelihood\": \"\",'+
		'						\"rc1Likelihood\": \"80%\",'+
		'						\"prifc\": \"451\",'+
		'						\"lhrs\": \"1.20\"'+
		'					},'+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"\",'+
		'						\"rootCause2\": \"OEM Component\",'+
		'						\"rootCause1\": \"Fuel Pump Actuator\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"\",'+
		'						\"rc2Likelihood\": \"8%\",'+
		'						\"rc1Likelihood\": \"85%\",'+
		'						\"prifc\": \"272\",'+
		'						\"lhrs\": \"2.20\"'+
		'					},'+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"Electrical Connector\",'+
		'						\"rootCause2\": \"Connector Pin\",'+
		'						\"rootCause1\": \"Barometric Pressure Sensor\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"27%\",'+
		'						\"rc2Likelihood\": \"27%\",'+
		'						\"rc1Likelihood\": \"27%\",'+
		'						\"prifc\": \"222\",'+
		'						\"lhrs\": \"\"'+
		'					},'+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"Electrical Connector\",'+
		'						\"rootCause2\": \"Connector Pin\",'+
		'						\"rootCause1\": \"Lubricating Oil Temperature Sensor\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"15%\",'+
		'						\"rc2Likelihood\": \"15%\",'+
		'						\"rc1Likelihood\": \"65%\",'+
		'						\"prifc\": \"212\",'+
		'						\"lhrs\": \"\"'+
		'					},'+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"\",'+
		'						\"rootCause2\": \"\",'+
		'						\"rootCause1\": \"Coolant Temperature Sensor\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"\",'+
		'						\"rc2Likelihood\": \"\",'+
		'						\"rc1Likelihood\": \"84%\",'+
		'						\"prifc\": \"144\",'+
		'						\"lhrs\": \"2.00\"'+
		'					},'+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"Lubricating Oil Pressure Sensor\",'+
		'						\"rootCause2\": \"Electrical Connector\",'+
		'						\"rootCause1\": \"Connector Pin\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"24%\",'+
		'						\"rc2Likelihood\": \"24%\",'+
		'						\"rc1Likelihood\": \"24%\",'+
		'						\"prifc\": \"141\",'+
		'						\"lhrs\": \"2.75\"'+
		'					},'+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"\",'+
		'						\"rootCause2\": \"\",'+
		'						\"rootCause1\": \"Intake Manifold Pressure/Temperature Sensor\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"\",'+
		'						\"rc2Likelihood\": \"\",'+
		'						\"rc1Likelihood\": \"94%\",'+
		'						\"prifc\": \"123\",'+
		'						\"lhrs\": \"1.20\"'+
		'					},'+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"\",'+
		'						\"rootCause2\": \"Electrical Connector\",'+
		'						\"rootCause1\": \"Connector Pin\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"\",'+
		'						\"rc2Likelihood\": \"21%\",'+
		'						\"rc1Likelihood\": \"21%\",'+
		'						\"prifc\": \"153\",'+
		'						\"lhrs\": \"4.15\"'+
		'					},'+
		'					{'+
		'						\"rootCause4\": \"\",'+
		'						\"rootCause3\": \"\",'+
		'						\"rootCause2\": \"Engine Wiring Harness\",'+
		'						\"rootCause1\": \"OEM Component\",'+
		'						\"relfc\": [],'+
		'						\"rc4Likelihood\": \"\",'+
		'						\"rc3Likelihood\": \"\",'+
		'						\"rc2Likelihood\": \"11%\",'+
		'						\"rc1Likelihood\": \"82%\",'+
		'						\"prifc\": \"1117\",'+
		'						\"lhrs\": \"5.65\"'+
		'					}'+
		'				]'+
		'			}'+
		'		}'+
		'	]'+
		'}';
        
		CSS_WPR_TG_IASMDCReqJSON obj = CSS_WPR_TG_IASMDCReqJSON.parse(json);
		System.assert(obj != null);
	}
}