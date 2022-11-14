@IsTest
public class CSS_getBasicCoverageReqJ2A_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '    \"Header\": '+
        '    {'+
        '        \"Sender\": '+
        '        {'+
        '            \"ServiceName\": \"GetDetailCoverage\",'+
        '            \"SenderID\": \"CSS\"'+
        '        },'+
        '        \"Target\": { \"TargetID\": \"SIEBEL\" }'+
        '    },'+
        '    \"DataArea\": '+
        '    {'+
        '        \"ESN\": \"33137149\",'+
        '        \"SPCode\": \"37320\",'+
        '        \"FailureDate\": \"5/1/2016\",'+
        '        \"FailurePoint\": \"120\",'+
        '        \"FailureMeasure\": \"Miles\",'+
        '        \"EngineApplicationCode\": \"130\",'+
        '        \"SystemCode\": \"IR\",'+
        '        \"ComponentCode\": \"TC\",'+
        '        \"FaultCode\": \"1121\",'+
        '        \"WarrantyStartDate\": \"5/1/2010\",'+
        '        \"CampaignNumber\": \"1-89798987\",'+
        '        \"NewPartsWrntyFlg\": \"Y\",'+
        '        \"ReconPartsWrntyFlg\": \"Y\",'+
        '        \"RoadRelayWrntyFlg\": \"Y\",'+
        '        \"AccountCode\": \"98\"'+
        '    }'+
        '}';
        CSS_getBasicCoverageReqJ2A obj = CSS_getBasicCoverageReqJ2A.parse(json);
        System.assert(obj != null);
    }
}