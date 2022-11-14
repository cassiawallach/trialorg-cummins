@IsTest
public class CSS_WPR_TG_LaborHrsDataResJSONTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Status\": \"Success\",'+
		'    \"ServiceVersion\": \"1.0\",'+
		'    \"ServiceName\": \"GetLaborHrsData\",'+
		'    \"ReturnCodeDescription\": \"Labor Hours Data sent successfully\"'+
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
		'        \"relfc\": [],'+
		'        \"prifcdesc\": \"\",'+
		'        \"prifc\": \"2636\",'+
		'        \"lhrs\": \"4.75\"'+
		'      },'+
		'      {'+
		'        \"relfc\": [],'+
		'        \"prifcdesc\": \"Aftertreatment 1 Diesel Exhaust Fluid Dosing Valve 1 - Mechanical System Not Responding or Out of Adjustment\",'+
		'        \"prifc\": \"3568\",'+
		'        \"lhrs\": \"3.10\"'+
		'      },'+
		'      {'+
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
		'        \"prifcdesc\": \"Aftertreatment 1 Diesel Exhaust Fluid Pressure - Data Erratic, Intermittent, or Incorrect\",'+
		'        \"prifc\": \"3596\",'+
		'        \"lhrs\": \"5.63\"'+
		'      }'+
		'    ],'+
		'    \"algorithm\": \"Advanced\"'+
		'  }'+
		'}';
        
		CSS_WPR_TG_LaborHrsDataResJSON2Apex obj = CSS_WPR_TG_LaborHrsDataResJSON2Apex.parse(json);
		System.assert(obj != null);
	}
}