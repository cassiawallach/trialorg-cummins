@IsTest
public class CSS_BMSWOQTInboundJSON2APEX_Test {
    
    static testMethod void testParse() {
/*      String json = '{ '+
        '\"Header\": { '+
             
            '  \"Status\": \"success\", '+
            '  \"ReturnCodeDescription\": \"message_ifany\", '+
            '  \"Location\": {'+
                 
                    ' \"LocationID\":\"02400-02394\" '+
            '  },'+           
            ' \"Sender\": { '+
              
                     '\"ServiceName\": \"CSS\" '+
                     '\"MessageID\": \"12345\" '+
                     '\"SenderID\": \"BMS\" '+
            '}'
   
         '}, '+
        '\"DataArea\": { '+
           '\"WOReferenceNumber\": \"WO1234567\" '+
        '} '+
         
        ' }';  
*/
        String json = '{\"Header\":{\"ReturnCodeDescription\":\"Distributor Not Setup\",\"Status\":\"ERROR\",\"Sender\":{\"ServiceName\":\"GetCustomer\",\"SenderID\":\"CSS\",\"MessageID\":\"CSS\"},\"Target\":{\"TargetID\":\"BMS\"},\"Location\":{\"LocationID\":\"Test\"}},\"DataArea\":{\"WOReferenceNumber\":\"Distributor Not Setup\",\"ContactID\":\"CSS\",\"CSSJobID\":\"CSS\"}}';
                
        CSS_BMSWOQTInboundJSON2APEX obj = CSS_BMSWOQTInboundJSON2APEX.parse(json);
        System.assert(obj != null);
    }
}