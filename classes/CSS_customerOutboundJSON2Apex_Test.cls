@IsTest
public class CSS_customerOutboundJSON2Apex_Test {
    
      static testMethod void DataArea(){
		  css_customerOutboundJSON2Apex.DataArea DA = new css_customerOutboundJSON2Apex.DataArea();
		  list<CSS_customerOutboundJSON2Apex.DataArea> lstDA = new list<CSS_customerOutboundJSON2Apex.DataArea>();
		  DA.CustomerName='';
		  DA.CustomerCode='';
		  DA.LocationAddressline1='';
		  DA.LocationAddressline2='';
		  DA.LocationAddressline3='';
		  DA.PhoneNumber='';
		  DA.AreaCode='';
		  DA.City='';
		  DA.PaymentType='';
		  DA.State='';
		  DA.Country='';
		  DA.Postalcode1='';
		  DA.Postalcode2='';
		  
	  }
	  static testMethod void testParse() {
        /*String json = '{ '+
        '\"Header\": { '+
        '  \"Status\": \"success\", '+
        '  \"ReturnCodeDescription\": \"message_ifany\", '+
        '  \"Sender\": { \"SenderID\": \"02400-02394\" } '+
		'   \"Target\":{  \"TargetID\":\"02451-02365\"}  '+
		'    \"Location\": \LocationID\":\"02400-02394\"} '+
        '}, '+
        '\"DataArea\": { '+
        '  \"CustomerCode\" : \"A1234567\", '+
        '  \"CustomerName\": \"Test1\", '+
        '  \"LocationAddressline1\": \"\", '+
        '  \"LocationAddressline2\": \"\", '+
        '  \"LocationAddressline3\": \"\", '+
        '  \"PhoneNumber\": \"\", '+
        '  \"AreaCode\": \"\", '+
        '  \"City\": \"\", '+
        '  \"PaymentType\": \"\", '+
        '  \"State\": 0, '+
        '  \"Country\": \"\", '+
        '  \"Postalcode1\": \"\", '+
        '  \"Postalcode2\": \"\" '+
        '} '+
        '}';*/
        String json = '{ '+
        '\"Header\": { '+
            '  \"Status\": \"success\", '+
                    '  \"Sender\": { '+
                    '\"ServiceName\": \"GetUnitInfo\",'+
                    '\"SenderID\": \"CSS\"'+
                    '},'+
                    ' \"Target\": {'+
                    '\"TargetID\": \"BMS"'+
                    '},'+
            '  \"Location\": { '+
            '   \"LocationID\": \"02400-02394\" '+
            '  } '+
            '}, '+
            '\"DataArea\": [{ '+
        '  \"CustomerCode\" : \"A1234567\", '+
        '  \"CustomerName\": \"Test1\", '+
        '  \"LocationAddressline1\": \"\", '+
        '  \"LocationAddressline2\": \"\", '+
        '  \"LocationAddressline3\": \"\", '+
        '  \"PhoneNumber\": \"\", '+
        '  \"AreaCode\": \"\", '+
        '  \"City\": \"\", '+
        '  \"PaymentType\": \"\", '+
        '  \"State\": 0, '+
        '  \"Country\": \"\", '+
        '  \"Postalcode1\": \"\", '+
        '  \"Postalcode2\": \"\" '+
        '}] '+
        '}';
            CSS_customerOutboundJSON2Apex obj = CSS_customerOutboundJSON2Apex.parse(json);
        System.assert(obj != null);
        
    }
}