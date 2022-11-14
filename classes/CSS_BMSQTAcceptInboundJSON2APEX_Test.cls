/**********************************************************************
Name: CSS_BMSQTAcceptInboundJSON2APEX_Test 
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Test class for "CSS_BMSQTAcceptInboundJSON2APEX" 
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR          DATE                DETAIL                                 
1.0          Venkat          11/05/2016     INITIAL DEVELOPMENT                      

*********************************************************************/
@isTest
public class CSS_BMSQTAcceptInboundJSON2APEX_Test {
        static testMethod void testParse(){
   /*         string json = '{'+
                '"DataArea":{'+
                    '"WOReferenceNumber":"12345"'+
                '"Header":{'+
                    '"Status":"Success",'+
                    '"ReturnCodeDescription":"<Message from SRT>",'+
                    '"Location":"Test",'+
                '"Location":{'+
                    '"LocationID":"1234"'+
                '}'+
           '}'+
       '}'+
   '}';
            */
 String json = '{\"Header\":{\"ReturnCodeDescription\":\"Distributor Not Setup\",\"Status\":\"ERROR\",\"Sender\":{\"ServiceName\":\"GetCustomer\",\"SenderID\":\"CSS\"},\"Target\":{\"TargetID\":\"BMS\"},\"Location\":{\"LocationID\":\"Test\"}},\"DataArea\":{\"WOReferenceNumber\":\"Distributor Not Setup\"}}';
		
            
            CSS_BMSQTAcceptInboundJSON2APEX obj = CSS_BMSQTAcceptInboundJSON2APEX.parse(json);
            System.assert(obj != null);
        }
    
}