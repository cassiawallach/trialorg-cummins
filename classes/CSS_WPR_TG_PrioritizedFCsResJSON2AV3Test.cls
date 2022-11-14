@istest
public class CSS_WPR_TG_PrioritizedFCsResJSON2AV3Test {
    static testmethod void testmethod1()
    {
        string json='{ "Header": { "ServiceName": "oh559", "ServiceVersion": "oh559", "Status": "oh559", "ReturnCodeDescription": "oh559", "TxnCodeDescription": "oh559" }, "DataArea": { "prioritizedData": [ { "relfc": [ { "rfc": "oh559" } ], "prifc": "oh559" } ], "UnPrioritizedData": [ { "upfc": "oh559", "rc": "oh559" } ], "CSSEnabled": "oh559", "IASNumber": "oh559", "algorithm": "oh559", "PSN": "DecisionID" } }';
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3.parse(json);
    }

}