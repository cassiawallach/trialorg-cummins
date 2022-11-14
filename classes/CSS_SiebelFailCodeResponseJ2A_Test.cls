@isTest
public class CSS_SiebelFailCodeResponseJ2A_Test {
    static testMethod void CSS_SiebelFailCodeResponseJ2A_Test1() {
        
        String json = '{'+
            '\"Header\":{ '+ 
            '\"MessageIdentifier\": \"Identifier from MW\",' + 
            '\"ReturnCode\":\"MessageCode from Siebel\",' +
            '\"ReturnCodeDescription\":\"Message from Siebel\",' +
            '\"MessageType\":\"Message from Siebel\",' +
            '\"Status\":\"Success\"},' +
            ' \"DataArea\": {'+
    '   \"Details\": ['+
    '   {'+
            '\"SystemCode\":\"WS\",' + 
            ' \"SystemName\":\"Broken Filter shell1\",' +
            '\"ComponentCode\":\"EF\",' +
            '\"ComponentName\":\"Electrical\",'+
            '\"FailureName\":\"test\",' +
            '\"ServiceGroupCode\":\"345\",' +
            '\"Created\":\"2010-03-19T16:18:59.000-05:00\", ' +
            '\"Active\":\"Y\", ' + 
            '\"UpdatedDate\":\"2010-03-19T16:18:59.000-05:00\",' +
            '\"BusinesUnit\":\"EBU\"' +
    '}'+
            ']}'+
    ' }';
        CSS_SiebelFailCodeResponseJ2A controller = CSS_SiebelFailCodeResponseJ2A.parse(json);
        system.debug('controller >>> ' + controller);
        CSS_SiebelFailCodeResponseJ2A c = new CSS_SiebelFailCodeResponseJ2A();
        c.Header = controller.Header;
        system.debug('controller >>> ' + c.Header);
        c.Header.MessageIdentifier = controller.Header.MessageIdentifier;
        c.Header.ReturnCode = controller.Header.ReturnCode;
        c.Header.ReturnCodeDescription = controller.Header.ReturnCodeDescription;
        c.Header.Status = controller.Header.Status;
        c.Header.MessageType = controller.Header.MessageType;
        c.DataArea = controller.DataArea;
        c.DataArea.Details = controller.DataArea.Details;
        
        c.DataArea.Details[0].SystemCode = controller.DataArea.Details[0].SystemCode;
        c.DataArea.Details[0].SystemName = controller.DataArea.Details[0].SystemName;
        c.DataArea.Details[0].ComponentCode = controller.DataArea.Details[0].ComponentCode;
        c.DataArea.Details[0].ComponentName = controller.DataArea.Details[0].ComponentName;
        c.DataArea.Details[0].FailureName = controller.DataArea.Details[0].FailureName;
        c.DataArea.Details[0].ServiceGroupCode = controller.DataArea.Details[0].ServiceGroupCode;
        c.DataArea.Details[0].Created = controller.DataArea.Details[0].Created;
        c.DataArea.Details[0].Active = controller.DataArea.Details[0].Active;
        c.DataArea.Details[0].UpdatedDate = controller.DataArea.Details[0].UpdatedDate;
        c.DataArea.Details[0].BusinesUnit = controller.DataArea.Details[0].BusinesUnit;
    }
}