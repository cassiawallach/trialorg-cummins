@istest
public class CG_FieldActionSRTResponse_test {
    static testmethod void CG_FieldActionSRTResponse_test1()
    {
        String json = '{'+
            '\"Header\":{ '+ 
            '\"MessageIdentifier\": \"Identifier from FieldAcionSRTResponse\",' + 
            '\"ReturnCode\":\"MessageCode from FieldAcionSRTResponse\",' +
            '\"ReturnCodeDescription\":\"Message from FieldAcionSRTResponse\",' +
            '\"Status\":\"Success\"},' +
			 ' \"DataArea\": {'+
    '   \"FieldAction\": ['+
    '   {'+
	        '\"FieldActionNumber\":\"12345\",' + 
            ' \"FieldActionType\":\"xyz\",' +
    '   \"FieldActionSRTTime\": ['+
	'   {'+
            '\"SRTDetails\":\"SRTDetails\",' + 
            ' \"SRTTitle\":\"SRTTitle\",' +
            '\"StepID\":\"123\",' +
            '\"StepDescription\":\"StepDescription\",'+
            '\"RTIME\":\"3.43\",' +
            '\"ATIME\":\"3.43\",' +
            '\"BTIME\":\"3.43\", ' +
            '\"CTIME\":\"3.43\", ' + 
            '\"DTIME\":\"3.43\",' +
            '\"S1TIME\":\"3.43\",' +
			'\"S1DESCRIPTION\":\"S1DESCRIPTION\",' + 
            ' \"S2TIME\":\"3.43\",' +
            '\"S2DESCRIPTION\":\"S2DESCRIPTION\",' +
            '\"S3TIME\":\"3.43\",'+
            '\"S3DESCRIPTION\":\"test\",' +
            '\"S4TIME\":\"3.43\",' +
            '\"S4DESCRIPTION\":\"S4DESCRIPTION\", ' +
            '\"S5TIME\":\"3.43\", ' + 
            '\"S5DESCRIPTION\":\"S5DESCRIPTION\",' +
            '\"S6TIME\":\"3.43\",' +
			'\"S6DESCRIPTION\":\"S6DESCRIPTION\",' + 
            ' \"S7TIME\":\"3.43\",' +
            '\"S7DESCRIPTION\":\"S7DESCRIPTION\",' +
            '\"S8TIME\":\"3.43\",'+
            '\"S8DESCRIPTION\":\"S8DESCRIPTION\",' +
            '\"S9TIME\":\"3.43\",' +
            '\"S9DESCRIPTION\":\"S9DESCRIPTION\", ' +
            '\"SRTQuantity\":\"1234\", ' + 
            '\"SRTMessage\":\"SRTMessage\",' +
            '\"Assignment\":\"PRIMARY\",' +
			'\"SRTAccessCode\":\"SRTAccessCode\", ' +
            '\"SRTTime\":\"3.43\", ' + 
            '\"QuoteID\":\"12334\"' +
       '}'+
            ']'+
	'}'+
            ']}'+
    ' }';
        CG_FieldActionSRTResponse fieldaction= CG_FieldActionSRTResponse.parse(json);
        system.debug('fieldaction>>'+fieldaction);
        CG_FieldActionSRTResponse FA = new CG_FieldActionSRTResponse();
        FA.Header = fieldaction.Header;
        system.debug('fieldaction >>> ' + FA.Header);
        FA.Header.MessageIdentifier = fieldaction.Header.MessageIdentifier;
        FA.Header.Status = fieldaction.Header.Status;
        FA.Header.ReturnCode = fieldaction.Header.ReturnCode;
        FA.Header.ReturnCodeDescription = fieldaction.Header.ReturnCodeDescription;
        FA.DataArea = fieldaction.DataArea;
        FA.DataArea.FieldAction = fieldaction.DataArea.FieldAction;
        FA.DataArea.FieldAction[0].FieldActionNumber = fieldaction.DataArea.FieldAction[0].FieldActionNumber;
        FA.DataArea.FieldAction[0].FieldActionType = fieldaction.DataArea.FieldAction[0].FieldActionType;
        FA.DataArea.fieldaction[0].FieldActionSRTTime[0].SRTDetails = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].SRTDetails; 
        system.debug('SRTDetail:-'+FA.DataArea.fieldaction[0].FieldActionSRTTime[0].SRTDetails);
        FA.DataArea.fieldaction[0].FieldActionSRTTime[0].StepID = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].StepID; 
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].StepDescription = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].StepDescription;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].RTIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].RTIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].ATIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].ATIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].BTIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].BTIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].CTIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].CTIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S1TIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S1TIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S1DESCRIPTION = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S1DESCRIPTION;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S2TIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S2TIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S2DESCRIPTION = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S2DESCRIPTION;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S3TIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S3TIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S3DESCRIPTION = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S3DESCRIPTION;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S4TIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S4TIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S4DESCRIPTION = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S4DESCRIPTION;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S5TIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S5TIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S5DESCRIPTION = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S5DESCRIPTION;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S6TIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S6TIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S6DESCRIPTION = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S6DESCRIPTION;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S7TIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S7TIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S7DESCRIPTION = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S7DESCRIPTION;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S8TIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S8TIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S8DESCRIPTION = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S8DESCRIPTION;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S9TIME = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S9TIME;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].S9DESCRIPTION = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].S9DESCRIPTION;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].SRTQuantity = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].SRTQuantity;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].SRTMessage = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].SRTMessage;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].Assignment = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].Assignment;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].SRTAccessCode = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].SRTAccessCode;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].SRTTime = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].SRTTime;
		FA.DataArea.fieldaction[0].FieldActionSRTTime[0].QuoteID = fieldaction.DataArea.fieldaction[0].FieldActionSRTTime[0].QuoteID;
        
    }

}