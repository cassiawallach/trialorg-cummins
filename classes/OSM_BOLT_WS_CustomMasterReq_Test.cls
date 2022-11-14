/************************************************************
Name:  OSM_BOLT_WS_CustomMasterReq_Test 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is JSON2Apex test class for customer inbound interface
request class
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Moulika G         05/04/2018     INITIAL DEVELOPMENT          


*************************************************************/
@IsTest
public class OSM_BOLT_WS_CustomMasterReq_Test {
    
    static testMethod void testParse() {
        String json = '{'+
                    '   \"DataArea\": {'+
                    '      \"CUST_O_STG_ROW\": {'+
                    '         \"ATTRIBUTE3\": null,'+
                    '         \"ATTRIBUTE2\": null,'+
                    '         \"PARTY_NAME\": \"USA TRUCK INC.\",'+
                    '         \"ATTRIBUTE1\": null,'+
                    '         \"ORIG_SYSTEM_REFERENCE\": \"2363917\",'+
                    '         \"PARTY_NUMBER\": \"2434010\",'+
                    '         \"ATTRIBUTE9\": null,'+
                    '         \"ATTRIBUTE8\": null,'+
                    '         \"CUST_ACCTS_O_STG\": {'+
                    '            \"CUST_ACCTS_O_STG_ROW\": {'+
                    '               \"ATTRIBUTE3\": null,'+
                    '               \"ATTRIBUTE2\": null,'+
                    '               \"ATTRIBUTE1\": null,'+
                    '               \"ACCOUNT_NUMBER\": \"409280\",'+
                    '               \"ACCT_SITES_O_STG\": {'+
                    '                  "ACCT_SITES_O_STG_ROW\": ['+
                    '                     {'+
                    '                        \"RECEIVABLE_ACCOUNT\": \"0\",'+
                    '                        \"ADDRESS2\": null,'+
                    '                        \"BC_CODE\": \"598\",'+
                    '                        \"ADDRESS3\": null,'+
                    '                        \"ADDRESS1\": \"3200 INDUSTRIAL PARK RD\",'+
                    '                        \"SITE_USE_ATTRIBUTE10\": null,'+
                    '                        \"ACCOUNT_SITE_ACTION_TYPE\": \"SYNC\",'+
                    '                        \"LOCATION_ATTRIBUTE10\": null,'+
                    '                        \"SITE_USE_STATUS\": \"A\",'+
                    '                        \"ADDRESS4\": null,'+
                    '                        \"CITY\": \"VAN BUREN\",'+
                    '                        \"POSTAL_CODE\": \"72956-6110\",'+
                    '                        \"PARTY_SITE_STATUS\": \"A\",'+
                    '                        \"STATE\": \"AR\",'+
                    '                        \"ENTITY_CODE\": null,'+
                    '                        \"COUNTY\": \"CRAWFORD\",'+
                    '                        \"ADDRESS_LINES_PHONETIC\": null,'+
                    '                        \"IDENTIFYING_ADDRESS_FLAG\": \"Y\",'+
                    '                        \"BOLT_OPERATING_UNIT\": \"US CBS Columbus 598\",'+
                    '                        \"GLOBAL_ATTRIBUTE6\": null,'+
                    '                        \"GLOBAL_ATTRIBUTE7\": null,'+
                    '                        \"GLOBAL_ATTRIBUTE4\": null,'+
                    '                        \"GLOBAL_ATTRIBUTE5\": null,'+
                    '                        \"PRIMARY_FLAG\": \"Y\",'+
                    '                        \"SITE_USE_ATTRIBUTE3\": null,'+
                    '                        \"GLOBAL_ATTRIBUTE2\": null,'+
                    '                        \"ACC_SITE_STATUS\": \"A\",'+
                    '                        \"SITE_USE_ATTRIBUTE2\": null,'+
                    '                        \"GLOBAL_ATTRIBUTE3\": null,'+
                    '                        \"COUNTRY\": \"US\",'+
                    '                        \"SITE_USE_ATTRIBUTE1\": null,'+
                    '                        \"LOCATION_ATTRIBUTE1\": null,'+
                    '                        \"GLOBAL_ATTRIBUTE1\": null,'+
                    '                        \"SITE_USE_ATTRIBUTE7\": null,'+
                    '                        \"SITE_USE_ATTRIBUTE6\": null,'+
                    '                        \"SITE_USE_ATTRIBUTE5\": null,'+
                    '                        \"ACC_SITE_REFERENCE\": \"10145832\",'+
                    '                        \"SITE_USE_ATTRIBUTE4\": null,'+
                    '                        \"GLOBAL_ATTRIBUTE8\": null,'+
                    '                        \"SITE_USE_ATTRIBUTE9\": null,'+
                    '                        \"GLOBAL_ATTRIBUTE9\": null,'+
                    '                        \"SITE_USE_ATTRIBUTE8\": null,'+
                    '                        \"LOCATION\": \"3200 INDUSTRIAL PARK ROAD\",'+
                    '                        \"PROVINCE\": null,'+
                    '                        \"LOCATION_ATTRIBUTE2\": null,'+
                    '                        \"LOCATION_ATTRIBUTE3\": null,'+
                    '                        \"LOCATION_ATTRIBUTE4\": null,'+
                    '                        \"SITE_USE_CODE\": \"BILL_TO\",'+
                    '                        \"LOCATION_ATTRIBUTE5\": null,'+
                    '                        \"LOCATION_ATTRIBUTE6\": null,'+
                    '                        \"ADDRESS_ACTION_TYPE\": \"UPDATE\",'+
                    '                        \"LOCATION_ATTRIBUTE7\": null,'+
                    '                        \"GLOBAL_ATTRIBUTE_CATEGORY\": null,'+
                    '                        \"LOCATION_ATTRIBUTE8\": null,'+
                    '                        \"LOCATION_ATTRIBUTE9\": null'+
                    '                     }'+
                    '                  ]'+
                    '               },'+
                    '               \"ATTRIBUTE11\": null,'+
                    '               \"TAXPAYER_ID\": null,'+
                    '               \"ATTRIBUTE9\": null,'+
                    '               \"ACCOUNT_REFERENCE\": \"10900239\",'+
                    '               \"STATUS\": \"A\",'+
                    '               \"ATTRIBUTE7\": \"No\",'+
                    '               \"CUSTOMER_TYPE\": \"R\",'+
                    '               \"ATTRIBUTE10\": null,'+
                    '               \"ATTR_CONTEXT\": \"R\",'+
                    '               \"ATTRIBUTE6\": null,'+
                    '               \"ATTRIBUTE5\": null,'+
                    '               \"ATTRIBUTE4\": null,'+
                    '               \"PROFILE_CLASS\": \"DEFAULT\",'+
                    '               \"CUSTOMER_ACTION_TYPE\": \"SYNC\",'+
                    '               \"ALTERNATE_NAME\": null,'+
                    '               \"CUSTOMER_CLASS_CODE\": null,'+
                    '               \"CREDIT_HOLD\": \"N\"'+
                    '            }'+
                    '         },'+
                    '         \"STATUS\": \"A\",'+
                    '         \"ATTRIBUTE7\": null,'+
                    '         \"ATTRIBUTE10\": null,'+
                    '         \"ATTR_CONTEXT\": null,'+
                    '         \"ATTRIBUTE6\": null,'+
                    '         \"ATTRIBUTE5\": null,'+
                    '         \"ATTRIBUTE4\": null,'+
                    '         \"PARTY_TYPE\": \"ORGANIZATION\"'+
                    '      }'+
                    '   },'+
                    '   \"Header\": {'+
                    '      \"Sender\": {'+
                    '         \"ServiceName\": \"CustomerMasterOutbound\",'+
                    '         \"SenderID\": \"BOLT\"'+
                    '      },'+
                    '      \"Target\": {'+
                    '         \"TargetID\": \"OSM\"'+
                    '      }'+
                    '   }'+
                    '}';
        OSM_BOLT_WS_CustomMasterReq obj = OSM_BOLT_WS_CustomMasterReq.parse(json);
        System.assert(obj != null);
    }
}