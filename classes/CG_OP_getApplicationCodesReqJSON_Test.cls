@istest
public class CG_OP_getApplicationCodesReqJSON_Test {
     static testmethod void testParse(){
        
        String json = '{  '+
            ''+
    '  \"Header\": {'+
    ''+
    '    \"Sender\": {'+
    
    ''+
    '      \"ServiceName\": \"ClaimSubmission\",'+
    ''+
    '      \"SenderID\": \"CSS\"'+
    ''+
    '    },'+
    ''+
    '    \"Target\":{'+ 
            
      ''+
     '      \"TargetID\": \"ClaimSubmission\"'+
    ''+
    '  }'+
    '  },'+
            '   \"DataArea\":{  '+
            '      \"LAST_PROCESSED_DATE\":\"CSSWarranty\"'+
            '      }'+
            
            
            '      }';
            
          CG_OP_getApplicationCodesReqJSON obj = CG_OP_getApplicationCodesReqJSON.parse(json);
        System.assert(obj != null); 
            
            }
}