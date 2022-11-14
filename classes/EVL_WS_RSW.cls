/******************************************************************************************************************
Name: EVL_WS_RSW
Copyright © 2020  Cummins
===================================================================================================================
===================================================================================================================
Purpose:    This class is for Create Claims funtionality.
===================================================================================================================
===================================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Lochana Rajput     06/10/2022     Added Event type attribute for FTR feature in JSON request of RSW 
2.0      Gnyana            07/13/2022     adding  migrated RSW integration to named credential Jira_FBI_364
3.0     Lochana Rajput     07/25/2022     Added Event type attribute as 'DBR' for non-FTR feature in JSON request of RSW 
*******************************************************************************************************************/
public class EVL_WS_RSW {
    @AuraEnabled
    public static void sendClaimInfoToRSW(Id wId){
        string jSONResponseBody = '';
        string cInfoRequest ='';
        WorkOrder recSJob = new WorkOrder();
        try{
            
            //Added below code as part of Mule Integration
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c ();
            conDetails = CSS_getConnnectionDetails.getConnection('RSWClaim');
            
            recSJob = [Select id,Account.Location__c,WorkOrderNumber,Dealer_Shop_Work_Order__c,Engine_Serial_Number__c,Mileage__c,Mileage_Measure__c,
                       Failure_Date__c,Warranty_Start_Date__c,Make__c,Model__c,Application__c,Vehicle_Identification_Number__c,Unit_Number_Formula__c,
                       EVL_Customer__c,Category1__c,Complaint_Type1__c,
                       (SELECT Id, FSL_ABRFlag__c, FSL_TransactionID__c 
                        FROM Service_Order_Extension__r)
                       FROM WorkOrder where Id =: wId];
            
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('RSWClaim').AuthEnv__c,'RSWClaim');
            string accesstoken = accessTokenOPWrap.accessToken;
            
            String ServiceProviderCode;
            String DSID;
            String RONumber;
            String ESN;
            Decimal FailurePoint;
            String FailureMeasure;
            Datetime dtFailureDate;
            String FailureDate;
            Datetime dtWarrantyStartDate;
            string WarrantyStartDate;
            String Make;
            String Model;
            String Application;
            String VIN;
            String UnitNumber;
            String ServiceProviderContact;
            String CustomerName;
            String ComplaintCode;
            Decimal ProductMileage;
            String ProductMileageMeasure;
            
            system.debug('Location'+recSJob.Account.Location__c);
            
            ServiceProviderCode = (recSJob.Account.Location__c != null ? recSJob.Account.Location__c.substring(recSJob.Account.Location__c.indexOf('-')+1) : ''); 
            
            
            system.debug('ServiceProviderCode'+ServiceProviderCode);
            DateTime createdDate;
            for(css_solutions__c sol : [SELECT Id, Name, CreatedDate, LastModifiedDate, FSL_Service_Job__c FROM CSS_Solutions__c where FSL_Service_Job__c =: wId order by CreatedDate ASC LIMIT 1]){
                createdDate = sol.createdDate;
            }
            DSID = createdDate != NULL ? recSJob.WorkOrderNumber : '';
            
            if(recSJob.Dealer_Shop_Work_Order__c != null )
            { RONumber = recSJob.Dealer_Shop_Work_Order__c; } else { RONumber='';}
            
            if(recSJob.Engine_Serial_Number__c  != null ){
                ESN = recSJob.Engine_Serial_Number__c ; } else { ESN = ''; }
            
            /* if (recSJob.Failure_Point__c != null ) {
FailurePoint = recSJob.Failure_Point__c; } else { FailurePoint = 0; }*/
            if (recSJob.Mileage__c != null ) {
                ProductMileage = recSJob.Mileage__c; } else { ProductMileage = 0; } //Mileage_Measure__c
            
            if(recSJob.Mileage_Measure__c=='Miles'){
                ProductMileageMeasure = 'MI';
            } else if(recSJob.Mileage_Measure__c=='Kilometers'){
                ProductMileageMeasure = 'KM';
            } else {
                ProductMileageMeasure = 'HR';
            }
            
            if(recSJob.Failure_Date__c != null ){
                dtFailureDate = datetime.newInstance(recSJob.Failure_Date__c.year(), recSJob.Failure_Date__c.month(),recSJob.Failure_Date__c.day());
                FailureDate = dtFailureDate.format('YYYY-MM-dd') +'T00:00:00';      
            } else { FailureDate = ''; }  
            
            system.debug('FailureDate'+FailureDate);
            
            if(recSJob.Warranty_Start_Date__c != null ){ 
                dtWarrantyStartDate= datetime.newInstance(recSJob.Warranty_Start_Date__c.year(), recSJob.Warranty_Start_Date__c.month(),recSJob.Warranty_Start_Date__c.day());
                WarrantyStartDate=dtWarrantyStartDate.format('YYYY-MM-dd') +'T00:00:00';    
            } else { WarrantyStartDate = ''; }
            
            system.debug('WarrantyStartDate'+WarrantyStartDate);
            
            if(recSJob.Make__c != null ) {
                Make= recSJob.Make__c; } else { make = ''; }
            if(recSJob.Model__c != null && recSJob.Model__c != '') {
                Model= recSJob.Model__c; } else { Model= ''; }
            
            //String Application= recSJob.Application__c;
            if(recSJob.Application__c != null  && recSJob.Application__c.contains('-')) {
                String[] AppCode = recSJob.Application__c.split('-');
                if(AppCode != null && AppCode.size()>0){
                    Application = AppCode[0]; 
                }else{
                    Application = '';
                }
            } 
            else { Application = ''; }
            
            system.debug('recSJob.VIN__c'+recSJob.Vehicle_Identification_Number__c );
            if(recSJob.Vehicle_Identification_Number__c  != null ){
                VIN = recSJob.Vehicle_Identification_Number__c ; } else { 
                    system.debug('VIN'+VIN);
                    VIN = ''; }
            
            if(recSJob.Unit_Number_Formula__c != null ){
                UnitNumber = recSJob.Unit_Number_Formula__c; } else {UnitNumber = '';}
            
            ServiceProviderContact = userinfo.getName(); 
            system.debug('ServiceProviderContact'+ServiceProviderContact);
            
            if(recSJob.EVL_Customer__c != null ) {
                // Ramya: 04/22 Fix for VGRS2-449, Truncating to 30 Characters
                CustomerName =  recSJob.EVL_Customer__c.replace('\"','\\"'); //.replaceAll('[^a-zA-Z0-9\\s+]', '');
                if(CustomerName.length() > 30) {
                    CustomerName =  CustomerName.substring(0,30);
                }
            } else { CustomerName = ''; }
            
            if(recSJob.Category1__c!= null ){
                ComplaintCode = css_utility.getCodes('Complaint Codes', recSJob.Category1__c, recSJob.Complaint_Type1__c, null); 
            } else { ComplaintCode = ''; }   
            system.debug('ComplaintCode'+ComplaintCode);
            
            String JobId= recSJob.WorkOrderNumber;
            String UserId;
            if(!Test.isRunningTest()) {
                UserId=  css_utility.getFederationId(UserInfo.getUserId()).toUpperCase();  //'OD324'; // User Id sould be in Upper case
            }
            
            HttpRequest req = new HttpRequest();
            
            //req.setEndpoint(CSS_getConnnectionDetails.getConnection('RSWClaim').End_Point__c);
            req.setEndpoint(conDetails.End_Point__c);
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer '+accessToken);
            req.setHeader('client-id', conDetails.Username__c); //Added as part of Mule Integration
            req.setHeader('client-secret', conDetails.Passcode__c); //Added as part of Mule Integration
            cInfoRequest= '{"Header":{"Sender":{"MessageID": "unique message ID at SF","SenderID": "SF","ServiceName": "ServiceRequest"},"Target":{"TargetID":"RSW"}},';
            cInfoRequest= cInfoRequest + '"DataArea": { "ClaimInformation": { "ServiceProviderCode": "'+ServiceProviderCode+'", "DSID": "'+DSID+' ", "RONumber": "'+RONumber+'", "ESN": ';
            cInfoRequest= cInfoRequest + '"'+ESN+'", "FailurePoint": "'+ProductMileage+'", "FailureMeasure": "'+ProductMileageMeasure+'", "FailureDate": "'+FailureDate+'", ';
            cInfoRequest= cInfoRequest + '"WarrantyStartDate": "'+WarrantyStartDate+'", "Manufacturer": "'+Make+'", "Model": "'+Model+'", "Application": "'+Application+'", ';
            cInfoRequest= cInfoRequest + '"VIN": "'+VIN+'", "UnitNumber": "'+UnitNumber+'", "ServiceProviderContact": "'+ServiceProviderContact+'", "CustomerName": "'+CustomerName+'", ';
            cInfoRequest= cInfoRequest + '"ComplaintCode": "'+ComplaintCode+'", "JobId": "'+JobId+'", "UserId": "'+UserId + '"';
            
            //  1.0 STARTS
            //Fetching record from Feature Switch Matrix
            List<FSL_Switch__c> lstFeatureMatrix_RSW = [SELECT Id, Name, IsActive__c FROM FSL_Switch__c 
                                                        WHERE (Name = 'Enable_FTR_Switch' OR Name = 'Enable_RSWIntegrationforFTR') 
                                                        AND IsActive__c = true ];
            Set<String> set_FeatureMatrix = new Set<String>();
            for(FSL_Switch__c fsm : lstFeatureMatrix_RSW) {
                set_FeatureMatrix.add(fsm.name);
            }
            if(recSJob.Service_Order_Extension__r.size() > 0 && 
               recSJob.Service_Order_Extension__r[0].FSL_ABRFlag__c == true
               && set_FeatureMatrix.contains('Enable_FTR_Switch')
               && set_FeatureMatrix.contains('Enable_RSWIntegrationforFTR') ) {
                   cInfoRequest= cInfoRequest + ', "EventType": "FTR" ';
               }
            else {
                cInfoRequest= cInfoRequest + ', "EventType": "DBR" ';
            }
            //  1.0 ENDS
            
            cInfoRequest= cInfoRequest + '} } }';
            System.debug('The Claim Request is***'+ cInfoRequest );
            req.setBody(cInfoRequest);
            req.setMethod('POST');
            Http http = new Http();
            HTTPResponse res;
            if(!Test.isRunningTest()) {
                res = http.send(req);
                jSONResponseBody = res.getBody();
            }
            if(jSONResponseBody.contains('ERROR')){
                System.debug('Incorrect json format');
                System.debug('BODY: '+res.getBody());
                System.debug('STATUS:'+res.getStatus());
                System.debug('STATUS_CODE:'+res.getStatusCode());
                css_utility.LogOutIntError(cInfoRequest, 'CSS Error:' + 'External Service Error',jSONResponseBody,'RSWClaimInfo');
            } else if(jSONResponseBody.contains('DEVELOPMENT MESSAGE')) {
                css_utility.LogOutIntError(cInfoRequest, 'CSS Error:' + 'External Token Error',jSONResponseBody,'RSWClaimInfo');
            } else {
                // Success
                System.debug('BODY: '+res.getBody());
                System.debug('STATUS:'+res.getStatus());
                System.debug('STATUS_CODE:'+res.getStatusCode());
            }
        }
        catch(exception e){
            system.debug(e.getMessage()+'***'+e.getLineNumber());
            css_utility.LogOutIntError(cInfoRequest, 'CSS Error:' + e.getMessage(),jSONResponseBody,'RSWClaimInfo');
        }
    }
    // Rajesh M 
    public static CG_OP_OAGWrapper getAccessToken(String serviceName){ 
        string accessToken;
        string endPoint;
        Datetime startDt;
        Datetime endDt;
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        try{
          
            
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            string client_id;
            string client_secret;
            string key;
            if(!Test.isRunningTest()){
                CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                conDetails = CSS_getConnnectionDetails.getConnection(serviceName);
                system.debug('serviceName ' + serviceName);
                system.debug('conDetails ' + conDetails);                
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c;
                //MuleSoft Migration: Needs to take the key from the respective Service
                key = conDetails.Key__c ;
                
            }
            else{
                endPoint = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
                client_id = 'ad724392-5594-4e85-b9eb-b0fc19c2fabe';
                client_secret = 'ocj8yiMYSDH39gPJpEZTNQo9cCXdgOW5olQ2s1Y3siA=';
                key = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-sp';
            }
            
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setBody('{"client_id":"'+client_id+'","client_secret":"'+client_secret+'","resource":"'+key+'"}');
            system.debug('req>>>>>>>.>>>'+req.getBody());
            HttpResponse res = new HttpResponse();
            startDt = System.now();
            endDt = System.now();
            if(!Test.isRunningTest()){
                res = http.send(req);
            }else{
                res.setBody('{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600","expires_on":"1561063243","not_before":"1561059343","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1kZXZuZi1hdy1leC5jdW1taW5zLmNvbS9jbWktc3AiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9iMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QvIiwiaWF0IjoxNTYxMDU5MzQzLCJuYmYiOjE1NjEwNTkzNDMsImV4cCI6MTU2MTA2MzI0MywiYWlvIjoiNDJaZ1lIamxzbWozejROTnpnWXQ2aTcrVVp2aUFRPT0iLCJhcHBpZCI6ImFkNzI0MzkyLTU1OTQtNGU4NS1iOWViLWIwZmMxOWMyZmFiZSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2IzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZC8iLCJvaWQiOiJiYmJmMzU0Mi1iZjY1LTRiMzktYWIzOC0zMDAzNjZjZmJiMGQiLCJzdWIiOiJiYmJmMzU0Mi1iZjY1LTRiMzktYWIzOC0zMDAzNjZjZmJiMGQiLCJ0aWQiOiJiMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QiLCJ1dGkiOiJ5aXlZYkdoUzNVcVRWWjVtQzhOZUFBIiwidmVyIjoiMS4wIn0.PrbkWrRFJSojdTqZ5yP-JeanRHQgOrTUuEf5KNQCT0ejR52VJqGpZp4KpGwo4cBMjiPMSVZlizTANROSaghwpx29iNNWgEDrVRE8VM7_eeBolRYuub6fkk0Ie9VmuqWVomlsDFuk24IQT1q_dxdXZBRGPaSZGRq-xcxGblmdg6zGF_NrUYfGPzDdJk6ccFrcYOWSKJHBzYa12dQFiZ_oaf50EK6WG_FB13tcCVQnhqBqU0vYpOzsKobF96v-2CH1bM1GVMCAq_kez00Drvt2qdJCMCEctrt_7lu8qkBQ1OXHBSj9sSy0EnptN7DQ3L6HSxTrRZuoQftTwMsSMzfR8g"}');
                res.setStatusCode(200);
            }
            System.debug('Response123' +res.getBody());
            string jSONRequestBody = res.getBody();
            // CG_WPR_MuleTokenResJSON wprObj = (CG_WPR_MuleTokenResJSON)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
            //Modified as part of observation.-Gopal
            CG_WPR_MuleTokenResJSON wprObj = (CG_WPR_MuleTokenResJSON)JSON.deserializeStrict(jSONRequestBody,CG_WPR_MuleTokenResJSON.class); 
            accessToken = wprObj.access_token;
            returnWrapper.accessToken = accessToken;
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalAuthCallTime = totalTime;
            
        }
        catch(exception e){
            system.debug('Entered into catch of Mule token Method in CG_WS_Mule>>>'+e.getMessage() +e.getLineNumber());
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = 'Some error in getting OAG : '+e.getMessage();
            returnWrapper.appName = 'MuleToken';
            returnWrapper.endPoint = endPoint;
            
        }
        return returnWrapper;        
    }
    
    public static void sendSerOrdInfoToRSW(EVL_RSW_ReqWrapper reqJSON){
        
        string jSONResponseBody = '';
        string cInfoRequest ='';
        //started by Naga Anusha Malepati 8/8/22 ,NIN-470, regarding Class variables doesn't have public accessibility
        //string wIdNumber = reqJSON.DataArea.id;
        string wIdNumber = reqJSON.getDataArea().id;
        //Ended by Naga Anusha Malepati 8/8/22 ,NIN-470, regarding Class variables doesn't have public accessibility
        String jsonResponse = '';
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper = null;
        
        try{
            //Added By Gnyana 
            reqWrapper= new FSL_IP_NamedCredentialWrapper();
            reqWrapper.methodType = 'POST';
            reqWrapper.NamedCredential = 'FSL_NC_Workorders';
            reqWrapper.Path = '/workorder';
            reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
            reqWrapper.WorkOrder= wIdNumber;

            string JSONReq =  JSON.serialize(reqJSON);
            reqWrapper.jsonReqBody=JSONReq;
            returnWrapper =  FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
            System.debug('--------this is request'+JSONReq);
            
            //Setting Reponse to a string
            jsonResponse = returnWrapper.response.getbody();
            //Added below code as part of Mule Integration
            /** CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c ();
conDetails = CSS_getConnnectionDetails.getConnection('EVL_RSWDiagData');

CG_OP_OAGWrapper accessTokenOPWrap = getAccessToken('EVL_RSWToken');
string accesstoken = accessTokenOPWrap.accessToken;

string JSONReq =  JSON.serialize(reqJSON);  

System.debug('--------this is request'+JSONReq);

HttpRequest req = new HttpRequest();

//req.setEndpoint(CSS_getConnnectionDetails.getConnection('RSWClaim').End_Point__c);
req.setEndpoint(conDetails?.End_Point__c);
req.setHeader('Content-Type','application/json');
req.setHeader('Authorization', 'Bearer '+accessToken);
req.setHeader('client-id', conDetails.Username__c); //Added as part of Mule Integration
req.setHeader('client-secret', conDetails.Passcode__c); //Added as part of Mule Integration

req.setBody(JSONReq);

req.setMethod('POST');

Http http = new Http();
HTTPResponse res;
if(!Test.isRunningTest()) {
res = http.send(req);
jSONResponseBody = res.getBody();
}**/
            if(jSONResponseBody.contains('ERROR')){
                System.debug('Incorrect json format');
                System.debug('BODY: '+returnWrapper.response.getBody());
                System.debug('STATUS:'+returnWrapper.response.getStatus());
                System.debug('STATUS_CODE:'+returnWrapper.response.getStatusCode());
                css_utility.LogOutIntError(JSONReq, 'CSS Error:' + 'External Service Error',jSONResponseBody,'RSWClaimInfo');
            } else if(jSONResponseBody.contains('DEVELOPMENT MESSAGE')) {
                css_utility.LogOutIntError(JSONReq, 'CSS Error:' + 'External Token Error',jSONResponseBody,'RSWClaimInfo');
            } else {
                // Success
                System.debug('BODY: '+returnWrapper.response.getBody());
                System.debug('STATUS:'+returnWrapper.response.getStatus());
                System.debug('STATUS_CODE:'+returnWrapper.response.getStatusCode());
            }
        }
        catch(exception e){
            system.debug(e.getMessage()+'***'+e.getLineNumber());
            css_utility.LogOutIntError(cInfoRequest, 'CSS Error:' + e.getMessage(),jSONResponseBody,'RSWClaimInfo');
        }
    }
}