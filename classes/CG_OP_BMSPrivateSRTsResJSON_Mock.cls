@isTest
global class CG_OP_BMSPrivateSRTsResJSON_Mock implements httpcalloutmock {
   global httpresponse respond(httprequest req) 
   {
       httpresponse res = new httpresponse();
       res.setStatus('success');
       res.setHeader('Content-Type', 'application/json');
       res.setStatusCode(200);
      
//	string json='	{		"Header": {		"Status": "SUCCESS",		"Sender": {		"ServiceName": "getBMSPrivateSRTs",		"SenderID": "BMS"		 },		"Target": {		"TargetID": "CSS"		},		"Location": {		"LocationID": "56270-56255"		 }	              },		"DataArea": [		 {		"EngineFamily": "",		"SRTGroup": "",		"SRTProcedure": "",		"SRTStep": "",		"Title": "",		"AccessCode": "",		"Hours": 2.3,		"Troubleshoot": "",		"Flexible": "",		 "Private": "",		"Special": "",		"RegionCode": ""	},		   {		"EngineFamily": "",		"SRTGroup": "",		"SRTProcedure": "",		"SRTStep": "",		"Title": "",	              "AccessCode": "",		"Hours": 0.1,		"Troubleshoot": "",		"Flexible": "",		"Private": "",		"Special": "",		"RegionCode": ""		}	               ]		}';
	String json = '{"DataArea":[{"Special":"N","SRTProcedure":"850","Hours":"0","EngineFamily":"10","SRTStep":"","SRTGroup":"00","Flexible":"Y","AccessCode":"C","Title":"PM FULL SERVICE","RegionCode":"CENTRAL","Troubleshoot":"N","Private":"Y"},{"Special":"N","SRTProcedure":"850","Hours":"0","EngineFamily":"10","SRTStep":"","SRTGroup":"00","Flexible":"Y","AccessCode":"C","Title":"PM FULL SERVICE","RegionCode":"CENTRAL","Troubleshoot":"N","Private":"Y"},{"Special":"N","SRTProcedure":"TRN","Hours":"0","EngineFamily":"10","SRTStep":"","SRTGroup":"99","Flexible":"Y","AccessCode":"B","Title":"TECHNICIAN TRAINING","RegionCode":"CENTRAL","Troubleshoot":"N","Private":"Y"}],"Header":{"Status":"SUCCESS","Sender":{"ServiceName":"GetBMSPrivateSRTs","MessageID":"72497242-d5fe-4d73-904a-cee23845a929","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"03520-04892"}}}';
        res.setbody(json);
       return res;
   }

}