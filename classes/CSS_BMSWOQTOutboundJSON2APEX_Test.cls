@isTest
public class CSS_BMSWOQTOutboundJSON2APEX_Test {
        static testMethod void testParse() {
            String json = '{\"Header\":{\"ReturnCodeDescription\":\"Distributor Not Setup\",\"Status\":\"ERROR\",\"Sender\":{\"ServiceName\":\"GetCustomer\",\"SenderID\":\"CSS\"},\"Target\":{\"TargetID\":\"BMS\"},\"Location\":{\"LocationID\":\"Test\"}},\"DataArea\":{\"WOReferenceNumber\":\"Distributor Not Setup\"}}';
    
            CSS_BMSWOQTOutboundJSON2APEX obj = CSS_BMSWOQTOutboundJSON2APEX.parse(json);
        }
}