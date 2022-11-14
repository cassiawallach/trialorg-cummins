@isTest
public class CSS_getEngineDataReqJ2A_Test {
    static testMethod void testParse(){
        String json='{'+
            '"Header": {'+
                '"Sender": {'+
            '"ServiceName": "GetEngineData",'+
                '"SenderID": "CSS"'+
                    '},'+
                        '"Target": {'+ 
                            '"TargetID":'+ 
                            '"SIEBEL" '+
            '}'+ 
            '},'+
'"DataArea": {'+
            ' "Esn": 79464646'+
            '}'+ 
            '}'+
           
            '';
        CSS_getEngineDataReqJ2A.parse(json);
    }
}