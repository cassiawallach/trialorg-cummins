@IsTest
public class CSS_UnitOutboundJSON2Apex_Test {
    
    static testMethod void DataArea(){
        CSS_UnitOutboundJSON2Apex.DataArea DA = new CSS_UnitOutboundJSON2Apex.DataArea();
        list<CSS_UnitOutboundJSON2Apex.DataArea> lstDA = new list<CSS_UnitOutboundJSON2Apex.DataArea>();
        
        DA.ContactId = '';
        DA.AddressLine1 = '';
        DA.OwnerName = '';
        DA.ContactName = '';
        DA.City = '';
        DA.FAInterfaced = '';
        DA.State = '';
        DA.UnitDescription ='';
		DA.Model='';
		DA.CustomerCode='';
		DA.VIN='';
		DA.ModelNumber='';
		DA.UnitType='';
		DA.UnitNumber='';
		DA.Manufacturer='';
		DA.Applicationcode='';
		DA.ModelSeq= 0;
		DA.EngineFamily='';
		DA.ESN='';
		DA.SalesSegment='';
        lstDA.add(DA);
    }
    static testMethod void testParse() {
        /*String json = '{ '+
        '\"Header\": { '+
        '  \"Status\": \"success\", '+
        '  \"ReturnCodeDescription\": \"message_ifany\", '+
        '  \"Location\": { \"LocationID\": \"02400-02394\" } '+
        '}, '+
        '\"DataArea\": { '+
        '  \"CustomerCode\" : \"A1234567\", '+
        '  \"UnitNumber\": \"12345\", '+
        '  \"UnitDescription\": \"\", '+
        '  \"UnitType\": \"\", '+
        '  \"Model\": \"\", '+
        '  \"VIN\": \"\", '+
        '  \"Manufacturer\": \"KENWORTH\", '+
        '  \"SalesSegment\": \"\", '+
        '  \"ModelNumber\": \"\", '+
        '  \"ModelSeq\": 0, '+
        '  \"ESN\": \"79834545\", '+
        '  \"EngineFamily\": \"\", '+
        '  \"Applicationcode\": \"\" '+
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
        '  \"UnitNumber\": \"12345\", '+
        '  \"UnitDescription\": \"\", '+
        '  \"UnitType\": \"\", '+
        '  \"Model\": \"\", '+
        '  \"VIN\": \"\", '+
        '  \"Manufacturer\": \"KENWORTH\", '+
        '  \"SalesSegment\": \"\", '+
        '  \"ModelNumber\": \"\", '+
        '  \"ModelSeq\": 0, '+
        '  \"ESN\": \"79834545\", '+
        '  \"EngineFamily\": \"\", '+
        '  \"Applicationcode\": \"\" '+
        '}] '+
        '}';
        CSS_UnitOutboundJSON2Apex obj = CSS_UnitOutboundJSON2Apex.parse(json);
               System.assert(obj != null);
    }
}