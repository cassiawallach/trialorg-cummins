@isTest
public class CSS_GetJobInfoReqWrapper_Test {
       static testMethod void CSSGetJobInfoReqmethod(){
           string Json ='{'+
                             ' \"Header\": {'+       
                               '  \"ServiceName\":\"GetJobInfo\",'+
                               '  \"ServiceVersion\":\"1.0\", '+
                               '  \"ToolID\":\"<Name of Dealer System>\" ,'+
                               '  \"SPCode\":\"<Service Provider Code>\" ,'+
                               '  \"SenderID\":\"<User Id / System User>\",'+
                               '  \"TargetID\":\"CSS\" '+        
                               '  },'+                  
                             '  \"DataArea\":{'+         
                                '  \"CSSJobID\":\"CSS-00043699\",'+
                                '  \"ShopWO\":\"1234\" '+
                             '}'+
                          ' }';  

           
        CSS_GetJobInfoReqWrapper obj1= CSS_GetJobInfoReqWrapper.parse(json);
                System.assert(obj1!= null);
       }
}