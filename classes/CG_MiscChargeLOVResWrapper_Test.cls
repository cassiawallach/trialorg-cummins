@isTest
public class CG_MiscChargeLOVResWrapper_Test {
    static testMethod void testParse() {
		String json = '{'+
		'	\"DataArea\": [{'+
		'			\"MiscName\": \"Misc Name\",'+
		'			\"MiscDescription\": \"\",'+
		'			\"Multiplier\": 5723046,'+
		'			\"FlatAmount\": 3454,'+
		'			\"Maximum\": 24534,'+
		'			\"AutoCharage\": \"Y\",'+
		'			\"CreditType\": \"BOX 129\"'+
		'		},'+
		'		{'+
		'			\"MiscName\": \"Misc Name\",'+
		'			\"MiscDescription\": \"\",'+
		'			\"Multiplier\": 5723046,'+
		'			\"FlatAmount\": 3454,'+
		'			\"Maximum\": 24534,'+
		'			\"AutoCharage\": \"Y\",'+
		'			\"CreditType\": \"BOX 129\"'+
		'		}'+
		'	],'+
		'	\"Header\": {'+
		'		\"Status\": \"SUCCESS\",'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"getMISCChargeLOVs\",'+
		'			\"SenderID\": \"BMS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"CSS\"'+
		'		},'+
		'		\"Location\": {'+
		'			\"LocationID\": \"56270-56255\"'+
		'		}'+
		'	}'+
		'}';
		CG_MiscChargeLOVResWrapper obj = CG_MiscChargeLOVResWrapper.parse(json);
		System.assert(obj != null);
	}
}