/*
 * Class Name : CSS_getPartsListSRTRequestJ2A_Test
 * Purpose : Class to cover the unit test cases
 * Developer : Rakesh Kumar
 * Created Date : 11/02/2016
 * 
 */
@istest
public class CSS_getPartsListSRTRequestJ2A_Test {
    
    //Test Method to cover the request wrapper class
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"GetPartsListSRT\",'+
		'			\"SenderID\": \"CSS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"SRT\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"Jobid\": \"CSS-000001234\",'+
		'		\"ClaimID\": \"C100002045\",'+
		'		\"Languagecode\": \"en\",'+
		'		\"EngineFamilyCode\": \"10\",'+
		'		\"ServiceModelName\": \" ISX15 CM2350 X101\",'+
		'		\"EquipmentID\": \" EQ1234\",'+
		'		\"DTTimestamp\": \"DD-MMM-YY HH:MI:SS AM\",'+
		'		\"EffectiveDTTime\": \"DD-MMM-YY HH:MI:SS AM\",'+
		'		\"FailureID\": ['+
		'			\"F19000580\",'+
		'			\"F19000678\"'+
		'		],'+
		'		\"OptionsList\": ['+
		'			\"Option1\",'+
		'			\"Option2\"'+
		'		]'+
		'	}'+
		'}';
		CSS_getPartsListSRTRequestJ2A obj = CSS_getPartsListSRTRequestJ2A.parse(json);
		System.assert(obj != null);
	}
}