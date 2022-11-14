@IsTest
public class CSS_WPR_SBL_GetWarrantyReqJSON_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"Sender\": {'+
        '           \"MessageID\": \"UniqueID\",'+
        '           \"ServiceName\": \"AccCoverage\",'+
        '           \"SenderID\": \"CSS\"'+
        '       }'+
        '   },'+
        '   \"DataArea\": {'+
        '       \"Esn\": \"79655093\",'+
        '       \"SPCode\": \"37383\",'+
        '       \"FailureDate\": \"3/7/2017\",'+
        '       \"FailurePoint\": \"5567\",'+
        '       \"FailureMeasure\": \"Miles\",'+
        '       \"EngineApplicationCode\": \"130\",'+
        '       \"FaultCode\": \"\",'+
        '       \"WarrantyStartDate\": \"6/26/2013\",'+
        '       \"CampaignNumber\": \"\",'+
        '       \"NewPartsWrntyFlg\": \"N\",'+
        '       \"ReconPartsWrntyFlg\": \"N\",'+
        '       \"RoadRelayWrntyFlg\": \"N\",'+
        '       \"AccountCode\": \"\",'+
        '       \"Details\": ['+
        '           {'+
        '               \"SystemCode\": \"BK\",'+
        '               \"ComponentCode\": \"CA\"'+
        '           }'+
        '       ]'+
        '   }'+
        '}';
        
        CSS_WPR_SBL_GetWarrantyReqJSON obj = CSS_WPR_SBL_GetWarrantyReqJSON.parse(json);
        System.assert(obj != null);
    }
}