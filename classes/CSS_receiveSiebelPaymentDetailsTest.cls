@isTest(SeeAllData=false)
public class CSS_receiveSiebelPaymentDetailsTest {
    public static testMethod void testCSSBData(){
        CSS_Claim_Submission__c ccs=new CSS_Claim_Submission__c();
        ccs.Claim_Number__c='C0000190118';
        ccs.Siebel_Claim_Number__c = 'C0000190118';
        ccs.Claim_Status__c = 'Paid';
        insert ccs;
        String JSONReq = '{"Header":{"Sender":{"ServiceName":"sendBMSJobDeletion","SenderID": "BMS"},"Target": {"TargetID": "CSS"}},"DataArea": [{"SiebelClaimNumber": "C0000190118","IMSClaimNumber": "56270","PayCode": "I","ClaimStatus": "Paid","RejectionReason": "56275","Type": "WO","StatementNumber":"TEST","CreditDate": "2010-03-19","CreditNumber": "TEST","Parts": "56270","Labor":"56275","Travel": "56275","Other": "987","Tax": "987","PMU": "56275","BFC": "56275","Deductible": "975","TotalPaid": "955"},{"SiebelClaimNumber": "C0000190119","IMSClaimNumber": "56270","PayCode": "I","ClaimStatus": "Paid","RejectionReason": "56275","Type": "WO","StatementNumber":"TEST","CreditDate": "2010-03-19","CreditNumber": "TEST","Parts": "56270","Labor":"56275","Travel": "56275","Other": "987","Tax": "987","PMU": "56275","BFC": "56275","Deductible": "975","TotalPaid": "955"}]}';
       // String JSONReq = '{"Header":{"Sender":{"ServiceName":"sendBMSJobDeletion","SenderID": "BMS"},"Target": {"TargetID": "CSS"}},"DataArea": [{"SiebelClaimNumber": "C0000190118","IMSClaimNumber": "56270","PayCode": "I","ClaimStatus": "56275","RejectionReason": "56275","Type": "WO","StatementNumber":"TEST","CreditDate": "2010-03-19","CreditNumber": "TEST","Parts": "56270","Labor":"56275","Travel": "56275","Other": "987","Tax": "987","PMU": "56275","BFC": "56275","Deductible": "975","TotalPaid": "955"},{"SiebelClaimNumber": "C0000190119","IMSClaimNumber": "56270","PayCode": "I","ClaimStatus": "56275","RejectionReason": "56275","Type": "WO","StatementNumber":"TEST","CreditDate": "2010-03-19","CreditNumber": "TEST","Parts": "56270","Labor":"56275","Travel": "56275","Other": "987","Tax": "987","PMU": "56275","BFC": "56275","Deductible": "975","TotalPaid": "955"}]}';
        //String JSONReq = '{"Header":{"Sender":{"ServiceName":"sendBMSJobDeletion","SenderID": "BMS"},"Target": {"TargetID": "CSS"}},"DataArea": [{"SiebelClaimNumber": "C0000190118","IMSClaimNumber": "56270","PayCode": "I","ClaimStatus": "In Review","RejectionReason": "56275","Type": "WO","StatementNumber":"TEST","CreditDate": "2010-03-19","CreditNumber": "TEST","Parts": "56270","Labor":"56275","Travel": "56275","Other": "987","Tax": "987","PMU": "56275","BFC": "56275","Deductible": "975","TotalPaid": "955"},{"SiebelClaimNumber": "C0000190119","IMSClaimNumber": "56270","PayCode": "I","ClaimStatus": "56275","RejectionReason": "56275","Type": "WO","StatementNumber":"TEST","CreditDate": "2010-03-19","CreditNumber": "TEST","Parts": "56270","Labor":"56275","Travel": "56275","Other": "987","Tax": "987","PMU": "56275","BFC": "56275","Deductible": "975","TotalPaid": "955"}]}';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Siebel/V01/CSS/PaymentDetails/';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;
        CSS_receiveSiebelPaymentDetails.updatepaymentdetails();
       CSS_receiveSiebelPaymentDetails.insIntegrationError('test','te','t');
    }
    public static testMethod void testCSSBData1(){
        CSS_Claim_Submission__c ccs=new CSS_Claim_Submission__c();
        ccs.Claim_Number__c='C0000190118';
        ccs.Siebel_Claim_Number__c = 'C0000190118';
        ccs.Claim_Status__c = 'Paid';
        insert ccs;
        //String JSONReq = '{"Header":{"Sender":{"ServiceName":"sendBMSJobDeletion","SenderID": "BMS"},"Target": {"TargetID": "CSS"}},"DataArea": [{"SiebelClaimNumber": "C0000190118","IMSClaimNumber": "56270","PayCode": "I","ClaimStatus": "56275","RejectionReason": "56275","Type": "WO","StatementNumber":"TEST","CreditDate": "2010-03-19","CreditNumber": "TEST","Parts": "56270","Labor":"56275","Travel": "56275","Other": "987","Tax": "987","PMU": "56275","BFC": "56275","Deductible": "975","TotalPaid": "955"},{"SiebelClaimNumber": "C0000190119","IMSClaimNumber": "56270","PayCode": "I","ClaimStatus": "56275","RejectionReason": "56275","Type": "WO","StatementNumber":"TEST","CreditDate": "2010-03-19","CreditNumber": "TEST","Parts": "56270","Labor":"56275","Travel": "56275","Other": "987","Tax": "987","PMU": "56275","BFC": "56275","Deductible": "975","TotalPaid": "955"}]}';
        String JSONReq = '';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Siebel/V01/CSS/PaymentDetails/';  //Request URL
        req.httpMethod = 'PUT';//HTTP Request Type
        req.requestBody = Blob.valueof(JSONReq);
        RestContext.request = req;
        RestContext.response= res;
        CSS_receiveSiebelPaymentDetails.updatepaymentdetails();
       CSS_receiveSiebelPaymentDetails.insIntegrationError('test','te','t');
    }

}