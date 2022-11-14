@istest
public class CSS_getPartsListBMSResponseJ2A_Test {
      static testMethod void testParse() {
        String json=        '{"Header": {'+
        '   "ReturnCodeDescription": "SUCCESS: For Record Number- 1, Part Number- 007070500: WOQT Parts inserted/updated successfully.\\n SUCCESS: For Record Number- 2, Part Number- 430917500RX: WOQT Parts inserted/updated successfully.\\n",'+
        '   "Status": "SUCCESS",'+
        '   "Sender":    {'+
        '      "ServiceName": "WOParts",'+
        '      "MessageID": "bac053ab-5b99-4301-8895-aeb67c10a2c9",'+
        '      "SenderID": "CSS"'+
        '   },'+
        '   "Target": {"TargetID": "BMS"},'+
        '   "Location": {"LocationID": "03742-03750"}'+
        '}}'+
        '';
        CSS_getPartsListBMSResponseJ2A obj = CSS_getPartsListBMSResponseJ2A.parse(json);
        System.assert(obj != null);
    }
}