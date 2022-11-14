Trigger CSS_WS_Send_Claim_US on CSS_WS_Warranty__c(before update, after update){
    for(CSS_WS_Warranty__c  record: Trigger.new){
        if(Trigger.isBefore){
            
            if((record.CSS_WS_Claim_Status__c == 'Pending TSM' && (record.CSS_WS_Login_Variable__c == 'DealerLoggedIn' || record.CSS_WS_Login_Variable__c == 'DRLoggedIn')) || record.CSS_WS_Claim_Status__c == 'Denied by DR' || record.CSS_WS_Claim_Status__c == 'Denied by Paccar' || record.CSS_WS_Claim_Status__c == 'Pending Review Planta'){
                record.CSS_WS_DR_Date__c = System.Today();
            }
            if((record.CSS_WS_Claim_Status__c == 'Pending Planta Payment Policy' || record.CSS_WS_Claim_Status__c == 'Declined by TSM') && record.CSS_WS_Account_Code__c == 'P88'){
                record.CSS_WS_TSM_Date__c = System.Today();
            }
            if((record.CSS_WS_Claim_Status__c == 'Pending Planta Payment Policy' || record.CSS_WS_Claim_Status__c == 'Denied by Planta') && record.CSS_WS_Policy_Flag__c == 'Policy' && record.CSS_WS_Account_Code__c != 'P88'){
                record.CSS_WS_Factory_Review_Date__c = System.Today();
            }
            if(record.CSS_WS_Claim_Status__c == 'Approved for Payment' || record.CSS_WS_Claim_Status__c == 'Declined by CSM'){
                record.CSS_WS_CSM_Date__c = System.Today();
            }
    
        }
        if(system.isFuture()) return;
        if(Trigger.isAfter){
            if(record.CSS_WS_Claim_Status__c == 'Approved for US'){
                CSS_WS_RSW_US_Async.claimSubmissionWSCallout(record.id);//Claim Submission
            }
            
            if(record.CSS_WS_Claim_Status__c == 'Approved for Reliability'){
                CSS_WS_Claim_Reliability_Async.claimReliabilityWSCallout(record.id);//Claim Reliability
            }
                        
            if(record.CSS_WS_Claim_Status__c == 'Getting US Details'){                
                CSS_WS_DetailsByUS jobUSDetails = new CSS_WS_DetailsByUS();
                jobUSDetails.claim = record.id;
                System.enqueueJob(jobUSDetails);
            }
            
            if(record.CSS_WS_Claim_Status__c == 'Getting DR Rejection Reason' || record.CSS_WS_Claim_Status__c == 'Getting Paccar Rejection Reason'){
                CSS_WS_DR_Rejection_Async.rejectionReason(record.id);//Get DR Rejection Reason
            }
                       
            // To send email to DR when Payment is Ready for Dealer
            if(record.CSS_WS_Claim_Status__c == 'Pending DR Payment to DL'){
                Id user_id;
                if (record.CSS_WS_Login_Variable__c == 'DealerLoggedIn'){
                    user user_approver = [SELECT Community_Approver__c FROM User WHERE id =: record.ownerId LIMIT 1];
                    user_id = user_approver.Community_Approver__c;
                } else if (record.CSS_WS_Login_Variable__c == 'DRLoggedIn'){
                    user_id = record.ownerId;
                } 
                // Send email to DR; Community Approver of Dealer, or same DR who created the claim
                if (user_id != null){
                    try{                
                        //New instance of a single email message
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                                    
                        // Who you are sending the email to
                        mail.setTargetObjectId(user_id);                  
                        // Subject for email
                        mail.setSubject('Notification: Claim ' + record.CSS_WS_Claim_Number__c + ' ready for payment');                    
                        // Get URL for Salesforce Instance
                        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm(); 
                        // Body of email
                        mail.setHtmlBody('The following Claim is ready for payment to Dealer: <p>' + 
                                    '   Folio: <a href=' + baseUrl + '/' + record.id + '>' + record.CSS_WS_Claim_Number__c + '</a>');
                        mail.setBccSender(false);
                        mail.setUseSignature(false);
                        //mail.setSenderDisplayName('CSS WS User');
                        mail.setSaveAsActivity(false); 
                        //system.debug(mail);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                    
                    } catch(exception e_error){
                        System.debug('Error: '+e_error.getMessage());
                    }
                }
            } 
        }
    }     
}