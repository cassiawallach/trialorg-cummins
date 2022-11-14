@isTest
public class CSS_OverlapSRTReq_Test {
    static testMethod void CSSOverlapSRTReqmethod(){
        
    string Json =  '{'+
      ' \"Header\": {'+
         
           '  \"Sender\": {'+
               '  \"ServiceName\":\"GetOverlapSRT\",'+
                     '  \"SenderID\":\"CSS\" '+
                        '   },'+
                             '  \"Target\":{\"TargetID\":\"SRT\"}'+        
         '  },'+
            '   \"DataArea\":{'+
         
             '  \"JobId\":\"CSS-000001234\",'+
                 '  \"ClaimID\":\"C100002045\",'+
                     '  \"Languagecode\":\"en\",'+
                         '  \"DTTimestamp\":\"28-OCT-16 06:03:12 PM\",'+
                            '   \"EffectiveDTTime\":\"28-OCT-16 06:03:12 AM\",'+
                             '  \"Steps\":[{ '+
         '  \"StepId\": 1234,'+
             '  \"Qty\": 2,'+
                 '  \"AccessCode\":\"R\" '+
                   '    } ]}'+
'}';
/*CSS_OverlapSRTReq obj = CSS_OverlapSRTReq.parse(json);
        System.assert(obj != null);*/
        
        
CSS_OverlapSRTReq obj1 = CSS_OverlapSRTReq.parse(json);
        System.assert(obj1 != null);
    }
}