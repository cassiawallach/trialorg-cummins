//Added Comments for test class Validation
@IsTest
public class CSS_JSON2APEXINSITER2_Test {
    
    static testMethod void testParse() {
        string JSONReq ='{"CJOD":"1234","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","LOCATION_ID":"11111","TI":"123ABC", "module":[';
        JSONReq += '{ "mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs2.8","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF","IMGCSV":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"12"},{"field":2, "value":"231"},{"field":22,"value":"Data Vaue"}],"FD":{ "APD":[{"P":340,"R":[65,75]},{"P":414, "R":[645,755] }],"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}},"PAT":"A","FDCount":[{"FC":340, "count":10,"status":"A"}, { "FC":414,"count":12, "status":"I"},{ "FC":414,"count":12, "status":"I"},{"FC":230, "count":9,"status":"I"},{"FC":222, "count":8,"status":"A"}]},';
        JSONReq += '{"mod":1,"header":{"CUSTNAME":"Anirudh", "UNT":5432345,"CORE":"GITs2.8","ESN":"ABCDSASERDF","ERT":1233453456, "ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"34"}, { "field":2,"value":"342"}, { "field":22,"value":"Data Vaue" }],"FD":{"APD":[ { "P":340,"R":[65,75 ]},{"P":414,"R":[645,755]}], "BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}},"PAT":"A","FDCount":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I" },{ "FC":414,"count":12, "status":"I"},{"FC":230, "count":9,"status":"I"},{"FC":222, "count":8,"status":"A"}]} ] }';
        
        CSS_JSON2APEXINSITER2 obj = CSS_JSON2APEXINSITER2.parse(JSONReq);
        System.assert(obj != null);
    }
}