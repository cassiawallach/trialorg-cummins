@isTest
public class FSL_QSOLResponsewrapper_Test {
    
    static testMethod void testParse() 
    {
        //String Json = '{"status": "success"}';
        /*
        String Json = '{"documentNum":"T2085","documentDesc":"ISX15 CM2350 455HP AND HIGHER SCR REPLACEMENT TRP","type":"TRP","language":"en","status":"OPEN","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/trp/2020/t2085.html"}';
        FSL_QSOLResponsewrapper obj = FSL_QSOLResponsewrapper.parse(Json);
        System.assert(obj != null);
        */
        
        //CT3-114
        String json = '{'+
        '        \"documentNum\": \"TSB160024\",'+
        '        \"documentDesc\": \"New Remote Mounted Lubricating Oil Filter Head Assembly to Prevent Low Lubricating Oil Pressure\",'+
        '        \"type\": \"TSB\",'+
        '        \"language\": \"en\",'+
        '        \"groupNum\": \"7\",'+
        '        \"groupName\": \"07 - Lubricating Oil Systems\",'+
        '        \"faultCodes\": ['+
        '            \"143\"'+
        '        ],'+
        '        \"symptoms\": ['+
        '            \"Lubricating Oil Pressure Low\"'+
        '        ],'+
        '        \"documentLink\": \"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/tsb/2016/tsb160024.html\"'+
        '},'+
        '{'+
        '        \"documentNum\": \"TSB160085\",'+
        '        \"documentDesc\": \"New Lubricating Oil Filter Cooler Head Part Number\",'+
        '        \"type\": \"TSB\",'+
        '        \"language\": \"en\",'+
        '        \"groupNum\": \"7\",'+
        '        \"groupName\": \"07 - Lubricating Oil Systems\",'+
        '        \"documentLink\": \"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/tsb/2016/tsb160085.html\"'+
        '}';
        FSL_QSOLResponsewrapper r = FSL_QSOLResponsewrapper.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        FSL_QSOLResponsewrapper objJSON2Apex = new FSL_QSOLResponsewrapper(System.JSON.createParser(json));
        System.assert(objJSON2Apex != null);
        System.assert(objJSON2Apex.documentNum == null);
        System.assert(objJSON2Apex.documentDesc == null);
        System.assert(objJSON2Apex.type == null);
        System.assert(objJSON2Apex.language == null);
        System.assert(objJSON2Apex.groupNum == null);
        System.assert(objJSON2Apex.groupName == null);
        System.assert(objJSON2Apex.faultCodes == null);
        System.assert(objJSON2Apex.symptoms == null);
        System.assert(objJSON2Apex.documentLink == null);
        
    }
    
}