/*
* Block comments with details of changes
*/
@RestResource(urlMapping='/Siebel/V01/CSS/PaymentDetails/')
global class CSS_receiveSiebelPaymentDetails
{

    @HttpPut
    global static void updatepaymentdetails(){
        string JSONResponseBody;
        string wsESN;
        string ServiceJobLocation;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        system.debug('**res**'+res);
        res.addHeader('Content-Type', 'application/json');
        string jSONRequestBody ;
        // Map<String, String> mpParams = new Map<String, String>(req.params);
        jSONRequestBody = req.requestBody.toString().trim(); 
        system.debug('**jSONRequestBody**'+jSONRequestBody);
        try
        {
            CSS_JSON2APEXSIEBELPAYMENTDETAILS CSub = (CSS_JSON2APEXSIEBELPAYMENTDETAILS)JSON.deserializeStrict(jSONRequestBody,CSS_JSON2APEXSIEBELPAYMENTDETAILS.class);
            System.debug('========> Response' +CSub);

            List<CSS_Claim_Submission__c> CCSInertionList=new List<CSS_Claim_Submission__c>();
            List<CSS_Claim_Submission__c> CCSUpdateList=new List<CSS_Claim_Submission__c>();
            List<CSS_Claim_Submission__c> ExistingCSB = new List<CSS_Claim_Submission__c>();

            Map<String,CSS_JSON2APEXSIEBELPAYMENTDETAILS.DataArea> ClaimnNumberMap = new Map<String,CSS_JSON2APEXSIEBELPAYMENTDETAILS.DataArea>();

            IF(CSub.DataArea.size()>0){           
                For(CSS_JSON2APEXSIEBELPAYMENTDETAILS.DataArea dt: Csub.DataArea){
                    ClaimnNumberMap.put(dt.SiebelClaimNumber,dt);
                }
                system.debug('**ClaimnNumberMap**'+ClaimnNumberMap);
                For(CSS_Claim_Submission__c CSB:[select id,Claim_Number__c,Claim_Status__c, Total_Claim_Amount__c, Siebel_Claim_Number__c from CSS_Claim_Submission__c where Siebel_Claim_Number__c In:ClaimnNumberMap.keySet()])
                {
                    system.debug('**CSB**'+CSB);
                    system.debug('Claim Status**'+ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).ClaimStatus);
                    if (ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).ClaimStatus != 'In Review') 
                    {
                        CSS_Claim_Submission__c cssClaimSub =new CSS_Claim_Submission__c(id=CSB.id);
                        cssClaimSub.Claim_Number__c =   ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).SiebelClaimNumber;
                        cssClaimSub.IMS_Claim_Number__c = ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).IMSClaimNumber;
                        cssClaimSub.PayCode__c = ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).PayCode;
                        //cssClaimSub.Claim_Status__c = ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).ClaimStatus;
                        

                        cssClaimSub.Rejection_Reason__c  =ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).RejectionReason;
                        cssClaimSub.Rejection_Reason__c  =ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).RejectionReason;
                        cssClaimSub.Type__c  =ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Type;  
                        cssClaimSub.Statement_Number__c  =ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).StatementNumber;
                        if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).CreditDate != null && ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).CreditDate != '')
                            cssClaimSub.Credit_Date__c  = Date.valueOf(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).CreditDate);  
                        if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).CreditNumber != null && ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).CreditNumber != '')
                        	cssClaimSub.Credit_Number__c  = ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).CreditNumber;
                        if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Parts != null && ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Parts != '')
                        	cssClaimSub.Parts__c  = Decimal.valueof(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Parts);
                        if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Labor != null && ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Labor != '')
                        	cssClaimSub.Labor__c  = Decimal.valueof(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Labor);
                        if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Travel != null && ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Travel != '')
                        	cssClaimSub.Travel__c  = Decimal.valueof(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Travel);
                        if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Other != null && ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Other != '')
                        	cssClaimSub.Other__c  = Decimal.valueof(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Other);
                        if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Tax != null && ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Tax != '')
                        	cssClaimSub.Tax__c  = Decimal.valueof(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Tax);
                        if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).PMU != null && ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).PMU != '')
                        	cssClaimSub.PMU__c  = Decimal.valueof(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).PMU);
                        if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).BFC != null && ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).BFC != '')
                        	cssClaimSub.BFC__c  = Decimal.valueof(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).BFC);
                        if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Deductible != null && ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Deductible != '')
                        	cssClaimSub.Deductible__c  = Decimal.valueof(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).Deductible);
                        if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).TotalPaid != null && ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).TotalPaid != '')
                        	cssClaimSub.Total_Paid__c  = Decimal.valueof(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).TotalPaid);
                        
                        //Adding below code for GSSC-218 By Krishna.
                        string status = ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).ClaimStatus;
                        system.debug('Status ===> ' + status);
                        if(status != null && status != '') {
                            if(status != 'Info Only') {
                              cssClaimSub.Status__c = status;
                            } 
                        }
                        //Adding Above code for GSSC-218 By Krishna.
                        
                        //Story 156722: Satish for Rupesh
                        //Claims with ‘Denied’ status from Siebel will be updated with the same status – that is ‘Denied’.
                        ////if(ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).ClaimStatus == 'Denied') 
                        ////{
                            ////cssClaimSub.Status__c = ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).ClaimStatus;
                        ////} 
                        //
                        ////else 
                        ////{
                            ////cssClaimSub.Status__c = 'Paid'; // added by Sneha for story #161637
                          /*  Decimal WSClaimTotal = cssClaimSub.Parts__c + cssClaimSub.Labor__c + cssClaimSub.Travel__c + cssClaimSub.Other__c ;
                            //Total Claimed amount in Guidanz = ‘Parts’ + ‘Labor’+ ‘Travel’ + ‘Other’ 
                            If (WSClaimTotal == CSB.Total_Claim_Amount__c)
                                cssClaimSub.Status__c = 'Paid as Submitted';
                            //Total Claimed amount in Guidanz <> ‘Parts’ + ‘Labor’+ ‘Travel’ + ‘Other’
                            else
                                cssClaimSub.Status__c = 'Partially Paid';  */
                            
                        ////}
                        //Commented by Karhik as it is already above at line 70
                       //cssClaimSub.Status__c = ClaimnNumberMap.get(CSB.Siebel_Claim_Number__c).ClaimStatus;
                        
                        cssClaimSub.SiebelPaymentReceived__c = true;

                        CCSUpdateList.add(cssClaimSub);
                    }
                    ClaimnNumberMap.Remove(CSB.Siebel_Claim_Number__c);
                }
                if(CCSUpdateList.size()>0)
                    Update CCSUpdateList;
                system.debug('**CCSUpdateList.size()**'+CCSUpdateList);
                if(ClaimnNumberMap.size()>0){                     
                    system.debug('**ClaimnNumberMap.size()**'+ClaimnNumberMap.size());
                    For(CSS_JSON2APEXSIEBELPAYMENTDETAILS.DataArea dt: ClaimnNumberMap.Values()){
                        CSS_Claim_Submission__c cssClaimSub =new CSS_Claim_Submission__c();
                        cssClaimSub.Claim_Number__c =   dt.SiebelClaimNumber;
                        cssClaimSub.IMS_Claim_Number__c = dt.IMSClaimNumber;
                        cssClaimSub.PayCode__c = dt.PayCode;
                        cssClaimSub.Claim_Status__c = dt.ClaimStatus;
                        cssClaimSub.Rejection_Reason__c  =dt.RejectionReason;
                        cssClaimSub.Rejection_Reason__c  =dt.RejectionReason;
                        cssClaimSub.Type__c  =dt.Type;  
                        cssClaimSub.Statement_Number__c  =dt.StatementNumber;
                        cssClaimSub.Credit_Date__c  = (dt.CreditDate != null && dt.CreditDate != '' ? Date.valueOf(dt.CreditDate) : null);
                        cssClaimSub.Credit_Number__c  = dt.CreditNumber;
                        cssClaimSub.Parts__c  = dt.Parts == null ? 0.0 : Decimal.valueof(dt.Parts);
                        cssClaimSub.Labor__c  = dt.Labor == null ? 0.0 : Decimal.valueof(dt.Labor);
                        cssClaimSub.Travel__c  = dt.Travel == null ? 0.0 : Decimal.valueof(dt.Travel);
                        cssClaimSub.Other__c  = dt.Other == null ? 0.0 : Decimal.valueof(dt.Other);
                        cssClaimSub.Tax__c  = dt.Tax == null ? 0.0 : Decimal.valueof(dt.Tax);
                        cssClaimSub.PMU__c  = dt.PMU == null ? 0.0 : Decimal.valueof(dt.PMU);
                        cssClaimSub.BFC__c  = dt.BFC == null ? 0.0 : Decimal.valueof(dt.BFC);
                        cssClaimSub.Deductible__c  = dt.Deductible == null ? 0.0 : Decimal.valueof(dt.Deductible);
                        cssClaimSub.Total_Paid__c  = dt.TotalPaid == null ? 0.0 : Decimal.valueof(dt.TotalPaid); 
                        cssClaimSub.SiebelPaymentReceived__c = true;
                        CCSInertionList.add(cssClaimSub);
                    }
                }
            }
            //Insert CCSInertionList;
            JSONResponseBody = '{ "Header": {"Status":"Success", "ReturnCodeDescription":"Payment details have been updated successfully"}}';
            res.responseBody = Blob.valueOf(JSONResponseBody);
        }
        catch(Exception e)
        {

            system.debug('Entered into catch block of updatepaymentdetails method in CSS_receiveSiebelPaymentDetails>>>>>>'+e.getCause() + ' ' + e.getLineNumber() + ' ' + e.getMessage());
            if(e.getTypeName() == 'System.JSONException'){
                JSONResponseBody = '{ "Header": {"Status":"Internal Error", "ReturnCodeDescription":"Invalid JSON Schema"}}';
                insIntegrationError(JSONResponseBody,'Invalid JSON Schema',jSONRequestBody);
            }
            /*else if(e.getTypeName() == 'System.NullPointerException'){
                JSONResponseBody = '{ "Header": {"Status":"Internal Error", "ReturnCodeDescription":"Null Pointer Exception"}}';
                insIntegrationError(JSONResponseBody,e.getLineNumber()+''+e.getCause()+''+e.getMessage(),jSONRequestBody);
            }*/
            else if(e.getTypeName() == 'System.DMLException'){
                JSONResponseBody = '{ "Header": {"Status":"Internal Error", "ReturnCodeDescription":"Record insertion failed"}}';
                insIntegrationError(JSONResponseBody,e.getLineNumber()+''+e.getCause()+''+e.getMessage(),jSONRequestBody);
            }
            else
            {
                JSONResponseBody = '{ "Header": {"Status":"Internal Error", "ReturnCodeDescription":"Internal Error Occurred"}}';
                System.debug('===>karthik' +e.getmessage()+e.getlinenumber());
                insIntegrationError(JSONResponseBody,e.getLineNumber()+''+e.getCause()+''+e.getMessage(),jSONRequestBody);
            }
            System.debug('===>JSONResponseBody' +JSONResponseBody);
            res.responseBody = Blob.valueOf(JSONResponseBody);
        }
    }

    global static void insIntegrationError(string errDesc, string sysError, string reqMsg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Error_Description__c = sysError + ' *** External Message ** ' + errDesc;
        errObj.Source__c = 'Payment Details From MW';
        errObj.Processed_Data__c = reqMsg;
        insert errObj;
    }
}