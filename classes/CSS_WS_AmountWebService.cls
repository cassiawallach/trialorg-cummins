@RestResource(urlMapping='/css_amount/*')
Global Class CSS_WS_AmountWebService{
    @HttpPost
    Global Static Void doPost(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/javascript');
        Integer statusCode = 200;
        webservice_response responseJSON = new webservice_response();
        responseJSON.Status = 'Success';
        responseJSON.ErrorMessage = '';
        Blob body = req.requestBody;
        String bodyString = body.toString();
        system.debug(bodyString);
        try{//Deserializing the data sent into concrete SFDC objects
            CSS_WS_J2A_Amount jsonwrap =(CSS_WS_J2A_Amount)JSON.deserialize(bodyString,CSS_WS_J2A_Amount.class);
            List<CSS_WS_Warranty__c>  claims = [
                SELECT Id, CSS_WS_Service_Provider_Dealer__c, CSS_WS_Service_Provider_DR__c,
                CSS_WS_Claim_Status__c, CSS_WS_Rejection_Reason__c, CSS_WS_Type_Number__c, CSS_WS_Statement_Number__c, 
                CSS_WS_Credit_Date__c, CSS_WS_Deductible_Amount__c, CSS_WS_Total_Parts__c, CSS_WS_Total_Labor__c, 
                CSS_WS_Total_Travel__c, CSS_WS_Total_Other__c, CSS_WS_Tax__c, CSS_WS_Parts_Mark_Up__c, 
                CSS_WS_Beyond_Factory_Charges__c, CSS_WS_Total_Approved__c, CSS_WS_IMS_Claim_Number__c, CSS_WS_Pay_Code_Amount__c
                FROM CSS_WS_Warranty__c WHERE CSS_WS_Siebel_Claim_Number__c =: jsonwrap.claimNumber LIMIT 1];
            
            if(!String.isEmpty(jsonwrap.claimNumber) && claims.size() > 0 ){
                CSS_WS_Warranty__c claim = claims[0];
                Approval.UnlockResult unlockResult = Approval.unlock(claim);
                if(unlockResult.isSuccess()){
                    if((jsonwrap.claimStatus.touppercase() == 'PAID' || jsonwrap.claimStatus.touppercase() == 'DENIED') && claim.CSS_WS_Claim_Status__c == 'Pending US'){
                        Account SPAccount = [
                            SELECT BillingCountry FROM Account WHERE IAM_Service_Provider_Code__c =: claim.CSS_WS_Service_Provider_Dealer__c 
                            AND (Type = 'Dealer Account' OR Type = 'Dealer Branch Account' OR Type = 'Distributor Account' 
                            OR Type = 'Distributor Branch Account') AND CMI_Account_Status__c = 'Active' ORDER BY Type LIMIT 1];

                        if(jsonwrap.claimStatus.touppercase() == 'PAID'){
                            /*if(SPAccount.BillingCountry.touppercase() == 'MEXICO'){
                                claim.CSS_WS_Claim_Status__c = 'Pending Planta Payment';
                            } else {
                                claim.CSS_WS_Claim_Status__c = 'Paid';
                            }*/
                            if(Test.isRunningTest() != true){
                                claim.CSS_WS_Claim_Status__c = 'Getting US Details';
                            }
                        } else {
                            claim.CSS_WS_Claim_Status__c = 'Denied by US';
                        }
                        //claim.CSS_WS_Factory_Payment_Date__c = System.Today();
                        claim.CSS_WS_US_Date__c = System.today();
                        claim.CSS_WS_Rejection_Reason__c = jsonwrap.rejectionReason;
                        claim.CSS_WS_Type_Number__c = jsonwrap.typeNumber;
                        claim.CSS_WS_Statement_Number__c = jsonwrap.statementNumber;
                        if(!String.isEmpty(jsonwrap.creditDate)){
                            String[] str = jsonwrap.creditDate.split(' ');
                            if(str != null){
                                String[] dates = str[0].split('/');
                                if(dates != null){
                                    claim.CSS_WS_Credit_Date__c = Date.newInstance(Integer.valueof(dates[2]),Integer.valueof(dates[0]),Integer.valueof(dates[1]));
                                }
                            }
                        }
                        claim.CSS_WS_Deductible_Amount__c = !String.isEmpty(jsonwrap.parts) ? decimal.valueOf(jsonwrap.deductible) : 0;
                        claim.CSS_WS_Total_Parts__c = !String.isEmpty(jsonwrap.parts) ? decimal.valueOf(jsonwrap.parts) : 0;
                        claim.CSS_WS_Total_Labor__c = !String.isEmpty(jsonwrap.labor) ? decimal.valueOf(jsonwrap.labor) : 0;
                        claim.CSS_WS_Total_Travel__c = !String.isEmpty(jsonwrap.travel)? decimal.valueOf(jsonwrap.travel) : 0;
                        claim.CSS_WS_Total_Other__c = !String.isEmpty(jsonwrap.other) ? decimal.valueOf(jsonwrap.other) : 0;
                        claim.CSS_WS_Tax__c = jsonwrap.tax;
                        claim.CSS_WS_Parts_Mark_Up__c = jsonwrap.PMU;
                        claim.CSS_WS_Beyond_Factory_Charges__c = jsonwrap.BFC;
                        claim.CSS_WS_Total_Approved__c = !String.isEmpty(jsonwrap.totalPaid) ? decimal.valueOf(jsonwrap.totalPaid) : 0;
                        claim.CSS_WS_IMS_Claim_Number__c = jsonwrap.IMSClaimNumber;
                        claim.CSS_WS_Pay_Code_Amount__c = jsonwrap.payCode;
                        update claim;
                        Approval.LockResult lockResult = Approval.lock(claim);
                    }
                } else {
                    responseJSON.Status = 'Error';
                    responseJSON.ErrorMessage = 'Unable to unlock record';
                }
            } else {
                responseJSON.Status = 'Error';
                responseJSON.ErrorMessage = 'Claim Number not found';
            }
        } catch(System.Exception e){
            System.debug('Error in the process: ' + e.getMessage());
            responseJSON.Status = 'Error';
            responseJSON.ErrorMessage = e.getMessage();
        }
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseJSON));
    }

    Public Class webservice_response{
        Public String Status;
        Public String ErrorMessage;
    }
}