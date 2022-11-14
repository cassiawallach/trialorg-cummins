@isTest
public class CSS_J2ADiag_Test {	
	static testMethod void testParse() {
		String json = '{'+
		'   \"DataArea\":    {'+
		'      \"CaseResponse\":       ['+
		'                  {'+
		'            \"SRTTitle\": \"\",'+
		'            \"VerifyRepeatValue\":             {'+
		'               \"SRTType\": \"VER\",'+
		'               \"Step\":                {'+
		'                  \"Percentage\": 0,'+
		'                  \"SRTModifyDateTime\": \"\",'+
		'                  \"StepDescription\": [\"\"],'+
		'                  \"SRTStatusMessage\": \"An SRT is not being populated for this EDS Solution as this time overlaps with Administration Time (00-90X), Insite (00-724), or may be included with other Diagnostic Session SRTs.\",'+
		'                  \"StepID\": 0,'+
		'                  \"SRTTime\":                   {'+
		'                     \"SpecialAccessCode\": \"\",'+
		'                     \"SpecialAccessCodeDescription\": [\"\"],'+
		'                     \"AccessCodeB\": 0,'+
		'                     \"AccessCodeA\": 0,'+
		'                     \"AccessCodeD\": 0,'+
		'                     \"AccessCodeR\": 0,'+
		'                     \"AccessCodeC\": 0'+
		'                  }'+
		'               },'+
		'               \"SRTEventPerfDateTime\": \"2016-04-18T14:52:26.000-04:00\"'+
		'            },'+
		'            \"SRTID\": \"\",'+
		'            \"CaseNumber\": \"K20430055\"'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Rocker Lever Cover - Remove and Install\",'+
		'            \"VerifyRepeatValue\":             {'+
		'               \"SRTType\": \"VER\",'+
		'               \"Step\":                {'+
		'                  \"Percentage\": 1,'+
		'                  \"SRTModifyDateTime\": \"2015-01-07T13:41:50.000-05:00\",'+
		'                  \"StepDescription\":                   ['+
		'                     \"Step Number-00\",'+
		'                     \"Includes:\",'+
		'                     \"-03-801 Crankcase Breather  -Remove and Install\",'+
		'                     \"\",'+
		'                     \"-Disconnect and connect batteries\",'+
		'                     \"-Remove and Install:\",'+
		'                     \". Air crossover pipes, as necessary\",'+
		'                     \". Air intake piping\",'+
		'                     \". Rocker lever cover\",'+
		'                     \"\",'+
		'                     \"-Clean and visually check:\",'+
		'                     \". Rocker lever cover\",'+
		'                     \". Rocker lever cover gasket surface\",'+
		'                     \"-Visually check:\",'+
		'                     \". Overhead components\",'+
		'                     \"-Operate engine to check for leaks and proper\",'+
		'                     \"operation\",'+
		'                     \"Note:  Refer to the following repair procedures\",'+
		'                     \"and time as necessary:\",'+
		'                     \"-19-045 Aftertreatment Intake Nox Sensor  -Remove\",'+
		'                     \"and Install\"'+
		'                  ],'+
		'                  \"SRTStatusMessage\": \"SRT is present\",'+
		'                  \"StepID\": 128418,'+
		'                  \"SRTTime\":                   {'+
		'                     \"SpecialAccessCode\": \"\",'+
		'                     \"SpecialAccessCodeDescription\": [\"\"],'+
		'                     \"AccessCodeB\": 0.9,'+
		'                     \"AccessCodeA\": 0.8,'+
		'                     \"AccessCodeD\": 1.1,'+
		'                     \"AccessCodeR\": 0,'+
		'                     \"AccessCodeC\": 1'+
		'                  }'+
		'               },'+
		'               \"SRTEventPerfDateTime\": \"2016-04-18T14:52:26.000-04:00\"'+
		'            },'+
		'            \"SRTID\": \"03-122\",'+
		'            \"CaseNumber\": \"K20430055\"'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Resistance Measurements Using a Multimeter and Wiring Diagram, Each Four\",'+
		'            \"VerifyRepeatValue\":             {'+
		'               \"SRTType\": \"VER\",'+
		'               \"Step\":                {'+
		'                  \"Percentage\": 1,'+
		'                  \"SRTModifyDateTime\": \"2015-01-07T13:41:50.000-05:00\",'+
		'                  \"StepDescription\":                   ['+
		'                     \"Step Number-00\",'+
		'                     \"Includes:\",'+
		'                     \"\",'+
		'                     \"-Disconnect and connect:\",'+
		'                     \". Connector halves, if applicable\",'+
		'                     \". Multimeter probes or clips to appropriate\",'+
		'                     \"source\",'+
		'                     \"-Measure Resistance\"'+
		'                  ],'+
		'                  \"SRTStatusMessage\": \"SRT is present\",'+
		'                  \"StepID\": 96551,'+
		'                  \"SRTTime\":                   {'+
		'                     \"SpecialAccessCode\": \"\",'+
		'                     \"SpecialAccessCodeDescription\": [\"\"],'+
		'                     \"AccessCodeB\": 0.1,'+
		'                     \"AccessCodeA\": 0.1,'+
		'                     \"AccessCodeD\": 0.1,'+
		'                     \"AccessCodeR\": 0.1,'+
		'                     \"AccessCodeC\": 0.1'+
		'                  }'+
		'               },'+
		'               \"SRTEventPerfDateTime\": \"2016-04-18T14:52:26.000-04:00\"'+
		'            },'+
		'            \"SRTID\": \"19-360\",'+
		'            \"CaseNumber\": \"K20430055\"'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"Component Connector and Pin - Inspection, Each Four\",'+
		'            \"VerifyRepeatValue\":             {'+
		'               \"SRTType\": \"VER\",'+
		'               \"Step\":                {'+
		'                  \"Percentage\": 1,'+
		'                  \"SRTModifyDateTime\": \"2015-01-07T13:41:50.000-05:00\",'+
		'                  \"StepDescription\":                   ['+
		'                     \"Step Number-00\",'+
		'                     \"\",'+
		'                     \"Note: The following SRTs are NOT included in the\",'+
		'                     \"total time above, but may apply if the work is\",'+
		'                     \"required per CUMMINS published guidelines,\",'+
		'                     \"perfromed and explained on the claim:\",'+
		'                     \"\",'+
		'                     \"-Troubleshoot  -Inactive or Intermittent\",'+
		'                     \"Fault Code(s)\",'+
		'                     \"Includes:\",'+
		'                     \"\",'+
		'                     \"-Connect and disconnect:\",'+
		'                     \". Component or harness connector halves\",'+
		'                     \"-Clean and inspect connector and pin\"'+
		'                  ],'+
		'                  \"SRTStatusMessage\": \"SRT is present\",'+
		'                  \"StepID\": 96550,'+
		'                  \"SRTTime\":                   {'+
		'                     \"SpecialAccessCode\": \"\",'+
		'                     \"SpecialAccessCodeDescription\": [\"\"],'+
		'                     \"AccessCodeB\": 0.1,'+
		'                     \"AccessCodeA\": 0.1,'+
		'                     \"AccessCodeD\": 0.1,'+
		'                     \"AccessCodeR\": 0.1,'+
		'                     \"AccessCodeC\": 0.1'+
		'                  }'+
		'               },'+
		'               \"SRTEventPerfDateTime\": \"2016-04-18T14:52:26.000-04:00\"'+
		'            },'+
		'            \"SRTID\": \"19-361\",'+
		'            \"CaseNumber\": \"K20430055\"'+
		'         },'+
		'                  {'+
		'            \"SRTTitle\": \"\",'+
		'            \"VerifyRepeatValue\":             {'+
		'               \"SRTType\": \"VER\",'+
		'               \"Step\":                {'+
		'                  \"Percentage\": 0,'+
		'                  \"SRTModifyDateTime\": \"\",'+
		'                  \"StepDescription\": [\"\"],'+
		'                  \"SRTStatusMessage\": \"An SRT is not being populated for this EDS Solution as this time overlaps with Administration Time (00-90X), Insite (00-724), or may be included with other Diagnostic Session SRTs.\",'+
		'                  \"StepID\": 0,'+
		'                  \"SRTTime\":                   {'+
		'                     \"SpecialAccessCode\": \"\",'+
		'                     \"SpecialAccessCodeDescription\": [\"\"],'+
		'                     \"AccessCodeB\": 0,'+
		'                     \"AccessCodeA\": 0,'+
		'                     \"AccessCodeD\": 0,'+
		'                     \"AccessCodeR\": 0,'+
		'                     \"AccessCodeC\": 0'+
		'                  }'+
		'               },'+
		'               \"SRTEventPerfDateTime\": \"2016-04-18T14:52:26.000-04:00\"'+
		'            },'+
		'            \"SRTID\": \"\",'+
		'            \"CaseNumber\": \"K91452265\"'+
		'         }'+
		'      ],'+
		'      \"ResponseMessage\": \"2016-10-07T11:10:18.163-04:00\"'+
		'   },'+
		'   \"Header\":    {'+
		'      \"ReturnCodeDescription\": \"2016-10-07T11:10:18.163-04:00\",'+
		'      \"Status\": \"Success\"'+
		'   }'+
		'}';
        CSS_J2ADiagnostic_SRT obj = CSS_J2ADiagnostic_SRT.parse(json);
		System.assert(obj != null);
	}
}