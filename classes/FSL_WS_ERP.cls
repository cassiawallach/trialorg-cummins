/**********************************************************************
Name: FSL_WS_ERP
Copyright © 2019  Cummins
======================================================
======================================================
Purpose: Class for MoveX WorkOrder Creation 
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR            DATE            DETAIL                                 
v1.0     Sriprada Sesham    08/10/2019     Initial Development
V1.1      Harsha            06/03/2020     Modifications
v1.2      Harsha Ragam      09/08/2020      Mule Api Changes for BMS WO-WOQT-Inbound
v1.3      Shirisha Pedditi  05/25/2022      Added Named credentials
v1.4      Naveen            05/08/2022      Added Wrapper class to pass the parameters in callBMSWOQTInboundService method
***********************************************************************/
 public class FSL_WS_ERP {
 /*public static FSL_BMSWOQTInboundJSON2APEX callBMSWOQTInboundService(String CSSJobID,String OrderType,String custCode,String Inshop,String CreateDate,
                                                                        String PromisedDate,String ScheduledDate,String BillType,String ContactName,String CustomerPhone,String SubType,
                                                                        String UnitNumber,String Model,String Make,String ServiceModelName,String EngineFamily,String ESN,
                                                                        String Application,String location,String ContactID,String EmailID,String CreateUser,String ChangeUser,
                                                                        String Planned, String SiteID,String CustomersPO,String PayerID,String Notes,String Source,String individualItemNumber,String PayerContactID,String strconMunerMPnumber,String DistanceType,String Distance,String Hours) {
                                                                            system.debug('CustomerPhone****'+CustomerPhone+':::SubType:::'+SubType);
                                                                            system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>................');
                                                                            
               */   
    
    public static FSL_BMSWOQTInboundJSON2APEX callBMSWOQTInboundService(inputWrapperParams Wrp){    
               
                                                                            
        FSL_BMSWOQTInboundJSON2APEX WOQTInboundDetails = null;
        string message;
        String PhoneNumber;
        Boolean bmsWORetry;
        Integer bmsWORetryCount = 1;
        String jsonResponse = '';
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper = null;
               //added As a part of FBI 393 //User usr = new User();
               User usr = [SELECT Id,ERP__c
                       FROM User
                       WHERE Id=:UserInfo.getUserId() LIMIT 1];
                                                                            
                reqWrapper= new FSL_IP_NamedCredentialWrapper();
                reqWrapper.methodType = 'POST';
	    	    reqWrapper.NamedCredential = 'FSL_NC_Workorders';
	    	    reqWrapper.Path = '/workorder';
	    	    reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;//added As a part of FBI 393
                                                                            

        do {
            bmsWORetry = false;
            try {
                //Added by Shirisha(Road-372 Named Credentials) Commented As a part of FBI 393
                /*reqWrapper= new FSL_IP_NamedCredentialWrapper();
                reqWrapper.methodType = 'POST';
	    	    reqWrapper.NamedCredential = 'FSL_NC_Workorders';
	    	    reqWrapper.Path = '/workorder';
	    	    reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;*/
                reqWrapper.WorkOrder=Wrp.CSSJobID;
                //Added Ravikanth
                String[] strConMP = Wrp.strconMunerMPnumber.split('-',2);   
                string strContractnumber ;   
                string MaintenancePlanNumber ;
                if(strConMP[0]!='null'){
                    strContractnumber =strConMP[0];
                } else{
                    strContractnumber ='';
                }                                                              
                if(strConMP[1]!='null'){
                    MaintenancePlanNumber =strConMP[1];
                }else{
                    MaintenancePlanNumber='';
                }
                
                
                if(Wrp.SubType == null) {
                    Wrp.SubType = '';
                }
                if(Wrp.ESN == null) {
                    Wrp.ESN = '';
                }
                if(Wrp.Make == null) {
                    Wrp.Make = '';
                }
                if(Wrp.Model == null) {
                    Wrp.Model = '';
                }
                if(Wrp.ServiceModelName == null) {
                    Wrp.ServiceModelName = '';
                }
                if(Wrp.UnitNumber == null) {
                    Wrp.UnitNumber = '';
                }
                if(Wrp.EngineFamily == null) {
                    Wrp.EngineFamily = '';
                }
                if(Wrp.CreateUser == null) {
                    Wrp.CreateUser = '';
                }
                if(Wrp.SiteID == null) {
                    Wrp.SiteID = '';
                }
                if(Wrp.CustomersPO == null) {
                    Wrp.CustomersPO = '';
                }
                // Start - Added by Naveen - Phoen-271
                if(Wrp.DistanceType == null || Wrp.DistanceType == '') {
                    Wrp.DistanceType = '';
                } 
                
                if(Wrp.Distance == null || Wrp.Distance == '') {
                    Wrp.Distance = '';
                }
                
                if(Wrp.Hours == null || Wrp.Hours == '') {
                    Wrp.Hours = '';
                }
                //End - Added by Naveen - Phoen-271
                
                /*Phoen-224 Code change start
                if(string.isNotEmpty(Notes)){
                    Notes = EncodingUtil.urlEncode(Notes,'UTF-8');
                } //Phoen-224 Code change end */
                String distrCode = '';
                String brnchCode = '';
                String[] locArray;
                if(Wrp.location != null && Wrp.location != '')
                    locArray = Wrp.location.split('-');
                if(locArray != null && locArray.size()>0){
                    distrCode = locArray[0];
                    brnchCode = locArray[1].substring(0,5);
                }
                system.debug('CustomerPhone>>>'+wrp.CustomerPhone);
                if(string.isNotBlank(wrp.CustomerPhone)){
                    PhoneNumber = ((wrp.CustomerPhone.remove('(')).remove(')').trim()).replace(' ', '-');
                }
                system.debug('PhoneNumber>>>after>>'+PhoneNumber);
                string SourceType= System.Label.FSL_Source_Environment_Type;
                system.debug('SourceType>>>after>>'+SourceType);
                // Building Request Body or request String
                // Check the ERP ("TargetID") to which Request is being sent
                // This is for MoveX for now
                // Harsha changed for TargetID
               /* User usr = new User();
                usr = [SELECT Id,ERP__c
                       FROM User
                       WHERE Id=:UserInfo.getUserId() LIMIT 1];*/
                String TargetERP;
                TargetERP = (String)usr.ERP__c;
                string JSONReq = '{"Header": { "Sender": { "ServiceName": "CreateWorkOrder", "SenderID": "CSS" }, "Target": { "TargetID": "'+TargetERP+'" }, '+
                    '"Location": { "LocationID": "'+wrp.location+'" } }, "DataArea": { "CSSJobID": "'+wrp.CSSJobID+'", "DistributorCode": "'+distrCode+'",'+
                    ' "BranchCode": "'+brnchCode+'", "OrderType": "'+wrp.OrderType+'", "CustomerNumber": "'+wrp.custCode+'", "Inshop": "'+wrp.Inshop+'", '+
                    '"CreateDate": "'+wrp.CreateDate+'", "PromisedDate": "'+wrp.PromisedDate+'","ScheduledDate":"'+wrp.ScheduledDate+'","BillType": "'+wrp.BillType+'", '+
                    '"CustomerName": "'+wrp.ContactName+'", "CustomerPhone": "'+PhoneNumber+'", "SubType": "'+wrp.SubType+'", "UnitNumber": "'+wrp.UnitNumber+'", '+
                    '"Model": "'+wrp.Model+'", "Make": "'+wrp.Make+'", "ServiceModelName": "'+wrp.ServiceModelName+'", "EngineFamily": "'+wrp.EngineFamily+'", '+
                    '"ESN": "'+wrp.ESN+'", "Application": "'+wrp.Application+'","ContactID": "'+wrp.ContactID+'","EmailId": "'+wrp.EmailID+'","CreateUser": "'+wrp.CreateUser+'",'+
                    '"ChangeUser": "'+wrp.ChangeUser+'" ,"Source":"'+SourceType+'", "Planned": "'+wrp.Planned+'", "SiteID": "'+wrp.SiteID+'", "CustomersPO": "'+wrp.CustomersPO+'", "PayerID": "'+wrp.PayerID+'", "Notes": "'+wrp.Notes+'","IndividualItemNumber": "'+wrp.individualItemNumber+'","PayerContactID": "'+wrp.PayerContactID+'","ContractNumber": "'+strContractnumber+'","MaintenancePlanNo": "'+MaintenancePlanNumber+'",'+
                    '"DistanceType": "'+Wrp.DistanceType+'","Distance": "'+Wrp.Distance+'","Hours": "'+Wrp.Hours+'"}}';
                
                
                
                if(TargetERP != 'BMS'){
                    JSONReq = JSONReq.replaceFirst('##Blank###', '     ');
                }
                //Added by Shirisha(Road-372 Named Credentials)
                reqWrapper.jsonReqBody=JSONReq;
                    returnWrapper =  FSL_WS_Mule.calloutNamedCredentials(reqWrapper);     
                
               system.debug('StatusCode>>>>: '+returnWrapper.response.getStatusCode());
               system.debug('Status>>>>: '+returnWrapper.response.getStatus());
               system.debug('Response body>>>:'+returnWrapper.response.getbody());
                //Setting Reponse to a string
                jsonResponse = returnWrapper.response.getbody();
                string returnval;
                if(jsonResponse.contains('"Status":'))
                 {
                JSONParser parser = JSON.createParser(jsonResponse);
                while (parser.nextToken() != null)
                {
                if(parser.getText() == 'Status')
                    {
                    parser.nextToken();
                    returnval = (parser.getText());  
                    }
                }
                }
                System.debug('entered FSL_WS_ERP CreateWorkOder  error and printing response:'+jsonResponse);
                System.debug('FSL_WS_ERP CreateWorkOder jsonresponse returnval:'+returnval); 
                
                    if(returnWrapper.response != null && ((returnWrapper.response.getStatusCode()!=200 && returnWrapper.response.getStatusCode()!=201) || (returnval == 'ERROR' || returnval == 'FAIL')) ) {  //&& !Test.isRunningTest()
                        System.debug('entered into CreateWorkOder integration log error and printing message:'+message); 
                        FSL_ApplicationLogger.insertFSLIntegrationErrorLog(JSONReq,String.valueOf(returnWrapper.response),'CreateWorkOder','Error',String.valueOf(TargetERP),'toolId','CSS');
                        System.debug(' CreateWorkOder logged integration log:'); 
                    } 
                if(Test.isRunningTest())
                        jsonResponse='{"DataArea":{"CSSJobID":"","ContactID":0,"WOReferenceNumber":0},"Header":{"Status":"ERROR","ReturnCodeDescription":"Customer number is null,deactivated or does not exist in BMS. Dist-Branch 02930-02434 is not active for CSS integration in BMS. Sub-type is not active or does not exist in BMS."}}';
                
                if(returnWrapper.response.getStatusCode()!=200 && returnWrapper.response.getStatusCode()!=201) {
                    throw new CSS_CustomException('System is Down' + returnWrapper.response.getStatusCode());
                }
            } catch(Exception ex) {
                System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
                System.debug('getLineNumber*********************is :: '+ex.getMessage());
                if(!Test.isRunningTest()){
                    message = ex.getMessage(); //System.CalloutException
                    String eType = ex.getTypeName();
                    system.debug('exception message is -->'+ ex.getTypeName());
                    if(message.equalsignorecase('Read timed out') || eType.contains('CalloutException')) {
                        bmsWORetryCount = bmsWORetryCount + 1;
                        bmsWORetry = TRUE;
                        system.debug('retryValue is -->' +bmsWORetryCount);
                        system.debug('reTry flag is -->' +bmsWORetry);
                    }

                }
            }
        } while(bmsWORetryCount <= Integer.valueof(Label.CSS_bmsretryServices) && bmsWORetry == TRUE);
        try{
            // Deserialize the response from web service respose__c field to the Wrapper Class
        WOQTInboundDetails = (FSL_BMSWOQTInboundJSON2APEX)JSON.deserializeStrict(jsonResponse,FSL_BMSWOQTInboundJSON2APEX.class);
        system.debug('WOQTInboundDetails>>>>' + WOQTInboundDetails.Header);
        }
        Catch(Exception ex1){
             System.debug('getLineNumber*********************is :: '+ex1.getLineNumber());
             System.debug('getLineNumber*********************is :: '+ex1.getMessage());                                                                    
        }
        return WOQTInboundDetails;
    }
    
    // Start - Code added by Naveen - PHOEN-271
   //Wrapper class to accept all input parameters
    public class inputWrapperParams{
        Public String CSSJobID;
        Public String OrderType;
        Public String custCode;
        Public String Inshop;
        Public String CreateDate;
        Public String PromisedDate;
        Public String ScheduledDate;
        Public String BillType;
        Public String ContactName;
        Public String CustomerPhone;
        Public String SubType;
        Public String UnitNumber;
        Public String Model;
        Public String Make;
        Public String ServiceModelName;
        Public String EngineFamily;
        Public String ESN;
        Public String Application;
        Public String location;
        Public String ContactID;
        Public String EmailID;
        Public String CreateUser;
        Public String ChangeUser;
        Public String Planned;
        Public String SiteID;
        Public String CustomersPO;
        Public String PayerID;
        Public String Notes;
        Public String Source;
        Public String individualItemNumber;
        Public String PayerContactID;
        Public String strconMunerMPnumber;
        Public String DistanceType;
        Public String Distance;
        Public String Hours;
        
    }
 // END - added by Naveen - Phoen-271

    
    public class CSS_CustomException extends Exception {
        
    }
}

/**  
 public class FSL_WS_ERP {
 public static FSL_BMSWOQTInboundJSON2APEX callBMSWOQTInboundService(String CSSJobID,String OrderType,String custCode,String Inshop,String CreateDate,
                                                                        String PromisedDate,String ScheduledDate,String BillType,String ContactName,String CustomerPhone,String SubType,
                                                                        String UnitNumber,String Model,String Make,String ServiceModelName,String EngineFamily,String ESN,
                                                                        String Application,String location,String ContactID,String EmailID,String CreateUser,String ChangeUser,
                                                                        String Planned, String SiteID,String CustomersPO,String PayerID,String Notes,String Source,String individualItemNumber,String PayerContactID,String strconMunerMPnumber) {
                                                                            system.debug('CustomerPhone****'+CustomerPhone+':::SubType:::'+SubType);
                                                                            system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>................');
                                                                            
                                                                                     
                                                                            
        FSL_BMSWOQTInboundJSON2APEX WOQTInboundDetails;
        String endPointURL;
        string message;
        HttpResponse res1;
        String bmsUsername;
        String bmsPassword;
        //@TestVisible
        String PhoneNumber;
        Boolean bmsWORetry;
        Integer bmsWORetryCount = 1;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        String jsonResponse = '';
        do {
            bmsWORetry = false;
            try {
                Http h1 = new Http();
                HttpRequest req1 = new HttpRequest();
                if(!Test.isRunningTest()) {
                    //Added by Harsha Ragam for Mule Api Change
                    //conDetails = CSS_getConnnectionDetails.getConnection('BMS');          
                    conDetails = CSS_getConnnectionDetails.getConnection('BMSWOQTInbound');          
                    bmsUsername = conDetails.Username__c; 
                    bmsPassword = conDetails.Passcode__c;     
                    endPointURL = conDetails.End_Point__c;//'bmsworkorder';
                }
                else {
                    //endPointURL = 'https://services-stg.cummins.com/css/bmsworkorder'; 
                    endPointURL = ' https://api-ue-devnf2-aw-ex.cummins.com/services-workorders/BMSWOQTInbound';
                    //conDetails = CSS_getConnnectionDetails.getConnection('BMSWOQTInbound');
                    
                }
                //String access_token = FSL_WS_OAG.getAccessToken();
               CG_OP_OAGWrapper returnWrapper = null;
                if(!Test.isRunningTest()){
                    returnWrapper =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('BMSWOQTInbound').AuthEnv__c,'BMSWOQTInbound');//Added  OAG to Mule 19/05/2020     
                }else{
                    returnWrapper =new CG_OP_OAGWrapper();
                }
                
                // CG_OP_OAGWrapper returnWrapper =  CG_WS_Mule.getAccessToken('MuleAuth',remoteConName);
                String access_token = returnWrapper.accessToken;
                                
                req1.setHeader('Authorization','Bearer '+access_token);
                // req1.setHeader('Content-Type','application/json');
                req1.setHeader('Content-Type','application/json;charset=UTF-8');
                req1.setMethod('POST');
                Blob key = Blob.valueOf('12345678901234567890123456789012');
                string algo = 'AES256';
                
                if(Test.isRunningTest()){
                   conDetails.Username__c=conDetails.Username__c==null? '4546545456454545444545':conDetails.Username__c;
                    conDetails.Passcode__c=conDetails.Passcode__c==null? '54654564564654655454564565':conDetails.Passcode__c;
                }
                req1.setHeader('client-id',conDetails.Username__c);
                req1.setHeader('client-secret',conDetails.Passcode__c);

                //End of changes by Harsha Ragam for Mule Api Change
                req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
                // Setting End Point URL
                req1.setEndpoint(endPointURL);
                System.debug('endPointURL '+endPointURL);
                //Added Ravikanth
                String[] strConMP = strconMunerMPnumber.split('-',2);   
                string strContractnumber ;   
                string MaintenancePlanNumber ;
                if(strConMP[0]!='null'){
                    strContractnumber =strConMP[0];
                } else{
                    strContractnumber ='';
                }                                                              
                if(strConMP[1]!='null'){
                    MaintenancePlanNumber =strConMP[1];
                }else{
                    MaintenancePlanNumber='';
                }
                
                
                if(SubType == null) {
                    SubType = '';
                }
                if(ESN == null) {
                    ESN = '';
                }
                if(Make == null) {
                    Make = '';
                }
                if(Model == null) {
                    Model = '';
                }
                if(ServiceModelName == null) {
                    ServiceModelName = '';
                }
                if(UnitNumber == null) {
                    UnitNumber = '';
                }
                if(EngineFamily == null) {
                    EngineFamily = '';
                }
                if(CreateUser == null) {
                    CreateUser = '';
                }
                if(SiteID == null) {
                    SiteID = '';
                }
                if(CustomersPO == null) {
                    CustomersPO = '';
                }
                String distrCode = '';
                String brnchCode = '';
                String[] locArray;
                if(location != null && location != '')
                    locArray = location.split('-');
                if(locArray != null && locArray.size()>0){
                    distrCode = locArray[0];
                    brnchCode = locArray[1].substring(0,5);
                }
                system.debug('CustomerPhone>>>'+CustomerPhone);
                if(string.isNotBlank(CustomerPhone)){
                    PhoneNumber = ((CustomerPhone.remove('(')).remove(')').trim()).replace(' ', '-');
                }
                system.debug('PhoneNumber>>>after>>'+PhoneNumber);
                string SourceType= System.Label.FSL_Source_Environment_Type;
                system.debug('SourceType>>>after>>'+SourceType);
                // Building Request Body or request String
                // Check the ERP ("TargetID") to which Request is being sent
                // This is for MoveX for now
                // Harsha changed for TargetID
                User usr = new User();
                usr = [SELECT Id,ERP__c
                       FROM User
                       WHERE Id=:UserInfo.getUserId() LIMIT 1];
                String TargetERP;
                TargetERP = (String)usr.ERP__c;
                string JSONReq = '{"Header": { "Sender": { "ServiceName": "CreateWorkOrder", "SenderID": "CSS" }, "Target": { "TargetID": "'+TargetERP+'" }, '+
                    '"Location": { "LocationID": "'+location+'" } }, "DataArea": { "CSSJobID": "'+CSSJobID+'", "DistributorCode": "'+distrCode+'",'+
                    ' "BranchCode": "'+brnchCode+'", "OrderType": "'+OrderType+'", "CustomerNumber": "'+custCode+'", "Inshop": "'+Inshop+'", '+
                    '"CreateDate": "'+CreateDate+'", "PromisedDate": "'+PromisedDate+'","ScheduledDate":"'+ScheduledDate+'","BillType": "'+BillType+'", '+
                    '"CustomerName": "'+ContactName+'", "CustomerPhone": "'+PhoneNumber+'", "SubType": "'+SubType+'", "UnitNumber": "'+UnitNumber+'", '+
                    '"Model": "'+Model+'", "Make": "'+Make+'", "ServiceModelName": "'+ServiceModelName+'", "EngineFamily": "'+EngineFamily+'", '+
                    '"ESN": "'+ESN+'", "Application": "'+Application+'","ContactID": "'+ContactID+'","EmailId": "'+EmailID+'","CreateUser": "'+CreateUser+'",'+
                    '"ChangeUser": "'+ChangeUser+'" ,"Source":"'+SourceType+'", "Planned": "'+Planned+'", "SiteID": "'+SiteID+'", "CustomersPO": "'+CustomersPO+'", "PayerID": "'+PayerID+'","IndividualItemNumber": "'+individualItemNumber+'","PayerContactID": "'+PayerContactID+'","ContractNumber": "'+strContractnumber+'","MaintenancePlanNo": "'+MaintenancePlanNumber+'"}}';
                
                
                
                //JSONReq='{"Header":{"Sender":{"ServiceName":"CreateWorkOrder","SenderID":"CSS"},"Target":{"TargetID":"MOVEX"},"Location":{"LocationID":"05340-05911-S"}},"DataArea":{"CSSJobID":"00003854","DistributorCode":"05340","BranchCode":"05911","OrderType":"WO","CustomerNumber":"4410682","Inshop":"N","CreateDate":"2020-03-05T05:48:06","PromisedDate":"","ScheduledDate":"2020-03-05T06:17:07","BillType":"","CustomerName":"null, Kathy","CustomerPhone":"08-8739-9200","SubType":"R8 ","UnitNumber":"","Model":"ALL","Make":"UNLISTED","ServiceModelName":"B4.5 RGT","EngineFamily":"32","ESN":"46780906","Application":"510","ContactID":"1","EmailId":"","CreateUser":"kv360     Chloe D McDiarmid","ChangeUser":"","Source":"CGCSOPRD","Planned":"No","SiteID":"1","CustomersPO":"","PayerID":"4410682","Notes":"Wont Go"}}';
                if(TargetERP != 'BMS'){
                    JSONReq = JSONReq.replaceFirst('##Blank###', '     ');
                }
                req1.setBody(JSONReq);
                
                System.debug('req1.getBody======'+req1.getBody());
                
                //Sending request and mapping the response
                res1 = h1.send(req1);    
                
                System.debug('StatusCode>>>>: '+res1.getStatusCode());
                System.debug('Status>>>>: '+res1.getStatus());
                system.debug('Response body>>>:'+res1.getbody());
                //Setting Reponse to a string
                jsonResponse = res1.getBody();
                string returnval;
                if(jsonResponse.contains('"Status":'))
                 {
                JSONParser parser = JSON.createParser(jsonResponse);
                while (parser.nextToken() != null)
                {
                if(parser.getText() == 'Status')
                    {
                    parser.nextToken();
                    returnval = (parser.getText());  
                    //System.debug('recordId = '+token);
                    }
                }
                }
                System.debug('entered FSL_WS_ERP CreateWorkOder  error and printing response:'+jsonResponse);
                System.debug('FSL_WS_ERP CreateWorkOder jsonresponse returnval:'+returnval); 
                
                    if(res1 != null && ((res1.getStatusCode()!=200 && res1.getStatusCode()!=201) || (returnval == 'ERROR' || returnval == 'FAIL')) && !Test.isRunningTest()) {
                        System.debug('entered into CreateWorkOder integration log error and printing message:'+message); 
                        FSL_ApplicationLogger.insertFSLIntegrationErrorLog(JSONReq,String.valueOf(res1),'CreateWorkOder','Error',String.valueOf(TargetERP),'toolId','CSS');
                        System.debug(' CreateWorkOder logged integration log:'); 
                    } 
                if(Test.isRunningTest())
                        jsonResponse='{"DataArea":{"CSSJobID":"","ContactID":0,"WOReferenceNumber":0},"Header":{"Status":"ERROR","ReturnCodeDescription":"Customer number is null,deactivated or does not exist in BMS. Dist-Branch 02930-02434 is not active for CSS integration in BMS. Sub-type is not active or does not exist in BMS."}}';
                
                if(res1.getStatusCode()!=200 && res1.getStatusCode()!=201) {
                    throw new CSS_CustomException('System is Down' + res1.getStatusCode());
                }
            } catch(Exception ex) {
                System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
                System.debug('getLineNumber*********************is :: '+ex.getMessage());
                if(!Test.isRunningTest()){
                    message = ex.getMessage(); //System.CalloutException
                    String eType = ex.getTypeName();
                    system.debug('exception message is -->'+ ex.getTypeName());
                    if(message.equalsignorecase('Read timed out') || eType.contains('CalloutException')) {
                        bmsWORetryCount = bmsWORetryCount + 1;
                        bmsWORetry = TRUE;
                        system.debug('retryValue is -->' +bmsWORetryCount);
                        system.debug('reTry flag is -->' +bmsWORetry);
                    }
                    
                    if(message.contains('timed out')) {
                      //  css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-Work Order Service', 'RESPONSE IS NULL', 'BMS');
                    }
                    else {
                      //  css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-Work Order Service', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
                    }
                }
            }
        } while(bmsWORetryCount <= Integer.valueof(Label.CSS_bmsretryServices) && bmsWORetry == TRUE);
        // Deserialize the response from web service respose__c field to the Wrapper Class
        WOQTInboundDetails = (FSL_BMSWOQTInboundJSON2APEX)JSON.deserializeStrict(jsonResponse,FSL_BMSWOQTInboundJSON2APEX.class);
        system.debug('WOQTInboundDetails>>>>' + WOQTInboundDetails.Header);
        return WOQTInboundDetails;
    }

    
    
    public class CSS_CustomException extends Exception {
        
    }
}
*/