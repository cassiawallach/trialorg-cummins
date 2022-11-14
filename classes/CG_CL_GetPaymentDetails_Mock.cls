@istest
Global class CG_CL_GetPaymentDetails_Mock implements httpcalloutmock {
   global httpresponse respond(httprequest req) 
   {
       httpresponse res = new httpresponse();
       res.setStatus('success');
       res.setHeader('Content-Type', 'application/json');
       res.setStatusCode(200);
       string json='{ "Header": { "ReturnCodeDescription": "ClaimSubmission", "Status": "CSS", "ReturnCode": "CSS", "MessageIdentifier": "CSS" }, "DataArea": [ { "SiebelClaimNumber": "CSSWrranty", "IMSClaimNumber": "CSSWarranty", "PayCode": "CSSWarranty", "ClaimStatus": "CSSWarranty", "RejectionReason": "CSSWarranty", "Type": "CSSWarranty", "StatementNumber": "CSSWarranty", "CreditDate": "CSSWarranty", "CreditNumber": "CSSWarranty", "Parts": "123", "Labor": "123", "Travel": "1213", "Other": "1212", "Tax": "121", "PMU": "1212", "BFC": "121", "Deductible": "121", "TotalPaid": "12" } ] }';
        res.setbody(json);
       return res;
   }

}