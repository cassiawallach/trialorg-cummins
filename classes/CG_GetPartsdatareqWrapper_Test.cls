@isTest
public class CG_GetPartsdatareqWrapper_Test {
     static testMethod void GetPartsdatareqWrappermethod(){
         string Json =  '{'+
      ' \"Header\": {'+
      '  \"Sender\": {'+
               '  \"MessageID\":\"CSSabc\", '+
                '  \"ServiceName\":\"GetOverlapSRT\",'+
                     '  \"SenderID\":\"CSS\" '+
      '   }'+
         '  },'+
            '   \"DataArea\":{'+
             '  \"PartNumberShort\":\"CSS-000001234\" '+         
                '   }'+

    '}';     
         
         CG_GetPartsdatareqWrapper obj1 = CG_GetPartsdatareqWrapper.parse(Json );
          System.assert(obj1 != null);
     }

}