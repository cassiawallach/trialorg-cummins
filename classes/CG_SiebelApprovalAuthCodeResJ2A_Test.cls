@IsTest
public class CG_SiebelApprovalAuthCodeResJ2A_Test 
{
    static testMethod void testParse() 
    {
	string json='{ "Header": { "ReturnCodeDescription": "<Message>", "Status": "Error", "ReturnCode": "<MessageCode>", "MessageIdentifier": "Identifier" }, "DataArea": [ { "WWID": "", "FirstName": "CHCA", "LastName": "21", "AuthCode": [], "ApprovalCode": "ApprovalCode", "ApprovalCodeActiveFlag": "21" } ] }';

		CG_SiebelApprovalAuthCodeResponseJ2A obj = CG_SiebelApprovalAuthCodeResponseJ2A.parse(json);
		System.assert(obj != null);
	}
    
}