@IsTest
public class CG_SiebelGetPaymentDetailsResper_Test {
     static testMethod void testParse() {
         
   String json = '{ \"Header\": { \"ReturnCodeDescription\": \"<Message from Siebel>\", \"Status\": \"Success\", \"ReturnCode\": \"<MessageCode from Siebel>\", \"MessageIdentifier\": \"<Identifier from MW>\" }, \"DataArea\": [ { \"SiebelClaimNumber\": \"C0000190118\", \"IMSClaimNumber\": \"56270\", \"PayCode\": \"I\", \"ClaimStatus\": \"56275\", \"RejectionReason\": \"56275\", \"Type\": \"WO\", \"StatementNumber\": \"TEST\", \"CreditDate\": \"2010-03-19\", \"CreditNumber\": \"TEST\", \"Parts\": 56270, \"Labor\": 56275, \"Travel\": 56275, \"Other\": 987, \"Tax\": 987, \"PMU\": 56275, \"BFC\": 56275, \"Deductible\": 979, \"TotalPaid\": 955 }, { \"SiebelClaimNumber\": \"C0000190119\", \"IMSClaimNumber\": \"56270\", \"PayCode\": \"I\", \"ClaimStatus\": \"56275\", \"RejectionReason\": \"56275\", \"Type\": \"WO\", \"StatementNumber\": \"TEST\", \"CreditDate\": \"2010-03-19\", \"CreditNumber\": \"TEST\", \"Parts\": 56270, \"Labor\": 56275, \"Travel\": 56275, \"Other\": 987, \"Tax\": 987, \"PMU\": 56275, \"BFC\": 56275, \"Deductible\": 979, \"TotalPaid\": 955 } ] }';

    
   
         CG_SiebelGetPaymentDetailsRespWrapper obj = CG_SiebelGetPaymentDetailsRespWrapper.parse(json);
        System.assert(obj != null);
     }

}