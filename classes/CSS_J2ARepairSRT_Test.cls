@isTest
public class CSS_J2ARepairSRT_Test {
	
	static testMethod void testParse() {
		String json ='{'+
		'   \"DataArea\":    {'+
		'      \"CaseResponse\":       ['+
		'                  {'+
		'            \"SRTTitle\": \"INSITE - Use During Troubleshooting\",'+
		'            \"SRTQuantity\": 1,'+
		'            \"VerifyRepeatValue\":             {'+
		'               \"SRTType\": \"\",'+
		'               \"Step\":                {'+
		'                  \"Percentage\": 0,'+
		'                  \"SRTModifyDateTime\": \"\",'+
		'                  \"StepDescription\": [\"INSITE - Used during Troubleshooting\\n(Refer to the INSITE QUANTUM User\'s Manual)\\n\\nNote: This SRT can be added to Electronic\\nTroubleshooting SRT. This SRT can only be used\\nONE time on each repair order, regardless of the\\nnumber of fault codes, failures, or malfunctions.\\n\\nIncludes:\\n\\n -Connect and disconnect INSITE\\n -Read fault codes\\n -View programmable parameters\\n -Monitor applicable functional and performance\\n  areas (switches, fueling, etc.)\\n -Erase inactive fault codes\"],'+
		'                  \"StepID\": 47415'+
		'               },'+
		'               \"SRTEventPerfDateTime\": \"\"'+
		'            },'+
		'            \"FailureID\": \"F07000130\",'+
		'            \"Assignment\": \"UNLISTED\",'+
		'            \"FailureName\": \"Lubricating Oil Pan\",'+
		'            \"SRTDetails\": \"00-724-00\",'+
		'            \"CaseNumber\": \"Case001",'+
		'            \"SRTTime\": 0.3,'+
		'            \"SRTAccessCode\": \"C\",'+
		'            \"SRTMessage\": \"\"'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Lubricating Oil Systems - Check\",'+
		'            \"SRTQuantity\": 1,'+
		'            \"VerifyRepeatValue\":             {'+
		'               \"SRTType\": \"\",'+
		'               \"Step\":                {'+
		'                  \"Percentage\": 0,'+
		'                  \"SRTModifyDateTime\": \"\",'+
		'                  \"StepDescription\": [\"Includes:\\n\\n -Check oil level using the dip stick\\n -Visually inspect the engine for external oil\\n    leaks\\n\\n -Visual inspection for signs of contamination\\n    (foreign debris or coolant)\\n\\nNOTE:  Refer to the following repair procedures\\n    and times, as necessary:\\n\\n -07-001 Oil Filter  -Cut Open and Inspect\\n    (Spin on Type)\"],'+
		'                  \"StepID\": 120039'+
		'               },'+
		'               \"SRTEventPerfDateTime\": \"\"'+
		'            },'+
		'            \"FailureID\": \"F07000130\",'+
		'            \"Assignment\": \"DIAGNOSTIC\",'+
		'            \"FailureName\": \"Lubricating Oil Pan\",'+
		'            \"SRTDetails\": \"07-057-00\",'+
                '            \"CaseNumber\": \"Case001",'+
		'            \"SRTTime\": 0.2,'+
		'            \"SRTAccessCode\": \"C\",'+
		'            \"SRTMessage\": \"\"'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Lubricating Oil Pan - Remove and Install\",'+
		'            \"SRTQuantity\": 1,'+
		'            \"VerifyRepeatValue\":             {'+
		'               \"SRTType\": \"\",'+
		'               \"Step\":                {'+
		'                  \"Percentage\": 0,'+
		'                  \"SRTModifyDateTime\": \"\",'+
		'                  \"StepDescription\": [\"(Refer to the appropriate Troubleshooting and\\nRepair Manual)\\n\\n\\nIncludes:\\n\\n -Disconnect and connect batteries\\n -Drain and fill lubricating oil pan\\n -Remove and install oil pan\\n -Clean and visually inspect:\\n\\n  . Gasket surfaces\\n  . Oil pan\\n -Operate engine to check for leaks\"],'+
		'                  \"StepID\": 19684'+
		'               },'+
		'               \"SRTEventPerfDateTime\": \"\"'+
		'            },'+
		'            \"FailureID\": \"F07000130\",'+
		'            \"Assignment\": \"PRIMARY\",'+
		'            \"FailureName\": \"Lubricating Oil Pan\",'+
		'            \"SRTDetails\": \"07-109-00\",'+
                '            \"CaseNumber\": \"Case001",'+
		'            \"SRTTime\": 2.2,'+
		'            \"SRTAccessCode\": \"C\",'+
		'            \"SRTMessage\": \"\"'+
		'         }'+
		'      ],'+
		'      \"ResponseMessage\": \"\"'+
		'   },'+
		'   \"Header\":    {'+
		'      \"ReturnCodeDescription\": \"\",'+
		'      \"Status\": \"Success\"'+
		'   }'+
		'}';

		CSS_J2ARepair_SRT obj = CSS_J2ARepair_SRT.parse(json);
		System.assert(obj != null);
	}
}