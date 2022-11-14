global class CSS_RSWClaimInfo  {
        /*static string receiveToken(){
        system.debug('hit test');
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        string endPoint;
        string client_id;
        string client_secret;
        if(!Test.isRunningTest()){
            CSS_Integration_Details__c recIntDetails = new CSS_Integration_Details__c();
            recIntDetails = CSS_getConnnectionDetails.getConnection('OAGOAuth');
            endPoint = recIntDetails.End_Point__c;
            client_id = recIntDetails.Username__c;   
            client_secret = recIntDetails.Passcode__c;
        }
        else{
            endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
            client_id = 'd65101fd-601d-410a-9b12-8a72a6d98fae';
            client_secret = '7b398614-6612-4d52-9687-04fa654083bd';
        }
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
       
        HttpResponse res = http.send(req);
        
        string jSONRequestBody = res.getBody();
        CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
        string accessToken = wo1.access_token;
        System.debug('BODY: '+res.getBody());  
        System.debug('Status: '+res.getStatus());
        System.debug('Status Code: '+res.getStatusCode());
        return accessToken;
    }*/

   webservice static void sendClaimInfoToRSW(CSS_Job_Order__c recSJob){
       /* Commented by Gyan to reduce the number of Queries during Call from VF page.
       CSS_Job_Order__c recSJob=[select id,name, Creator_Location__c, DSID__c, ESN__c, Failure_Point__c, Failure_Point_Measure__c, Failure_Date__c,Shop_Work_Order__c,
                                 Warranty_Start_Date__c,Make__c,Model__c,Application__c,VIN__c, Unit_Number__c, Customer_Name__c, Category__c, Complaint_Type__c
                                 from CSS_Job_Order__c where id =:recSJobId];
        */
       string jSONResponseBody = '';
       string cInfoRequest ='';
        try{
            
            //Added below code as part of Mule Integration
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c ();
            conDetails = CSS_getConnnectionDetails.getConnection('RSWClaim');
            //string accessToken=receiveToken(); //Commented for dynamic Authentication and added below lines
                    //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('RSWClaim').AuthEnv__c);Commented as part of Mule Integration
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('RSWClaim').AuthEnv__c,'RSWClaim');
            string accesstoken = accessTokenOPWrap.accessToken;
            
            System.debug('The cInfoRequest is***'+accessToken);
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
            
            system.debug('recSJob.Creator_Location__c'+recSJob.Creator_Location__c);
            if(recSJob.Creator_Location__c != null){
            ServiceProviderCode = recSJob.Creator_Location__c.substring(recSJob.Creator_Location__c.indexOf('-')+1); 
            }else{ ServiceProviderCode = ''; }
            
            system.debug('ServiceProviderCode'+ServiceProviderCode);
            if(recSJob.DSID__c != null ) {
                DSID = recSJob.DSID__c; } else { DSID = '';}
            
            if(recSJob.Shop_Work_Order__c != null )
            { RONumber = recSJob.Shop_Work_Order__c; } else { RONumber='';}
            
            if(recSJob.ESN__c != null ){
                ESN = recSJob.ESN__c; } else { ESN = ''; }
            
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
            
            /*if(recSJob.Failure_Point_Measure__c=='Miles'){
                FailureMeasure = 'MI';
            } else if(recSJob.Failure_Point_Measure__c=='Kilometers'){
                FailureMeasure = 'KM';
            } else {
                FailureMeasure = 'HR';
            }*/
                
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
            if(recSJob.Model__c != null || recSJob.Model__c != '') {
                Model= recSJob.Model__c; } else { Model= ''; }

            //String Application= recSJob.Application__c;
            if(recSJob.Application_Desc__c != null ) {
                Application = css_utility.getCodes('Application Code', recSJob.Application_Desc__c, null, null); 
            } else { Application = ''; }
            
            system.debug('recSJob.VIN__c'+recSJob.VIN__c);
            if(recSJob.VIN__c != null ){
                VIN = recSJob.VIN__c; } else { 
                    system.debug('VIN'+VIN);
                    VIN = ''; }
            
            if(recSJob.Unit_Number__c != null ){
                UnitNumber = recSJob.Unit_Number__c; } else {UnitNumber = '';}
            
            ServiceProviderContact = userinfo.getName(); 
            system.debug('ServiceProviderContact'+ServiceProviderContact);
            
            if(recSJob.Customer_Name__c != null ) {
                CustomerName = recSJob.Customer_Name__c; } else { CustomerName = ''; }

            if(recSJob.Category_Desc__c!= null ){
            ComplaintCode = css_utility.getCodes('Complaint Codes', recSJob.Category_Desc__c, recSJob.Complaint_Type_Desc__c, null); 
            } else { ComplaintCode = ''; }   
            system.debug('ComplaintCode'+ComplaintCode);
            
            String JobId= recSJob.name;
           
            String UserId=  css_utility.getFederationId(UserInfo.getUserId()).toUpperCase();  //'OD324'; // User Id sould be in Upper case
            system.debug('UserId'+UserId);
            
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
            cInfoRequest= cInfoRequest + '"ComplaintCode": "'+ComplaintCode+'", "JobId": "'+JobId+'", "UserId": "'+UserId+'" } } }';

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
}