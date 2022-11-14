@IsTest
public class OSM_GOMSInvoiceResWrapper_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"INVOICE_DATA\": ['+
        '    {'+
        '      \"TRANSACTION_ID\": \"MKTPLC-00001\",'+
        '      \"SHIP_TO_ABBR\": \"2860\",'+
        '      \"INVOICE_ID\": \"6128890\",'+
        '      \"STATUS\": \"SUCCESS\",'+
        '      \"MESSAGE\": \"SUCCESS\"'+
        '    },'+
        '    {'+
        '      \"TRANSACTION_ID\": \"MKTPLC-00002\",'+
        '      \"SHIP_TO_ABBR\": \"2930\",'+
        '      \"INVOICE_ID\": [],'+
        '      \"STATUS\": \"FAILURE\",'+
        '      \"MESSAGE\": \"INVALID CUSTOMER NO.\"'+
        '    },'+
        '    {'+
        '      \"TRANSACTION_ID\": \"MKTPLC-00003\",'+
        '      \"SHIP_TO_ABBR\": \"2400\",'+
        '      \"INVOICE_ID\": \"6128891\",'+
        '      \"STATUS\": \"SUCCESS\",'+
        '      \"MESSAGE\": \"SUCCESS\"'+
        '    }'+
        '  ]'+
        '}';
        OSM_GOMSInvoiceReqWrapper obj = OSM_GOMSInvoiceReqWrapper.parse(json);
        System.assert(obj != null);
        System.JSONParser parser = System.JSON.createParser(json);
        OSM_GOMSInvoiceReqWrapper.consumeObject(parser);
        OSM_GOMSInvoiceReqWrapper.arrayOfINVOICE_ID(parser);
    }
}