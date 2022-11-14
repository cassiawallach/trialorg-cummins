@isTest
public class CSS_SendJobInfoResWrapper_Test {
    static testMethod void testParse(){
        String json='{'+
            '"Header": {'+
            '"ServiceName": "SendJobInfo",'+
            '"ServiceVersion": "1.0",'+
            '"Status": "Success",'+
            '"ReturnCode": "CSS00",'+
            '"ReturnCodeDescription": "message_ifany"'+
            '},'+
            '"DataArea": {'+
            '"CSSJobID": "CSS-00084646"'+
            '}'+
            '}'+
            '';
         CSS_SendJobInfoResWrapper.parse(json);
    }
}