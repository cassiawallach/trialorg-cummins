@IsTest
public class CG_FieldActionSRTRequest_TEST {
	
	static testMethod void testParse() {
		String json = '{ '+
		'\"Header\":{ '+
		'\"Sender\":{ '+
		'\"MessageID\":\"MessageID\", '+
		'\"ServiceName\":\"ServiceName\", '+
		'\"SenderID\":\"SenderID\" '+
		'}, '+
        '\"Target\": {'+
        '\"TargetID\":\"TargetID\"'+
        '}'+
   		'},'+
       	'\"DataArea\":{ '+
		'\"DTTimestamp\":\"DTTimestamp\", '+
		'\"EngineFamilyCode\":\"EngineFamilyCode\", '+
		'\"EquipmentID\":\"EquipmentID\", '+
	    '\"ServiceModelName\":\"ServiceModelName\", '+
	    '\"EffectiveDTTime\":\"EffectiveDTTime\", '+
		'\"Language\":\"Language\",'+
		 '\"FieldAction\": ['+
    '   {'+
	        '\"FieldActionNumber\":\"FieldActionNumber\",' + 
            ' \"FieldActionType\":\"FieldActionType\",' +
			' \"SRTTab\":\"SRTTab\"' +
        '}'+
            ']}'+			
		'}';
		CG_FieldActionSRTRequest cg1 = CG_FieldActionSRTRequest.parse(json);
		System.assert(cg1 != null);
        system.debug('jsonrequest:>>>'+cg1);
	}
}