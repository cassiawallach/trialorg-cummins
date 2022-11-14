@IsTest
public class CG_OP_CampaignsResJSON_Test {

static testMethod void testParse(){

   string json='{ "DataArea": { "Details": [ { "CampaignDesc": "TRP FOR MCRS FUEL PUMP FAILURES TO INSTALL EPLV SYSTEM ON ENGINES", "CampaignEndDate": "2017-12-31", "CampaignStartDate": "2016-08-23", "SrtList": [ { "SrtCode": "00-901-00", "SrtDescription": "Administrative Time - Open and Close Repair Order (Shop Repairs)" } ], "FailCode": "WFHA", "FailMode": "SR", "InShopSrtLimitFlag": "N", "Status": "Approved", "MultipleTimes": "N", "BusinessUnit": "CMI", "CampaignType": "TRP", "CompleteIndicator": "N", "PartList": [ { "PartQuantity": 1, "PartNumber": 540571400, "PartDescription": "KIT,SERVICE" } ], "CampaignNumber": "1820" } ] }, "Header": { "ReturnCodeDescription": "ReturnCodeDescription", "Status": "Success" } }';
CG_OP_CampaignsResJSON obj = CG_OP_CampaignsResJSON.parse(json);
System.assert(obj != null);
}
}