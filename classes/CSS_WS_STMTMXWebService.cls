@RestResource(urlMapping='/stmt_mx/*')
Global Class CSS_WS_STMTMXWebService{
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
        try{
            CSS_WS_J2A_StmxMx jsonwrap =(CSS_WS_J2A_StmxMx)JSON.deserialize(bodyString,CSS_WS_J2A_StmxMx.class);//Deserializing the data sent into concrete SFDC objects
            Decimal extendedAmount;
            if(jsonwrap != null){
                extendedAmount = decimal.valueof(jsonwrap.extendedAmount) * -1;
            } 
            system.debug('JSON: ' +jsonwrap);
            List<CSS_WS_Warranty__c> claims = [SELECT CSS_WS_DR_Credit_Number__c, CSS_WS_Claim_Status__c, CSS_WS_CM_Extended_Amount__c, CSS_WS_CM_Customer_Number__c,
                CSS_WS_CM_Bill_to_Customer_Name__c, CSS_WS_CM_Ship_to_Customer_Name__c, CSS_WS_CM_Timbre_Fiscal__c, CSS_WS_DR_Payment_Date__c, CSS_WS_Service_Provider_Dealer__c,
                CSS_WS_Service_Provider_DR__c, CSS_WS_CM_Extended_Amount_Calculated__c, CSS_WS_Total_Claim_Approved__c, CSS_WS_Total_Travel__c, 
                CSS_WS_Total_Amount_Travel__c, CSS_WS_Account_Code__c, CSS_WS_Service_Order_Counter_Flag__c, CSS_WS_SO_Document_Type__c, CSS_WS_SO_Transaction_Number__c, 
                CSS_WS_SO_Extended_Amount__c, CSS_WS_Policy_Flag__c, CSS_WS_Engine_Application_Code__c, CSS_WS_Pay_Code__c, CSS_WS_Towing_Amount__c
                FROM CSS_WS_Warranty__c WHERE CSS_WS_Claim_Number__c =: jsonwrap.salesOrder];
                //WHERE CSS_WS_DR_Credit_Number__c =: jsonwrap.idDocument AND (CSS_WS_Total_Claim_Approved__c =: extendedAmount OR CSS_WS_Claim_Amount__c =: extendedAmount)];
            system.debug('Claims: ' + claims);
            if(!claims.isEmpty()){
                Savepoint sp = Database.setSavepoint();
                for(CSS_WS_Warranty__c claim :claims){
                    Approval.UnlockResult unlockResult = Approval.unlock(claim);
                    if(unlockResult.isSuccess()){
                        if(claim.CSS_WS_Claim_Status__c == 'Pending CM'){
                            /*String Type = [SELECT BillingCountry FROM Account WHERE (CSS_DealerCode__c =: claim.CSS_WS_Service_Provider_Dealer__c) 
                                           OR (CSS_DBCode__c =: claim.CSS_WS_Service_Provider_DR__c AND (Type = 'Distributor Account' OR 
                                           Type = 'Distributor Branch Account')) ORDER BY Type LIMIT 1].Type;*/
                            Account SPAccount = CSS_WS_ControllerClaim.getSelectedSPAccount(claim.CSS_WS_Service_Provider_DR__c , claim.CSS_WS_Service_Provider_Dealer__c);
                                           
                            if (jsonwrap.documentType == 'CGLF'){// for Invoice statements
                                claim.CSS_WS_SO_Document_Type__c = jsonwrap.documentType;
                                claim.CSS_WS_SO_Transaction_Number__c = jsonwrap.transactionNumber;
                                claim.CSS_WS_SO_Extended_Amount__c =  !String.isEmpty(jsonwrap.extendedAmount) ? Decimal.valueof(jsonwrap.extendedAmount):0;
                            } else {// for credit statements
                                claim.CSS_WS_CM_Document_Type__c = jsonwrap.documentType;
                                claim.CSS_WS_CM_Transaction_Number__c = jsonwrap.transactionNumber;
                                if(!String.isEmpty(jsonwrap.transactionDate)){
                                    String[] str = jsonwrap.transactionDate.split('T');
                                    if(str != null){
                                        String[] dates = str[0].split('-');
                                        if( dates != null){
                                            claim.CSS_WS_CM_Transaction_Date__c = Date.newInstance(Integer.valueof(dates[0]),Integer.valueof(dates[1]),Integer.valueof(dates[2]));
                                        }
                                    }
                                }
                                claim.CSS_WS_CM_Extended_Amount__c =  !String.isEmpty(jsonwrap.extendedAmount) ? Decimal.valueof(jsonwrap.extendedAmount):0;
                                
                                // Extended amount calculated
                                Decimal dif_travel = 0.00;
                                if(claim.CSS_WS_Total_Travel__c != null && claim.CSS_WS_Total_Amount_Travel__c != null){
                                    if(claim.CSS_WS_Total_Travel__c < claim.CSS_WS_Total_Amount_Travel__c){
                                        dif_travel = claim.CSS_WS_Total_Amount_Travel__c.setscale(2) - claim.CSS_WS_Total_Travel__c.setscale(2);
                                    }
                                }
                                Decimal claimAmount = 0.00;
                                if (claim.CSS_WS_Total_Claim_Approved__c != null){
                                    claimAmount = claim.CSS_WS_Total_Claim_Approved__c.setscale(2);  
                                }
                                
                                //Change for avoid dif travel for off-highway claims in Extended amount Calculated field - Nov 12th 2021
                                if(claim.CSS_WS_Policy_Flag__c == 'Warranty'){
                                
                                    if(claim.CSS_WS_Engine_Application_Code__c == '410' || claim.CSS_WS_Engine_Application_Code__c == '510' || claim.CSS_WS_Engine_Application_Code__c == '520' 
                                         || claim.CSS_WS_Engine_Application_Code__c == '530' || claim.CSS_WS_Engine_Application_Code__c == '610' || claim.CSS_WS_Engine_Application_Code__c == '620' 
                                         || claim.CSS_WS_Engine_Application_Code__c == '635' || claim.CSS_WS_Engine_Application_Code__c == '650' || claim.CSS_WS_Engine_Application_Code__c == '655' 
                                         || claim.CSS_WS_Engine_Application_Code__c == '660' || claim.CSS_WS_Engine_Application_Code__c == '662' || claim.CSS_WS_Engine_Application_Code__c == '663' 
                                         || claim.CSS_WS_Engine_Application_Code__c == '810' || claim.CSS_WS_Engine_Application_Code__c == '820' || claim.CSS_WS_Engine_Application_Code__c == '850' 
                                         || claim.CSS_WS_Engine_Application_Code__c == '890' || claim.CSS_WS_Engine_Application_Code__c == '891'){
                                        
                                        claim.CSS_WS_CM_Extended_Amount_Calculated__c = claim.CSS_WS_CM_Extended_Amount__c;
                                        // don't add difference of travel - Engine Application Code is 410, 510, 520, 530, 610, 620, 635, 650, 655, 660, 662, 663, 810, 820, 850, 890, OR 891
                                    } else if((claim.CSS_WS_Pay_Code__c == 'T' || claim.CSS_WS_Pay_Code__c == 'S' || claim.CSS_WS_Pay_Code__c == 'C' || claim.CSS_WS_Pay_Code__c == 'L') && 
                                        (claim.CSS_WS_Engine_Application_Code__c == '130' || claim.CSS_WS_Engine_Application_Code__c == '210' || claim.CSS_WS_Engine_Application_Code__c == '220' || claim.CSS_WS_Engine_Application_Code__c == '310'
                                         || claim.CSS_WS_Engine_Application_Code__c == '320')){
                                        
                                        claim.CSS_WS_CM_Extended_Amount_Calculated__c = claim.CSS_WS_CM_Extended_Amount__c;
                                        // don't add difference of travel - (Engine Application Code is 130, 210, 220, 310, OR 320) AND (Pay Code is T, S, C, OR L) 
                                    } else if(SPAccount.BillingCountry.toUpperCase() == 'MEXICO' && claim.CSS_WS_Towing_Amount__c > 0){
                                        
                                        claim.CSS_WS_CM_Extended_Amount_Calculated__c = claim.CSS_WS_CM_Extended_Amount__c;
                                        // don't add difference of travel - Towing amount > 0, AND Mexico Account
                                    } else {
                                        
                                        claim.CSS_WS_CM_Extended_Amount_Calculated__c = (claimAmount + dif_travel) * -1;
                                        //Add Total Approved Amount + Differance Travel Amount
                                    }  
                                
                                }else{
                                
                                    claim.CSS_WS_CM_Extended_Amount_Calculated__c = (claimAmount + dif_travel) * -1;
                                }                              
                                //End change for avoid dif travel for off-highway claims in Extended amount Calculated field - Nov 12th 2021                                
                                // End Extended amount calculted
                                
                                claim.CSS_WS_CM_Customer_Number__c = jsonwrap.customerNumber;
                                claim.CSS_WS_CM_Bill_to_Customer_Name__c = jsonwrap.billToCustomerName;
                                claim.CSS_WS_CM_Ship_to_Customer_Name__c = jsonwrap.shipToCustomerName;
                                claim.CSS_WS_CM_Timbre_Fiscal__c = jsonwrap.timbreFiscal;
                                //claim.CSS_WS_DR_Payment_Date__c = System.today();
                                
                            }
                            if (claim.CSS_WS_Account_Code__c == 'P101' && claim.CSS_WS_Service_Order_Counter_Flag__c == 3){ // getting data from 1st credit/invoice statement
                                claim.CSS_WS_Service_Order_Counter_Flag__c = 4;
                            } else {
                                if (claim.CSS_WS_Account_Code__c == 'P101' && claim.CSS_WS_Service_Order_Counter_Flag__c == 4){ // getting data from 2nd credit/invoice statement
                                    claim.CSS_WS_Service_Order_Counter_Flag__c = 5;
                                }
                                claim.CSS_WS_Factory_Payment_Date__c = System.Today();
                                //if(Type == 'Distributor Account' || Type == 'Distributor Branch Account'){
                                //    claim.CSS_WS_Claim_Status__c = 'Paid';
                                //    Approval.LockResult lockResult = Approval.lock(claim);
                                //} else {
                                if(claim.CSS_WS_Policy_Flag__c == 'Policy'){
                                    claim.CSS_WS_Claim_Status__c = 'Approved for Reliability';
                                } else {
                                    claim.CSS_WS_Claim_Status__c = 'Pending DR Payment to DL';
                                }
                                //}
                            }                            
                            update claim;
                        }
                     } else {
                        responseJSON.Status = 'Error';
                        responseJSON.ErrorMessage = 'Unable to unlock record';
                        Database.rollback(sp);
                        break;
                    }
                }
            } else {
                responseJSON.Status = 'Error';
                responseJSON.ErrorMessage = 'Credit Number not found';
            }
        } catch(System.Exception e){
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