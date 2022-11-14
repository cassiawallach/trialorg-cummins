@isTest
public class CSS_GetSubTypUnitTypRequestJ2A_Test {
    static testMethod void testParse(){
        String json='{'+            
            '"Header": {'+
            '"Sender": {'+
            '"ServiceName": "ServiceName",'+
            '"SenderID": "123"'+
            '},'+
            '"Target": {'+
            '"TargetID": "123456"'+
            '},'+
            '"Location": {'+
            '"LocationID": "1234"'+
            '}'+
            '}'+
            '}'+
            '';
        CSS_GetSubTypUnitTypRequestJ2A.parse(json);
    }
}