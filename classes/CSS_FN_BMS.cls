/**********************************************************************
Name: CSS_FN_BMS
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This is used for Business Logics of BMS functionality to
handle reusable code modules such as Create/Update/View/Delete/etc operations
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        10/14/2016     INITIAL DEVELOPMENT  
2.0     Anirudh Pesari    05/24/2017     BMS Contact Lookup Service
3.0     Anirudh Pesari	  09/06/2017     BMS Unit Lookup Webservice
***********************************************************************/

public class CSS_FN_BMS {
    
    /*
* This method is used for validations
*/
    public CSS_WPR_BMS_WOQTOutboundQuoteResJSON performValidations(RestRequest req){
        System.debug('################# entered into performValidations method ###################');
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON reqJSON = null;
        String jSONRequestBody = null;
        String status;
        String returnCodeDescription;
        try{
            jSONRequestBody = req.requestBody.toString().trim();
            //jSONRequestBody = ''; //sample request JSON
            System.debug('before deserialize jSONRequestBody>>>>>>>>>>>>>>>>>>>>>>:'+jSONRequestBody);
            
            //Perform validations here
            if(jSONRequestBody == null || jSONRequestBody == '' || String.isBlank(jSONRequestBody) || String.isEmpty(jSONRequestBody) ){
                status = 'Error';
                returnCodeDescription = 'Requested input is invalid';
                return prepareWOQTOutboundQuoteResWrapper(status, returnCodeDescription, '');
            }
            
            reqJSON = CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.parse(jSONRequestBody);
            System.debug('after deserialize reqJSON>>>>>>>>>>>>>>>>>>>>>>:'+reqJSON);
            if(reqJSON == null || reqJSON.Header == null || reqJSON.DataArea == null || reqJSON.DataArea.QuoteDoc == null || 
               reqJSON.DataArea.QuoteDoc.Body == null || reqJSON.DataArea.QuoteDoc.Body.realBlobValue == null || 
               reqJSON.DataArea.QuoteDoc.Body.realBlobValue.asByteArray == null || reqJSON.DataArea.QuoteDoc.Body.realBlobValue.asByteArray.trim() == ''){
                   status = 'Error';
                   returnCodeDescription = 'Requested input is invalid';
                   return prepareWOQTOutboundQuoteResWrapper(status, returnCodeDescription, '');
               }
            if(reqJSON.DataArea.OrderReference == null || reqJSON.DataArea.OrderReference.trim() == '' || String.isBlank(reqJSON.DataArea.OrderReference) 
               || String.isEmpty(reqJSON.DataArea.OrderReference) ){
                   status = 'Error';
                   returnCodeDescription = 'Requested OrderReference is invalid';
                   return prepareWOQTOutboundQuoteResWrapper(status, returnCodeDescription, reqJSON.Header.Location.LocationID);
               }
            if(reqJSON.DataArea.CSSJobID == null || reqJSON.DataArea.CSSJobID.trim() == '' || String.isBlank(reqJSON.DataArea.CSSJobID) 
               || String.isEmpty(reqJSON.DataArea.CSSJobID) ){
                   status = 'Error';
                   returnCodeDescription = 'Requested CSSJobID is invalid';
                   return prepareWOQTOutboundQuoteResWrapper(status, returnCodeDescription, reqJSON.Header.Location.LocationID);
               }
            if(reqJSON.DataArea.CustomerNumber == null || reqJSON.DataArea.CustomerNumber.trim() == '' || String.isBlank(reqJSON.DataArea.CustomerNumber) 
               || String.isEmpty(reqJSON.DataArea.CustomerNumber) ){
                   status = 'Error';
                   returnCodeDescription = 'Requested CustomerNumber is invalid';
                   return prepareWOQTOutboundQuoteResWrapper(status, returnCodeDescription, reqJSON.Header.Location.LocationID);
               }
            if(reqJSON.Header.Location == null || reqJSON.Header.Location.LocationID == null || reqJSON.Header.Location.LocationID.trim() == '' 
               || String.isBlank(reqJSON.Header.Location.LocationID) || String.isEmpty(reqJSON.Header.Location.LocationID) ){
                   status = 'Error';
                   returnCodeDescription = 'Requested LocationID is invalid';
                   return prepareWOQTOutboundQuoteResWrapper(status, returnCodeDescription, reqJSON.Header.Location.LocationID);
               }
            if(reqJSON.DataArea.QuoteDoc == null || reqJSON.DataArea.QuoteDoc.Body == null || reqJSON.DataArea.QuoteDoc.Body.realBlobValue == null || 
               reqJSON.DataArea.QuoteDoc.Body.realBlobValue.asByteArray == null || reqJSON.DataArea.QuoteDoc.Body.realBlobValue.asByteArray.trim() == ''){
                   status = 'Error';
                   returnCodeDescription = 'Requested Blob is invalid';
                   return prepareWOQTOutboundQuoteResWrapper(status, returnCodeDescription, '');
               }
            System.debug('CSSJobID>>>:'+reqJSON.DataArea.CSSJobID+' OrderReference>>>:'+reqJSON.DataArea.OrderReference+' CustomerNumber>>>:'+reqJSON.DataArea.CustomerNumber+' DistributorCode>>>:'+reqJSON.DataArea.DistributorCode);
            status = 'Processed';
            returnCodeDescription = 'Validations are passed';
            return prepareWOQTOutboundQuoteResWrapper(status, returnCodeDescription, reqJSON.Header.Location.LocationID);
        }catch(Exception ex){
            System.debug('in catch of performValidations of CSS_FN_BMS>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            status = 'Error';
            returnCodeDescription = 'Invalid JSON Format';
            return prepareWOQTOutboundQuoteResWrapper(status, returnCodeDescription, '');
        }finally{
            reqJSON=null;jSONRequestBody=null;
        }
        return null;
    }
    
    /*
* This method is used for updating the Quote and creating attachment
*/ 
    public CSS_WPR_BMS_WOQTOutboundQuoteResJSON updateQuote(CSS_WPR_BMS_WOQTOutboundQuoteReqJSON reqJSON){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into updateQuote method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_BMS_WOQTOutboundQuoteResJSON resJSON = null;
        List<CSS_Quote__c> quoteList = null;
        Id quoteId = null;
        Id attachId = null;
        try{
            quoteList = new List<CSS_Quote__c>([select Id, Name, OrderReference__c, BranchCode__c, CustomerNumber__c, DiagnosticCharges__c, DistributorCode__c,
                                                GrandTotal__c, ItemBillable__c, ItemGrossSell__c, ItemWarranty__c, LaborBillable__c, LaborGrossSell__c, LaborWarranty__c, 
                                                LocationID__c, MiscBillable__c, MiscGrossSell__c, MiscWarranty__c, QuoteTotal__c, SenderID__c, Service_Job__c, ServiceName__c,
                                                Surcharge__c, TargetID__c, Taxes__c, TransactionType__c from CSS_Quote__c where OrderReference__c=:reqJSON.DataArea.OrderReference limit 1]);
            if(quoteList.size()>0){
                //updating existing Quote
                CSS_Quote__c quoteObj = quoteList.get(0);
                Boolean updateFlag = updateExistingQuote(reqJSON, quoteObj);
                if(!updateFlag){
                    System.debug('updating existing Quote failed... QuoteID>>>>>>>>>>>>>>>>>>>>>>>>>>:'+quoteObj.Id+' updateFlag>>>>>>>>>:'+updateFlag);
                    return prepareWOQTOutboundQuoteResWrapper('Fail', 'Quote updation failed', reqJSON.Header.Location.locationId);
                }
                quoteId = quoteObj.Id;
            }else{
                //creating New Quote
                quoteId = createNewQuote(reqJSON);
                if(quoteId ==null)
                    return prepareWOQTOutboundQuoteResWrapper('Fail', 'Quote insertion failed', reqJSON.Header.Location.locationId);
            }
            //creating New Attachment for above Quote
            attachId = createQuoteAttachment(reqJSON, quoteId);
            if(attachId ==null)
                return prepareWOQTOutboundQuoteResWrapper('Fail', 'Quote updated but Attachment failed', reqJSON.Header.Location.locationId);
            System.debug('before returning from updateQuote>>>>>>>>>>>>>>>>>>>>>>>>>>');
            return prepareWOQTOutboundQuoteResWrapper('Success', 'Quote is updated successfully', reqJSON.Header.Location.locationId);
            
        }catch(Exception ex){
            System.debug('in catch of updateQuote of CSS_FN_BMS>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            return prepareWOQTOutboundQuoteResWrapper('Fail', 'Quote insertion/updation failed', null);
        } finally {
            quoteList=null;quoteId=null;attachId=null;
        }
        return resJSON;
    }
    
    /*
* This method is used for updating the Quote
*/ 
    public Boolean updateExistingQuote(CSS_WPR_BMS_WOQTOutboundQuoteReqJSON reqJSON, CSS_Quote__c quoteObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into updateExistingQuote method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        try{
            quoteObj.BranchCode__c = reqJSON.DataArea.BranchCode;
            quoteObj.CustomerNumber__c = reqJSON.DataArea.CustomerNumber;
            quoteObj.DiagnosticCharges__c = Decimal.valueOf(reqJSON.DataArea.DiagnosticCharges);
            quoteObj.DistributorCode__c = reqJSON.DataArea.DistributorCode;
            quoteObj.ItemBillable__c = Decimal.valueOf(reqJSON.DataArea.ItemBillable);
            quoteObj.ItemGrossSell__c = Decimal.valueOf(reqJSON.DataArea.ItemGrossSell);
            quoteObj.ItemWarranty__c = Decimal.valueOf(reqJSON.DataArea.ItemWarranty);
            quoteObj.LaborBillable__c = Decimal.valueOf(reqJSON.DataArea.LaborBillable);
            quoteObj.LaborGrossSell__c = Decimal.valueOf(reqJSON.DataArea.LaborGrossSell);
            quoteObj.LaborWarranty__c = Decimal.valueOf(reqJSON.DataArea.LaborWarranty);
            quoteObj.MiscBillable__c = Decimal.valueOf(reqJSON.DataArea.MiscBillable);
            quoteObj.MiscGrossSell__c = Decimal.valueOf(reqJSON.DataArea.MiscGrossSell);
            quoteObj.MiscWarranty__c = Decimal.valueOf(reqJSON.DataArea.MiscWarranty);
            //quoteObj.OrderReference__c = reqJSON.DataArea.OrderReference; //Quote number
            quoteObj.QuoteTotal__c = Decimal.valueOf(reqJSON.DataArea.QuoteTotal);
            quoteObj.Surcharge__c = Decimal.valueOf(reqJSON.DataArea.Surcharge);
            quoteObj.ServiceName__c = reqJSON.Header.Sender.ServiceName;
            quoteObj.SenderID__c = reqJSON.Header.Sender.SenderID;
            quoteObj.TargetID__c = reqJSON.Header.Target.TargetID;
            quoteObj.LocationID__c = reqJSON.Header.Location.LocationID;
            quoteObj.Taxes__c = Decimal.valueOf(reqJSON.DataArea.Taxes);
            quoteObj.TransactionType__c = reqJSON.DataArea.TransactionType;
            //here retrive Service Job record with Id based input CSSJOBID value
            CSS_Job_Order__c jobOrderObj = [select Id, Name from CSS_Job_Order__c where Name=:reqJSON.DataArea.CSSJobID];
            quoteObj.Service_Job__c = jobOrderObj.Id;
            update quoteObj;
            System.debug('updated successfully QuoteID>>>>>>>>>>>>>>>>>>>>>>>>>>:'+quoteObj.Id);
            return true;
        }catch(Exception ex){
            System.debug('in catch of updateExistingQuote of CSS_FN_BMS>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return false;
    }
    
    /*
* This method is used for creating a new Quote
*/ 
    public Id createNewQuote(CSS_WPR_BMS_WOQTOutboundQuoteReqJSON reqJSON){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into createNewQuote method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        try{
            CSS_Quote__c quoteObj = new CSS_Quote__c();
            quoteObj.BranchCode__c = reqJSON.DataArea.BranchCode;
            quoteObj.CustomerNumber__c = reqJSON.DataArea.CustomerNumber;
            quoteObj.DiagnosticCharges__c = Decimal.valueOf(reqJSON.DataArea.DiagnosticCharges);
            quoteObj.DistributorCode__c = reqJSON.DataArea.DistributorCode;
            quoteObj.ItemBillable__c = Decimal.valueOf(reqJSON.DataArea.ItemBillable);
            quoteObj.ItemGrossSell__c = Decimal.valueOf(reqJSON.DataArea.ItemGrossSell);
            quoteObj.ItemWarranty__c = Decimal.valueOf(reqJSON.DataArea.ItemWarranty);
            quoteObj.LaborBillable__c = Decimal.valueOf(reqJSON.DataArea.LaborBillable);
            quoteObj.LaborGrossSell__c = Decimal.valueOf(reqJSON.DataArea.LaborGrossSell);
            quoteObj.LaborWarranty__c = Decimal.valueOf(reqJSON.DataArea.LaborWarranty);
            quoteObj.MiscBillable__c = Decimal.valueOf(reqJSON.DataArea.MiscBillable);
            quoteObj.MiscGrossSell__c = Decimal.valueOf(reqJSON.DataArea.MiscGrossSell);
            quoteObj.MiscWarranty__c = Decimal.valueOf(reqJSON.DataArea.MiscWarranty);
            quoteObj.OrderReference__c = reqJSON.DataArea.OrderReference; //Quote number
            quoteObj.QuoteTotal__c = Decimal.valueOf(reqJSON.DataArea.QuoteTotal);
            quoteObj.Surcharge__c = Decimal.valueOf(reqJSON.DataArea.Surcharge);
            quoteObj.ServiceName__c = reqJSON.Header.Sender.ServiceName;
            quoteObj.SenderID__c = reqJSON.Header.Sender.SenderID;
            quoteObj.TargetID__c = reqJSON.Header.Target.TargetID;
            quoteObj.LocationID__c = reqJSON.Header.Location.LocationID;
            quoteObj.Taxes__c = Decimal.valueOf(reqJSON.DataArea.Taxes);
            quoteObj.TransactionType__c = reqJSON.DataArea.TransactionType;
            //here retrive Service Job record with Id based input CSSJOBID value
            CSS_Job_Order__c jobOrderObj = [select Id, Name from CSS_Job_Order__c where Name=:reqJSON.DataArea.CSSJobID];
            quoteObj.Service_Job__c = jobOrderObj.Id;
            insert quoteObj;
            System.debug('created New QuoteID>>>>>>>>>>>>>>>>>>>>>>>>>>:'+quoteObj.Id);
            return quoteObj.Id;
        }catch(Exception ex){
            System.debug('in catch of createNewQuote of CSS_FN_BMS>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return null;
    }
    
    /*
* This method is used for creating a new Quote
*/ 
    public Id createQuoteAttachment(CSS_WPR_BMS_WOQTOutboundQuoteReqJSON reqJSON, String quoteId){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into createQuoteAttachment method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        try{
            Attachment attach = new Attachment();
            attach.Name = 'Auto Attachment';
            attach.ParentId = quoteId;
            attach.ContentType = 'application/pdf'; //attachObj.DataArea.QuoteDoc.ContentType;
            String encodedString = reqJSON.DataArea.QuoteDoc.Body.realBlobValue.asByteArray;
            Blob fileBlobData = EncodingUtil.base64Decode(encodedString);
            attach.Body = fileBlobData;
            insert attach;      
            System.debug('created successfully New AttachmentId>>>>>>>>>>>>>>>>>>>>>>>>>>:'+attach.Id);
            return attach.Id;
        }catch(Exception ex){
            System.debug('in catch of createQuoteAttachment of CSS_FN_BMS>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return null;
    }
    
    /*
* This method is used for preparing Response Wrapper for the service
*/ 
    public CSS_WPR_BMS_WOQTOutboundQuoteResJSON prepareWOQTOutboundQuoteResWrapper(String status, String returnCodeDescription, String locationID){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareWOQTOutboundQuoteResWrapper method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_BMS_WOQTOutboundQuoteResJSON resJSON = null;
        CSS_WPR_BMS_WOQTOutboundQuoteResJSON.Header resHeader = null;
        try{
            resHeader = new CSS_WPR_BMS_WOQTOutboundQuoteResJSON.Header();
            resHeader.Status = status;
            resHeader.ReturnCodeDescription = returnCodeDescription;
            resHeader.Location = new CSS_WPR_BMS_WOQTOutboundQuoteResJSON.Location();
            resHeader.Location.locationID = locationID;
            
            resJSON = new CSS_WPR_BMS_WOQTOutboundQuoteResJSON();
            resJSON.Header = resHeader;
            System.debug('before returning Response JSON>>>>>>>>>>>>>>>>>>>>>>>>>>resJSON:'+resJSON);
        }catch(Exception ex){
            System.debug('in catch of prepareWOQTOutboundQuoteResWrapper of CSS_FN_BMS>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            resHeader = null;
        }
        return resJSON;
    }
    
    
    public CSS_BMSContactLookupRequestJ2A CustomerContactReq;
    public CSS_BMSContactLookupResponseJ2A CustomerContactDetails;
    //Added Location code parameter for story# 76192
    /*public CSS_BMSContactLookupResponseJ2A getBMSContactDetails_Existing(String CustomerCode, String locationCode){
        //making a callout to get the details
        if(CustomerCode!= null && CustomerCode != ''){
            //calling getAccessToken Service
            //String accessToken = CSS_WS_OAG.getAccessToken(); //Commented for dynamic Authentication
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('BMS').AuthEnv__c);
            String accessToken = accessTokenOPWrap.accessToken;
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                   css_utility.LogOutIntError('CSS_FN_BMS-ContactLookupService', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                   return null;
               }
            /-- Preparing the Request Wrapper Class for Contact Lookup Service--/
            CustomerContactReq = prepareRqWrapperBMSContactLookup(CustomerCode, locationCode);
            String CustomerContactReqBody = JSON.serialize(CustomerContactReq);
            //calling contactLookup webservice
            String endPointURL = CSS_getConnnectionDetails.getConnection('BMS').End_Point__c + 'bmscustomercontact';
            HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(CustomerContactReqBody, endPointURL, accessToken);
            system.debug('httpRes>>>>>>'+httpRes);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                css_utility.LogOutIntError('CSS_FN_BMS-BMSContactLookupService', 'BMS Contact Lookup HttpResponse is null', 'BMS ContactLookUp Webservice Execution failed', 'BMS');
                return null;
            }else if(httpRes.getBody().contains('OSB Service Callout action received SOAP Fault response') ){
                System.debug('Incorrect json format-- STATUS:'+httpRes.getStatus()+'STATUS_CODE:'+httpRes.getStatusCode());
                css_utility.LogOutIntError('CSS_FN_BMS-BMSContactLookupService', 'BMS ContactLookupService gives wrong response', 'OSB Service Callout action received SOAP Fault response', 'BMS');
                return null;
            }
            CustomerContactDetails = (CSS_BMSContactLookupResponseJ2A)JSON.deserializeStrict(httpRes.getBody(), CSS_BMSContactLookupResponseJ2A.class);
            return CustomerContactDetails;
        }
        return null;
    }*/
    public CSS_BMSContactLookupResponseJ2A getBMSContactDetails(String CustomerCode, String locationCode){
        //making a callout to get the details
        if(CustomerCode!= null && CustomerCode != ''){
            //calling getAccessToken Service
            //String accessToken = CSS_WS_OAG.getAccessToken(); //Commented for dynamic Authentication
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('BMSContactOutbound').AuthEnv__c,'BMSContactOutbound');
            String accessToken = accessTokenOPWrap.accessToken;
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                   css_utility.LogOutIntError('CSS_FN_BMS-ContactLookupService', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                   return null;
               }
               system.debug('accessToken**'+accessToken);
            /***** Preparing the Request Wrapper Class for Contact Lookup Service****/
            /*CustomerContactReq = prepareRqWrapperBMSContactLookup(CustomerCode, locationCode);
            String CustomerContactReqBody = JSON.serialize(CustomerContactReq);
            //calling contactLookup webservice
            String endPointURL = CSS_getConnnectionDetails.getConnection('BMS').End_Point__c + 'bmscustomercontact';
            HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(CustomerContactReqBody, endPointURL, accessToken);*/
            String endPointURL = CSS_getConnnectionDetails.getConnection('BMSContactOutbound').End_Point__c+'?sender=CSS&target=BMS&locationId='+locationCode+'&customerCode='+CustomerCode+'';
            //system.debug('httpRes>>>>>>'+httpRes);
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.methodType = 'GET';
            reqWrapper.serviceName='BMSContactOutbound';
            reqWrapper.endPoint=endPointURL;
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            string jsonResponse;
            if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
            jsonResponse = returnWrapper.response.getBody();
            system.debug('returnWrapper**'+returnWrapper);
            system.debug('jsonResponse**'+jsonResponse);
            if(returnWrapper == null || returnWrapper.response.getStatusCode() != 200){
                css_utility.LogOutIntError('CSS_FN_BMS-BMSContactLookupService', 'BMS Contact Lookup HttpResponse is null', 'BMS ContactLookUp Webservice Execution failed', 'BMS');
                return null;
            }else if(returnWrapper.response.getBody().contains('OSB Service Callout action received SOAP Fault response') ){
                System.debug('Incorrect json format-- STATUS:'+returnWrapper.response.getStatus()+'STATUS_CODE:'+returnWrapper.response.getStatusCode());
                css_utility.LogOutIntError('CSS_FN_BMS-BMSContactLookupService', 'BMS ContactLookupService gives wrong response', 'OSB Service Callout action received SOAP Fault response', 'BMS');
                return null;
            }
            if(Test.isRunningTest())
            jsonResponse='{"Header":{"Sender":{"ServiceName":"GetContactInfo","SenderID":"CSS"},"Status":"ERROR","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"CustomerCode : test - DistributorCode : test - Distributor Not Setup","Location":{"LocationID":"test"}}}';
            CustomerContactDetails = (CSS_BMSContactLookupResponseJ2A)JSON.deserializeStrict(jsonResponse, CSS_BMSContactLookupResponseJ2A.class);
            return CustomerContactDetails;
        }
        return null;
    }
    
    public CSS_BMSContactLookupRequestJ2A prepareRqWrapperBMSContactLookup(String CustomerCode, String locationCode){
        
        CustomerContactReq = new CSS_BMSContactLookupRequestJ2A();
        CustomerContactDetails = new CSS_BMSContactLookupResponseJ2A();
        CSS_BMSContactLookupRequestJ2A.Header HeaderDetails = new CSS_BMSContactLookupRequestJ2A.Header();
        CSS_BMSContactLookupRequestJ2A.Sender SenderDetails = new CSS_BMSContactLookupRequestJ2A.Sender();
        SenderDetails.ServiceName = 'GetContactInfo';
        SenderDetails.SenderID = 'CSS';
        HeaderDetails.Sender = SenderDetails;
        CSS_BMSContactLookupRequestJ2A.Target TargetDetails = new CSS_BMSContactLookupRequestJ2A.Target();
        TargetDetails.TargetID = 'BMS';
        HeaderDetails.Target = TargetDetails;
        CSS_BMSContactLookupRequestJ2A.Location LocationDetails = new CSS_BMSContactLookupRequestJ2A.Location();
        //Modified code for story# 76192 
        //LocationDetails.LocationID = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
        LocationDetails.LocationID = locationCode;
        HeaderDetails.Location = LocationDetails;
        CustomerContactReq.Header = HeaderDetails;
        CSS_BMSContactLookupRequestJ2A.DataArea DTA = new CSS_BMSContactLookupRequestJ2A.DataArea();
        DTA.CustomerCode = CustomerCode;
        CustomerContactReq.DataArea = DTA;
        
        return CustomerContactReq;
    }
    
    public CSS_BMSUnitLookupRequestJ2A UnitLookupReq;
    public CSS_UnitOutboundJSON2Apex UnitLookupDetails;
    public CSS_UnitOutboundJSON2Apex restrictedHundredUnitLookupDetails;
    //Added Location code parameter for story# 76192
    /*public CSS_UnitOutboundJSON2Apex getBMSUnitLookupDetails_Existing(String CustomerCode, String ESN,String UnitNumber,String locationCode){
        try{ //making a callout to get the details
            if(CustomerCode!= null && CustomerCode != ''){
                //calling getAccessToken Service
                //String accessToken = CSS_WS_OAG.getAccessToken(); //Commented for dynamic Authentication
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('BMS').AuthEnv__c);
            String accessToken = accessTokenOPWrap.accessToken;
                if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
                   || String.isEmpty(accessToken) ){
                    css_utility.LogOutIntError('CSS_FN_BMS-UnitLookupService', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                    return null;
                }
                // Preparing the Request Wrapper Class for Contact Lookup Service//
                UnitLookupReq = prepareRqWrapperBMSUnitLookup(CustomerCode,ESN,UnitNumber,locationCode);
                String unitLookupReqBody = JSON.serialize(UnitLookupReq);
                //calling contactLookup webservice
                String endPointURL = CSS_getConnnectionDetails.getConnection('BMS').End_Point__c + 'bmsunit';
                HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(unitLookupReqBody, endPointURL, accessToken);
                system.debug('httpRes>>>>>>'+httpRes);
                if(httpRes == null || httpRes.getStatusCode() != 200){
                    css_utility.LogOutIntError('CSS_FN_BMS-BMSUnitLookupService', 'BMS Contact Lookup HttpResponse is null', 'BMS ContactLookUp Webservice Execution failed', 'BMS');
                    return null;
                }else if(httpRes.getBody().contains('OSB Service Callout action received SOAP Fault response') ){
                    System.debug('Incorrect json format-- STATUS:'+httpRes.getStatus()+'STATUS_CODE:'+httpRes.getStatusCode());
                    css_utility.LogOutIntError('CSS_FN_BMS-BMSUnitLookupService', 'BMS UnitLookupService gives wrong response', 'OSB Service Callout action received SOAP Fault response', 'BMS');
                    return null;
                }
                UnitLookupDetails = (CSS_UnitOutboundJSON2Apex)JSON.deserializeStrict(httpRes.getBody(), CSS_UnitOutboundJSON2Apex.class);
                system.debug('Before restricting values');
                if(UnitLookupDetails.DataArea!= null && UnitLookupDetails.DataArea.size()>0){
                restrictedHundredUnitLookupDetails = restrictUnitLookupResultsToHundred(UnitLookupDetails);
                }else{
                    restrictedHundredUnitLookupDetails = UnitLookupDetails;
                }
                system.debug('After restricting values');
                if(httpRes!=null && httpRes.getStatusCode()!=200 && httpRes.getStatusCode()!=201){
                //CSS_PageErrorHandlingUtility.showError('CSS is unable to establish integration services at this time.  No Data returned.  Please capture customer information.');
                throw new CSS_CustomException('System is Down' + httpRes.getStatusCode());
            }
                return restrictedHundredUnitLookupDetails;
            }
        }catch(exception e){
            String httpRes = '{"Header":{"Status":"SYSTEM","Sender":{"ServiceName":"GetCustomer","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"02400-02394"}},"DataArea": []}';
            UnitLookupDetails = (CSS_UnitOutboundJSON2Apex)JSON.deserializeStrict(httpRes, CSS_UnitOutboundJSON2Apex.class);
            system.debug('Entered into catch block of Unit Outbound Details in CSS_FN_BMS Class'+e.getMessage() + ' ' + e.getLineNumber());
            return UnitLookupDetails;
        }
        return null;
    }*/
     public CSS_UnitOutboundJSON2Apex getBMSUnitLookupDetails(String CustomerCode, String ESN,String UnitNumber,String locationCode){
        try{ //making a callout to get the details
            if(CustomerCode!= null && CustomerCode != ''){
                //calling getAccessToken Service
                //String accessToken = CSS_WS_OAG.getAccessToken(); //Commented for dynamic Authentication
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('BMSUnitService').AuthEnv__c,'BMSUnitService');
            String accessToken = accessTokenOPWrap.accessToken;
                if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
                   || String.isEmpty(accessToken) ){
                    css_utility.LogOutIntError('CSS_FN_BMS-UnitLookupService', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                    return null;
                }
                /***** Preparing the Request Wrapper Class for Contact Lookup Service****/
                //UnitLookupReq = prepareRqWrapperBMSUnitLookup(CustomerCode,ESN,UnitNumber,locationCode);
                //String unitLookupReqBody = JSON.serialize(UnitLookupReq);
                //calling contactLookup webservice
                String endPointURL = CSS_getConnnectionDetails.getConnection('BMSUnitService').End_Point__c;
                //HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(unitLookupReqBody, endPointURL, accessToken);
                //system.debug('httpRes>>>>>>'+httpRes);
                CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
                reqWrapper.endPoint = endPointURL+'?sender=CSS&target=BMS&locationId='+locationCode+'&esn='+ESN+'&customerCode='+CustomerCode+'&unitNumber=&registration=&vin=';
            reqWrapper.methodType = 'GET';
            reqWrapper.serviceName='BMSUnitService';
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            string jsonResponse;
            if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
            jsonResponse = returnWrapper.response.getBody();
                if(returnWrapper == null || returnWrapper.response.getStatusCode() != 200){
                    css_utility.LogOutIntError('CSS_FN_BMS-BMSUnitLookupService', 'BMS Contact Lookup HttpResponse is null', 'BMS ContactLookUp Webservice Execution failed', 'BMS');
                    return null;
                }else if(returnWrapper.response.getBody().contains('OSB Service Callout action received SOAP Fault response') ){
                    System.debug('Incorrect json format-- STATUS:'+returnWrapper.response.getStatus()+'STATUS_CODE:'+returnWrapper.response.getStatusCode());
                    css_utility.LogOutIntError('CSS_FN_BMS-BMSUnitLookupService', 'BMS UnitLookupService gives wrong response', 'OSB Service Callout action received SOAP Fault response', 'BMS');
                    return null;
                }
                UnitLookupDetails = (CSS_UnitOutboundJSON2Apex)JSON.deserializeStrict(returnWrapper.response.getBody(), CSS_UnitOutboundJSON2Apex.class);
                system.debug('Before restricting values');
                if(UnitLookupDetails.DataArea!= null && UnitLookupDetails.DataArea.size()>0){
                restrictedHundredUnitLookupDetails = restrictUnitLookupResultsToHundred(UnitLookupDetails);
                }else{
                    restrictedHundredUnitLookupDetails = UnitLookupDetails;
                }
                system.debug('After restricting values');
                if(returnWrapper!=null && returnWrapper.response.getStatusCode()!=200 && returnWrapper.response.getStatusCode()!=201){
                //CSS_PageErrorHandlingUtility.showError('CSS is unable to establish integration services at this time.  No Data returned.  Please capture customer information.');
                throw new CSS_CustomException('System is Down' + returnWrapper.response.getStatusCode());
            }
                return restrictedHundredUnitLookupDetails;
            }
        }catch(exception e){
            String httpRes = '{"Header":{"Status":"SYSTEM","Sender":{"ServiceName":"GetCustomer","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"02400-02394"}},"DataArea": []}';
            UnitLookupDetails = (CSS_UnitOutboundJSON2Apex)JSON.deserializeStrict(httpRes, CSS_UnitOutboundJSON2Apex.class);
            system.debug('Entered into catch block of Unit Outbound Details in CSS_FN_BMS Class'+e.getMessage() + ' ' + e.getLineNumber());
            return UnitLookupDetails;
        }
        return null;
    }
    public class CSS_CustomException extends Exception {}
    public CSS_BMSUnitLookupRequestJ2A prepareRqWrapperBMSUnitLookup(String CustomerCode, String ESN, String UnitNumber, String locationCode){
        
        UnitLookupReq = new CSS_BMSUnitLookupRequestJ2A(); 
        CSS_BMSUnitLookupRequestJ2A.Header HeaderDetails = new CSS_BMSUnitLookupRequestJ2A.Header();
        CSS_BMSUnitLookupRequestJ2A.Sender SenderDetails = new CSS_BMSUnitLookupRequestJ2A.Sender();
        SenderDetails.ServiceName = 'GetUnitInfo';
        SenderDetails.SenderID = 'CSS';
        HeaderDetails.Sender = SenderDetails;
        CSS_BMSUnitLookupRequestJ2A.Target TargetDetails = new CSS_BMSUnitLookupRequestJ2A.Target();
        TargetDetails.TargetID = 'BMS';
        HeaderDetails.Target = TargetDetails;
        CSS_BMSUnitLookupRequestJ2A.Location LocationDetails = new CSS_BMSUnitLookupRequestJ2A.Location();
        //Modified code for story# 76192 
        //LocationDetails.LocationID = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
        LocationDetails.LocationID = locationCode;
        HeaderDetails.Location = LocationDetails;
        UnitLookupReq.Header = HeaderDetails;
        CSS_BMSUnitLookupRequestJ2A.DataArea DTA = new CSS_BMSUnitLookupRequestJ2A.DataArea();
        DTA.CustomerCode = CustomerCode;
        DTA.ESN = ESN;
        DTA.UnitNumber = UnitNumber;
        
        UnitLookupReq.DataArea = DTA;
        
        return UnitLookupReq;
    }
    
    public List<CSS_UnitOutboundJSON2Apex.DataArea> paginatedUnitDetails {get;set;}
    Transient List<CSS_UnitOutboundJSON2Apex.DataArea> fullUnitDetails {get;set;} 
    public CSS_UnitOutboundJSON2Apex restrictUnitLookupResultsToHundred(CSS_UnitOutboundJSON2Apex UnitLookupDetails){
        try{
        fullUnitDetails = UnitLookupDetails.DataArea;
        paginatedUnitDetails = new List<CSS_UnitOutboundJSON2Apex.DataArea>();
            system.debug('fullUnitDetails>>>>>'+fullUnitDetails);
            paginatedUnitDetails.clear();
        for(Integer i=0;i<fullUnitDetails.size() && i < 100;i++){
            //if(i<=fullUnitDetails.size()){
                //if(fullUnitDetails[i] != null)
                paginatedUnitDetails.add(fullUnitDetails.get(i));
            //}
        }
        fullUnitDetails = new List<CSS_UnitOutboundJSON2Apex.DataArea>(); 
        UnitLookupDetails.DataArea = paginatedUnitDetails;
            //paginatedUnitDetails.clear();
        return UnitLookupDetails;
        }catch(exception e){
            system.debug('Entered into catch block of restrictUnitLookupResultsToHundred in CSS_FN_BMS Controller' + ' ' + 'LineNumber>>>'+e.getLineNumber() + ' ' + 'Message>>>>' + ' ' + e.getMessage());
        return null;
        }
    }
    
}