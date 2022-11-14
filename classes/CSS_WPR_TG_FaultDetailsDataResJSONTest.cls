@IsTest
public class CSS_WPR_TG_FaultDetailsDataResJSONTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Status\": \"Success\",'+
		'    \"ServiceVersion\": \"1.0\",'+
		'    \"ServiceName\": \"GetAssessData\",'+
		'    \"ReturnCodeDescription\": \"Fault Details Data sent successfully\"'+
		'  },'+
		'  \"DataArea\": {'+
		'    \"unPrioritizedData\": ['+
		'      {'+
		'        \"upfcdesc\": \"Power Supply Lost With Ignition On - Data Erratic, Intermittent, or Incorrect\",'+
		'        \"upfc\": \"1117\",'+
		'        \"rc\": \"6\"'+
		'      },'+
		'      {'+
		'        \"upfcdesc\": \"Aftertreatment 1 Diesel Exhaust Fluid Pressure - Data Valid But Below Normal Operating Range - Moderately Severe Level\",'+
		'        \"upfc\": \"3574\",'+
		'        \"rc\": \"6\"'+
		'      }'+
		'    ],'+
		'    \"PSN\": \"79634249\",'+
		'    \"prioritizedData\": ['+
		'      {'+
		'        \"rootCause4\": \"\",'+
		'        \"rootCause3\": \"\",'+
		'        \"rootCause2\": \"\",'+
		'        \"rootCause1\": \"\",'+
		'        \"relfc\": [],'+
		'        \"rc4Likelihood\": \"\",'+
		'        \"rc3Likelihood\": \"\",'+
		'        \"rc2Likelihood\": \"\",'+
		'        \"rc1Likelihood\": \"\",'+
		'        \"prifcdesc\": \"\",'+
		'        \"prifc\": \"2636\",'+
		'        \"lhrs\": \"4.75\"'+
		'      },'+
		'      {'+
		'        \"rootCause4\": \"\",'+
		'        \"rootCause3\": \"OEM Component \",'+
		'        \"rootCause2\": \"Aftertreatment Diesel Exhaust Fluid Dosing Valve \",'+
		'        \"rootCause1\": \"Aftertreatment DEF Dosing Valve \",'+
		'        \"relfc\": [],'+
		'        \"rc4Likelihood\": \"\",'+
		'        \"rc3Likelihood\": \"12%\",'+
		'        \"rc2Likelihood\": \"41%\",'+
		'        \"rc1Likelihood\": \"42%\",'+
		'        \"prifcdesc\": \"Aftertreatment 1 Diesel Exhaust Fluid Dosing Valve 1 - Mechanical System Not Responding or Out of Adjustment\",'+
		'        \"prifc\": \"3568\",'+
		'        \"lhrs\": \"3.10\"'+
		'      },'+
		'      {'+
		'        \"rootCause4\": \"\",'+
		'        \"rootCause3\": \"Aftertreatment Diesel Exhaust Fluid Dosing Unit \",'+
		'        \"rootCause2\": \"DEF Dosing System Malfunction\",'+
		'        \"rootCause1\": \"OEM Component \",'+
		'        \"relfc\": ['+
		'          {'+
		'            \"rfcdesc\": \"Aftertreatment 1 Diesel Exhaust Fluid Dosing Unit Input Lines - Condition Exists\",'+
		'            \"rfc\": \"1682\"'+
		'          },'+
		'          {'+
		'            \"rfcdesc\": \"Engine Protection Torque Derate - Condition Exists\",'+
		'            \"rfc\": \"3714\"'+
		'          }'+
		'        ],'+
		'        \"rc4Likelihood\": \"\",'+
		'        \"rc3Likelihood\": \"22%\",'+
		'        \"rc2Likelihood\": \"23%\",'+
		'        \"rc1Likelihood\": \"38%\",'+
		'        \"prifcdesc\": \"Aftertreatment 1 Diesel Exhaust Fluid Pressure - Data Erratic, Intermittent, or Incorrect\",'+
		'        \"prifc\": \"3596\",'+
		'        \"lhrs\": \"5.63\"'+
		'      }'+
		'    ],'+
		'    \"algorithm\": \"Advanced\"'+
		'  }'+
		'}';
        
		CSS_WPR_TG_FaultDetailsDataResJSON2Apex obj = CSS_WPR_TG_FaultDetailsDataResJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}