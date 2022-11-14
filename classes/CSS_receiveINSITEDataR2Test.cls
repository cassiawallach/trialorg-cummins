@isTest(SeeAllData=True)
public class CSS_receiveINSITEDataR2Test{

    public static testMethod void testJobOrderData(){
        Test.startTest();
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        //jobOrder.Name = 'CC123456';
        jobOrder.Status__c = 'Created/Not Assigned';
        insert jobOrder;

        String jobName = [SELECT Name FROM CSS_Job_Order__c WHERE Id =: jobOrder.Id].Name;

        /*string JSONReq = '{"CUSTNAME" : "Paul","CJOD" : "'+jobName+'","TI" : "123ABC","UNT"  : "5435","ESN":"ABCDERDF","ERT":"123456", "TMS":"2012-04-23T18:25:43.511Z",';
        JSONReq += '"FaultCode": [{"FD": {"APD": [{"P": "340","R": ["65","75"]},{"P": "414","R": ["645","755"]}],';
        JSONReq += '"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}},"IMGNM": "IMG123","Mod": "0","PAT": "A"}]}';
        */
        /*string JSONReq ='{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC", "module":[';
        JSONReq += '{ "mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs2.8","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"12"},{"field":2, "value":"231"},{"field":22,"value":"Data Vaue"}],"FD":[{ "APD":[{"P":340,"R":[65,75]},{"P":414, "R":[645,755] }],"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]},"PAT":"A"}],"FDCountFDMeta":[{"FC":340, "count":10,"status":"A"}, { "FC":414,"count":12, "status":"I"},{"FC":1, "count":13,"status":"A"},{"FC":2, "count":14,"status":"I"},{"FC":22, "count":15,"status":"A"},{"FC":33, "count":16,"status":"A"},{"FC":334, "count":20,"status":"A"},{"FC":563, "count":17,"status":"I"}]},';
        JSONReq += '{"mod":1,"header":{"CUSTNAME":"Anirudh", "UNT":5432345,"CORE":"GITs2.8","ESN":"ABCDSASERDF","ERT":1233453456, "ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"34"}, { "field":2,"value":"342"}, { "field":22,"value":"Data Vaue" }],"FD":[{"APD":[ { "P":340,"R":[65,75 ]},{"P":414,"R":[645,755]}], "BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}, "PAT":"A"}],"FDCountFDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I" },{"FC":1, "count":13,"status":"A"},{"FC":2, "count":14,"status":"I"},{"FC":22, "count":15,"status":"A"},{"FC":33, "count":16,"status":"A"},{"FC":334, "count":20,"status":"A"},{"FC":563, "count":17,"status":"I"}]} ] }';*/

        String JSONReq = '{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC","module":[{"mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs38","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"12"},{"field":2,"value":"231"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["3","4"],"UFD":{"UPA":["222","333"],"UPI":["434","363"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]},{"mod":1,"header":{"CUSTNAME":"Anirudh","UNT":5432345,"CORE":"GITs45","ESN":"ABCDSASERDF","ERT":1233453456,"ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"34"},{"field":2,"value":"342"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["1","2"],"UFD":{"UPA":["22", "33"],"UPI":["334", "563"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]}]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/InsiteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;

        //string results = CSS_receiveINSITEDataR2.updateJobOrderData();
        CSS_receiveINSITEDataR2.updateJobOrderData();
        Test.stopTest();
    }


    public static testMethod void testJobOrderDataClosed(){
        Test.startTest();
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        //jobOrder.Name = 'CC123456';
        jobOrder.Status__c = 'Closed';
        insert jobOrder;

        String jobName = [SELECT Name FROM CSS_Job_Order__c WHERE Id =: jobOrder.Id].Name;

        /*string JSONReq = '{"CUSTNAME" : "Paul","CJOD" : "'+jobName+'","TI" : "123ABC","UNT"  : "5435","ESN":"ABCDERDF","ERT":"123456", "TMS":"2012-04-23T18:25:43.511Z",';
        JSONReq += '"FaultCode": [{"FD": {"APD": [{"P": "340","R": ["65","75"]},{"P": "414","R": ["645","755"]}],';
        JSONReq += '"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}},"IMGNM": "IMG123","Mod": "0","PAT": "A"}]}';
        */
        /*string JSONReq ='{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC", "module":[';
        JSONReq += '{ "mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs2.8","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"12"},{"field":2, "value":"231"},{"field":22,"value":"Data Vaue"}],"FD":[{ "APD":[{"P":340,"R":[65,75]},{"P":414, "R":[645,755] }],"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]},"PAT":"A"}],"FDCountFDMeta":[{"FC":340, "count":10,"status":"A"}, { "FC":414,"count":12, "status":"I"},{"FC":1, "count":13,"status":"A"},{"FC":2, "count":14,"status":"I"},{"FC":22, "count":15,"status":"A"},{"FC":33, "count":16,"status":"A"},{"FC":334, "count":20,"status":"A"},{"FC":563, "count":17,"status":"I"}]},';
        JSONReq += '{"mod":1,"header":{"CUSTNAME":"Anirudh", "UNT":5432345,"CORE":"GITs2.8","ESN":"ABCDSASERDF","ERT":1233453456, "ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"34"}, { "field":2,"value":"342"}, { "field":22,"value":"Data Vaue" }],"FD":[{"APD":[ { "P":340,"R":[65,75 ]},{"P":414,"R":[645,755]}], "BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}, "PAT":"A"}],"FDCountFDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I" },{"FC":1, "count":13,"status":"A"},{"FC":2, "count":14,"status":"I"},{"FC":22, "count":15,"status":"A"},{"FC":33, "count":16,"status":"A"},{"FC":334, "count":20,"status":"A"},{"FC":563, "count":17,"status":"I"}]} ] }';*/

        String JSONReq = '{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC","module":[{"mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs38","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"12"},{"field":2,"value":"231"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["1","2"],"UFD":{"UPA":["22","33"],"UPI":["334","563"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]},{"mod":1,"header":{"CUSTNAME":"Anirudh","UNT":5432345,"CORE":"GITs45","ESN":"ABCDSASERDF","ERT":1233453456,"ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"34"},{"field":2,"value":"342"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["1","2"],"UFD":{"UPA":["22","33"],"UPI":["334","563"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]}]}';

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/InsiteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;

        //string results = CSS_receiveINSITEDataR2.updateJobOrderData();
        CSS_receiveINSITEDataR2.updateJobOrderData();
        Test.stopTest();
    }
    public static testMethod void testJobOrderDataESNLockedFal(){
        Test.startTest();
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        //jobOrder.Name = 'CC123456';
        jobOrder.Status__c = 'Created/Not Assigned';
        jobOrder.ESN_Locked__c = false;
        insert jobOrder;

        String jobName = [SELECT Name FROM CSS_Job_Order__c WHERE Id =: jobOrder.Id].Name;

        /*string JSONReq = '{"CUSTNAME" : "Paul","CJOD" : "'+jobName+'","TI" : "123ABC","UNT"  : "5435","ESN":"ABCDERDF","ERT":"123456", "TMS":"2012-04-23T18:25:43.511Z",';
        JSONReq += '"FaultCode": [{"FD": {"APD": [{"P": "340","R": ["65","75"]},{"P": "414","R": ["645","755"]}],';
        JSONReq += '"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}},"IMGNM": "IMG123","Mod": "0","PAT": "A"}]}';
        */
        /*string JSONReq ='{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC", "module":[';
        JSONReq += '{ "mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs2.8","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"12"},{"field":2, "value":"231"},{"field":22,"value":"Data Vaue"}],"FD":[{ "APD":[{"P":340,"R":[65,75]},{"P":414, "R":[645,755] }],"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]},"PAT":"A"}],"FDCountFDMeta":[{"FC":340, "count":10,"status":"A"}, { "FC":414,"count":12, "status":"I"},{"FC":1, "count":13,"status":"A"},{"FC":2, "count":14,"status":"I"},{"FC":22, "count":15,"status":"A"},{"FC":33, "count":16,"status":"A"},{"FC":334, "count":20,"status":"A"},{"FC":563, "count":17,"status":"I"}]},';
        JSONReq += '{"mod":1,"header":{"CUSTNAME":"Anirudh", "UNT":5432345,"CORE":"GITs2.8","ESN":"ABCDSASERDF","ERT":1233453456, "ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"34"}, { "field":2,"value":"342"}, { "field":22,"value":"Data Vaue" }],"FD":[{"APD":[ { "P":340,"R":[65,75 ]},{"P":414,"R":[645,755]}], "BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}, "PAT":"A"}],"FDCountFDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I" },{"FC":1, "count":13,"status":"A"},{"FC":2, "count":14,"status":"I"},{"FC":22, "count":15,"status":"A"},{"FC":33, "count":16,"status":"A"},{"FC":334, "count":20,"status":"A"},{"FC":563, "count":17,"status":"I"}]} ] }';*/

        String JSONReq = '{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC","module":[{"mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs38","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"12"},{"field":2,"value":"231"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["3","4"],"UFD":{"UPA":["222","333"],"UPI":["434","363"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]},{"mod":1,"header":{"CUSTNAME":"Anirudh","UNT":5432345,"CORE":"GITs45","ESN":"ABCDSASERDF","ERT":1233453456,"ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"34"},{"field":2,"value":"342"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["1","2"],"UFD":{"UPA":["22", "33"],"UPI":["334", "563"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]}]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/InsiteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;

        //string results = CSS_receiveINSITEDataR2.updateJobOrderData();
        CSS_receiveINSITEDataR2.updateJobOrderData();
        Test.stopTest();
    }
    public static testMethod void testJobOrderDataESNLockedTrue(){
        Test.startTest();
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        //jobOrder.Name = 'CC123456';
        jobOrder.Status__c = 'Created/Not Assigned';
        jobOrder.ESN_Locked__c = true;
        jobOrder.ESN__c = 'ABCDSASERDF';
        jobOrder.ESN_Insite__c = 'ABCDSASERDF';
        insert jobOrder;

        String jobName = [SELECT Name FROM CSS_Job_Order__c WHERE Id =: jobOrder.Id].Name;

        /*string JSONReq = '{"CUSTNAME" : "Paul","CJOD" : "'+jobName+'","TI" : "123ABC","UNT"  : "5435","ESN":"ABCDERDF","ERT":"123456", "TMS":"2012-04-23T18:25:43.511Z",';
        JSONReq += '"FaultCode": [{"FD": {"APD": [{"P": "340","R": ["65","75"]},{"P": "414","R": ["645","755"]}],';
        JSONReq += '"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}},"IMGNM": "IMG123","Mod": "0","PAT": "A"}]}';
        */
        /*string JSONReq ='{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC", "module":[';
        JSONReq += '{ "mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs2.8","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"12"},{"field":2, "value":"231"},{"field":22,"value":"Data Vaue"}],"FD":[{ "APD":[{"P":340,"R":[65,75]},{"P":414, "R":[645,755] }],"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]},"PAT":"A"}],"FDCountFDMeta":[{"FC":340, "count":10,"status":"A"}, { "FC":414,"count":12, "status":"I"},{"FC":1, "count":13,"status":"A"},{"FC":2, "count":14,"status":"I"},{"FC":22, "count":15,"status":"A"},{"FC":33, "count":16,"status":"A"},{"FC":334, "count":20,"status":"A"},{"FC":563, "count":17,"status":"I"}]},';
        JSONReq += '{"mod":1,"header":{"CUSTNAME":"Anirudh", "UNT":5432345,"CORE":"GITs2.8","ESN":"ABCDSASERDF","ERT":1233453456, "ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"34"}, { "field":2,"value":"342"}, { "field":22,"value":"Data Vaue" }],"FD":[{"APD":[ { "P":340,"R":[65,75 ]},{"P":414,"R":[645,755]}], "BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}, "PAT":"A"}],"FDCountFDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I" },{"FC":1, "count":13,"status":"A"},{"FC":2, "count":14,"status":"I"},{"FC":22, "count":15,"status":"A"},{"FC":33, "count":16,"status":"A"},{"FC":334, "count":20,"status":"A"},{"FC":563, "count":17,"status":"I"}]} ] }';*/

        String JSONReq = '{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC","module":[{"mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs38","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"12"},{"field":2,"value":"231"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["3","4"],"UFD":{"UPA":["222","333"],"UPI":["434","363"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]},{"mod":1,"header":{"CUSTNAME":"Anirudh","UNT":5432345,"CORE":"GITs45","ESN":"ABCDSASERDF","ERT":1233453456,"ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"34"},{"field":2,"value":"342"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["1","2"],"UFD":{"UPA":["22", "33"],"UPI":["334", "563"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]}]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/InsiteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;

        //string results = CSS_receiveINSITEDataR2.updateJobOrderData();
        CSS_receiveINSITEDataR2.updateJobOrderData();
        Test.stopTest();
    }
    public static testMethod void testJobOrderDataESNLockedTrueFal(){
        Test.startTest();
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        //jobOrder.Name = 'CC123456';
        jobOrder.Status__c = 'Created/Not Assigned';
        jobOrder.ESN_Locked__c = true;
        jobOrder.ESN__c = 'ABCDSASERDF';
        jobOrder.ESN_Insite__c = 'ABCDSA';
        insert jobOrder;

        String jobName = [SELECT Name FROM CSS_Job_Order__c WHERE Id =: jobOrder.Id].Name;

        /*string JSONReq = '{"CUSTNAME" : "Paul","CJOD" : "'+jobName+'","TI" : "123ABC","UNT"  : "5435","ESN":"ABCDERDF","ERT":"123456", "TMS":"2012-04-23T18:25:43.511Z",';
        JSONReq += '"FaultCode": [{"FD": {"APD": [{"P": "340","R": ["65","75"]},{"P": "414","R": ["645","755"]}],';
        JSONReq += '"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}},"IMGNM": "IMG123","Mod": "0","PAT": "A"}]}';
        */
        /*string JSONReq ='{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC", "module":[';
        JSONReq += '{ "mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs2.8","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"12"},{"field":2, "value":"231"},{"field":22,"value":"Data Vaue"}],"FD":[{ "APD":[{"P":340,"R":[65,75]},{"P":414, "R":[645,755] }],"BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]},"PAT":"A"}],"FDCountFDMeta":[{"FC":340, "count":10,"status":"A"}, { "FC":414,"count":12, "status":"I"},{"FC":1, "count":13,"status":"A"},{"FC":2, "count":14,"status":"I"},{"FC":22, "count":15,"status":"A"},{"FC":33, "count":16,"status":"A"},{"FC":334, "count":20,"status":"A"},{"FC":563, "count":17,"status":"I"}]},';
        JSONReq += '{"mod":1,"header":{"CUSTNAME":"Anirudh", "UNT":5432345,"CORE":"GITs2.8","ESN":"ABCDSASERDF","ERT":1233453456, "ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},';
        JSONReq += '"SDP":[{"field":1,"value":"34"}, { "field":2,"value":"342"}, { "field":22,"value":"Data Vaue" }],"FD":[{"APD":[ { "P":340,"R":[65,75 ]},{"P":414,"R":[645,755]}], "BPD": ["1","2"],"UFD": {"UPA":["22","33"],"UPI":["334","563"]}, "PAT":"A"}],"FDCountFDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I" },{"FC":1, "count":13,"status":"A"},{"FC":2, "count":14,"status":"I"},{"FC":22, "count":15,"status":"A"},{"FC":33, "count":16,"status":"A"},{"FC":334, "count":20,"status":"A"},{"FC":563, "count":17,"status":"I"}]} ] }';*/

        String JSONReq = '{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC","module":[{"mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs38","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"12"},{"field":2,"value":"231"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["3","4"],"UFD":{"UPA":["222","333"],"UPI":["434","363"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]},{"mod":1,"header":{"CUSTNAME":"Anirudh","UNT":5432345,"CORE":"GITs45","ESN":"ABCDSASERDF","ERT":1233453456,"ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"34"},{"field":2,"value":"342"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["1","2"],"UFD":{"UPA":["22", "33"],"UPI":["334", "563"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]}]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/InsiteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;

        //string results = CSS_receiveINSITEDataR2.updateJobOrderData();
        CSS_receiveINSITEDataR2.updateJobOrderData();
        Test.stopTest();
    }
    public static testMethod void testJobOrderDataNotFound(){
        Test.startTest();
        String jobName = 'NOJOBFOUND';
        
        String JSONReq = '{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC","module":[{"mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs38","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"12"},{"field":2,"value":"231"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["3","4"],"UFD":{"UPA":["222","333"],"UPI":["434","363"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]},{"mod":1,"header":{"CUSTNAME":"Anirudh","UNT":5432345,"CORE":"GITs45","ESN":"ABCDSASERDF","ERT":1233453456,"ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"34"},{"field":2,"value":"342"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["1","2"],"UFD":{"UPA":["22", "33"],"UPI":["334", "563"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]}]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/InsiteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;
        
        //string results = CSS_receiveINSITEDataR2.updateJobOrderData();
        CSS_receiveINSITEDataR2.updateJobOrderData();
        Test.stopTest();
    }
    public static testMethod void testOfflineJobOrderNumber(){
        Test.startTest();
        String jobName = '123ABC-<DUMMYHHMMSS>';
        
        String JSONReq = '{"CJOD":"'+jobName+'","CJOD_Flag":"T","TMS":"2012-04-23T18:25:43.511Z","TI":"123ABC","module":[{"mod":0,"header":{"CUSTNAME":"Anirudh","UNT":5435,"CORE":"GITs38","ESN":"ABCDERDF","ERT":123456,"ETD":"7841.3","KOT":"11111111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"12"},{"field":2,"value":"231"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["3","4"],"UFD":{"UPA":["222","333"],"UPI":["434","363"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]},{"mod":1,"header":{"CUSTNAME":"Anirudh","UNT":5432345,"CORE":"GITs45","ESN":"ABCDSASERDF","ERT":1233453456,"ETD":"7834341.3","KOT":"12323111 :23 :23","IMGNM":"ABCDERDF"},"SDP":[{"field":1,"value":"34"},{"field":2,"value":"342"},{"field":22,"value":"Data Vaue"}],"FD":{"APD":[{"P":340,"R":[65,75]},{"P":414,"R":[645,755]}],"BPD":["1","2"],"UFD":{"UPA":["22", "33"],"UPI":["334", "563"]}},"PAT":"A","FDMeta":[{"FC":340,"count":10,"status":"A"},{"FC":414,"count":12,"status":"I"}]}]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/InsiteData/V01/CSS/WO/Test';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;
        
        //string results = CSS_receiveINSITEDataR2.updateJobOrderData();
        CSS_receiveINSITEDataR2.updateJobOrderData();
        Test.stopTest();
    }
}