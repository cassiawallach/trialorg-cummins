/**********************************************************************
Name:CSS_receiveBMSCommentOutboundData
Copyright © 2011  Cummins
=======================================================================
=======================================================================
Purpose:  
BMS Comment Outbounds update #130109                                                        
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                 DETAIL                                 
1.0 - Anirudh Pesari      03/26/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/

@RestResource(urlMapping='/BMS/V01/CSS/UpdateBMSCommentsInGuidanz/')
global class CSS_receiveBMSCommentOutboundData {
    @HttpPut
    global static void updateBMSCommentOutboundData(){
        string JSONResponseBody;
        string wsESN;
        string ServiceJobLocation;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        string jSONRequestBody ;
            jSONRequestBody = req.requestBody.toString().trim(); 
        system.debug('Request**'+req);
        system.debug('jSONRequestBody**'+jSONRequestBody);
            try
            {
                CSS_BMSCommentOutBoundRequestParser wo1 = (CSS_BMSCommentOutBoundRequestParser)JSON.deserializeStrict(jSONRequestBody,CSS_BMSCommentOutBoundRequestParser.class);
                System.debug('========> Response' +wo1);
                System.debug('========> Response CSSJobID' +wo1.DataArea.CSSJobId);
                //Fetch the Job Order from Salesforce based on the parameter passed on the URL
                list<CSS_Job_Order__c> lstJobOrder = [SELECT Id, Name, CSS_Job_Location_Code__c, Status__c, Unit_Number__c From CSS_Job_Order__c WHERE Name =: wo1.DataArea.CSSJobId];
               System.debug('=====> List Of Order'+lstJobOrder);
               // ServiceJobLocation = lstJobOrder[0].CSS_Job_Location_Code__c;
                if(!lstJobOrder.isEmpty())
                {
                    ServiceJobLocation = lstJobOrder[0].CSS_Job_Location_Code__c;
                    if(wo1.DataArea.CommentType.equalsIgnoreCase('COVERAGE')){
                        //Update Coverage Notes
                        lstJobOrder[0].EditCoverage__c = wo1.DataArea.ServiceComment;
                        
                    }
                    if(wo1.DataArea.CommentType.equalsIgnoreCase('Complaint')){
                        //Update Complaint Notes
                        lstJobOrder[0].EditComplaint__c = wo1.DataArea.ServiceComment;
                        
                    }
                    if(wo1.DataArea.CommentType.equalsIgnoreCase('Cause')){
                        //Update Cause Notes
                        lstJobOrder[0].EditCause__c = wo1.DataArea.ServiceComment;
                    }
                    if(wo1.DataArea.CommentType.equalsIgnoreCase('Correction')){
                        //Update Correction Notes
                        lstJobOrder[0].EditCorrection__c = wo1.DataArea.ServiceComment;
                    }
                    if(wo1.DataArea.CommentType.equalsIgnoreCase('SRO')){
                        //Update Correction Notes
                        lstJobOrder[0].Non_SRT_Details__c = wo1.DataArea.ServiceComment;
                    }
                    JSONResponseBody = '{ "Header": {"Status":"SUCCESS", "ReturnCodeDescription":"Comments Information received successfully","Location": {"LocationID":"'+wo1.Header.Location.LocationID+'"}}}';
                   update lstJobOrder;  
                    System.debug('===>lstJobOrder 63' +lstJobOrder);
                }
               
                else{
                    JSONResponseBody = '{ "Header": {"Status":"Error", "ReturnCodeDescription":"CSS Job Not Found","Location": {"LocationID":"'+wo1.Header.Location.LocationID+'"}}}';
                }
            }
                catch(Exception e)
                {
                  
                        JSONResponseBody = '{ "Header": {"Status":"Error", "ReturnCodeDescription":"Internal Error Occurred","Location": {"LocationID":"'+ServiceJobLocation+'"}}}';
              
                    
                }
               System.debug('===>JSONResponseBody 63' +JSONResponseBody);
                res.responseBody = Blob.valueOf(JSONResponseBody);
            }
        }