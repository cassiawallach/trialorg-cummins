@istest
public class CG_OP_GetSPInfoResJSON_Test {
static testmethod void testmethod1(){
string json = '{ "DataArea": [ { "PROMOTION_ID_FLAG": "Y", "SP_CERTIFICATION": [ { "SMN": "ISB CM2150", "OEM_NAME": "PETERBILT OF CANADA LTD", "OEM_CODE": "PETERBILT OF CANADA LTD", "START_DATE": "", "SERVICE_LEVEL": "", "PRODUCT_DETAILS": [ { "PRODUCT_RANGE": "TestingRange", "MARKET_APPLICATION": "Engine", "PRODUCT_TYPE": "Engine" } ], "END_DATE": "" } ], "SP_CODE": 23456, "PRODUCT_CERTIFICATION_FLAG": "Y", "SP_NAME": "Gopal", "SP_CHANNEL_OF_DISTRIBUTION": "101", "TERRITORY": "CANADA", "WRNTY_TRAINING_CERTIFICATION": "Y", "REGION": "NORTH AMERICA", "SP_CHANNEL_CODE": "101", "RSS_RESP_BRANCH_CODE": "101", "RSS_RESP_BRANCH_NAME": "101", "RESP_BRANCH_CODE": "101", "RESP_BRANCH_NAME": "101", "SP_BILL_TO_CODE": "101", "SP_BILL_TO_NAME": "101", "DIST_HQ_CODE": "101", "DIST_HQ_NAME": "101", "SP_FIRST_NAME": "101", "SP_LAST_NAME": "101", "SP_PHONE": "101", "SP_EMAIL": "101", "WWSPS_FLAG": "101", "ACCOUNT_STATUS": "101", "BUSINESS_UNIT": "101", "SP_RECERTIFICATION_DATE": "101", "CREATED_DATE": "101", "UPDATED_DATE": "101", "CERTIFICATION_END_DATE": "101", "WARRANTY_TRAINING_STATUS": "101" } ], "Header": { "ReturnCodeDescription": "", "Status": "Success", "ReturnCode": "", "MessageIdentifier": "2017-06-04" } }';
CG_OP_GetSPInfoResJSON op = CG_OP_GetSPInfoResJSON.parse(json);
system.assert(op.DataArea!=null);
system.assert(op!=null);   
         }
}