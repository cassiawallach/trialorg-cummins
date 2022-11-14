@isTest
public class CSS_GetSubTypUnitTypResJ2AWrapper_Test {
    static testMethod void testParse(){
        String json='{'+            
            '"Header": {'+
            '"Status": "Status",'+
            '"ReturnCodeDescription": "code",'+
            '"Location": {'+
            '"LocationID": "1234"'+
            '}'+
            '},'+
            '"DataArea": {'+
            '"SubType": [{'+
            '"CodeValue": "CodeDesc",'+
            '"CodeDesc": "CodeDesc"'+
            '}, {'+
            '"CodeValue": "CodeDesc",'+
            '"CodeDesc": "CodeDesc"'+
            '}]'+
            '}'+
            '}'+
            '';
        CSS_GetSubTypUnitTypResJ2AWrapper.parse(json);
    }
}