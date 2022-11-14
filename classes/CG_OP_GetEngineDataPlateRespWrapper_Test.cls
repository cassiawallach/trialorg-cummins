@IsTest
public class CG_OP_GetEngineDataPlateRespWrapper_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"engineSerialNumber\": \"79462241\",'+
		'    \"data\": ['+
		'        {'+
		'            \"vin\": \"1NPTX4EX3CD137011\",'+
		'            \"marketingEngineModel\": \"ISX15 450\",'+
		'            \"serviceEngineModel\": \"ISX15 CM2250\",'+
		'            \"epaModelName\": \"BCEXH0912XAP\",'+
		'            \"engineBuildPlant\": \"JEP - JAMESTOWN ENGINE PLANT\",'+
		'            \"engineBuildDate\": \"2011-02-23T00:00:00Z\",'+
		'            \"warrantyStartDate\": \"2012-03-16T00:00:00Z\",'+
		'            \"ecmCode\": \"CL10135\",'+
		'            \"fuelPumpPartNumber\": \"4088507\",'+
		'            \"fuelPumpCalibration\": \"P846\",'+
		'            \"marketingConfig\": \"D103009BB09\",'+
		'            \"technicalConfig\": \"D103009BX03\",'+
		'            \"cplNumber\": \"CPL3719\",'+
		'            \"customerNumber\": \"1608\",'+
		'            \"shopOrder\": \"SO33045\",'+
		'            \"businessUnit\": \"EBU\"'+
		'        }'+
		'    ]'+
		'}';
		CG_OP_GetEngineDataPlateRespWrapper obj = CG_OP_GetEngineDataPlateRespWrapper.parse(json);
		System.assert(obj != null);
	}
}