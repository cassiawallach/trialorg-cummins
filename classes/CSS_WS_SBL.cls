/**********************************************************************
Name: CSS_WS_SBL
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Class contains methods to consume webservices
from BMS

======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR            DATE          DETAIL                                 
1.0     Rajkumar            04/10/2016    INITIAL DEVELOPMENT  
1.1     Prabhakar           05/10/2016    getEngineData    
1.2     Ekta                05/10/2016    getDetailCoverage
1.3     Rajesh Pasupuleti   18/10/2016    Added Try and catch blocks 
1.4     Rupesh Pande20/02/2018  Added a new function getClaimsBasicCoverage for claims warranty Search
***********************************************************************/
public class CSS_WS_SBL 
{
    
    
    
  
    public static CSS_getTechInfoResponseJ2A getTechInfo(CSS_getTechInfoReqJ2A getTechInfoReq)
    {
        //CSS_getTechInfoReqJ2A getTechInfoReq = new CSS_getTechInfoReqJ2A();
        CSS_getTechInfoResponseJ2A techInfo;
        string endPointURL;
        string message;
        //string SPCode;
        string QualProgId;
        string QualProgId1;
        HttpResponse res;
        try 
        {
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            //getting Access Token
            //String access_token = CSS_SRT.receiveToken(); //Commented and added below lines for Dynamic Authentication
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_TECHINFO');
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(conDetails.AuthEnv__c);
            String access_token = accessTokenOPWrap.accesstoken;
            system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token); 

            if(!Test.isRunningTest()){
                endPointURL =  CSS_getConnnectionDetails.getConnection('CSS_SBL_TECHINFO').End_Point__c; 
            }else{
                endPointURL = 'https://services-dev.cummins.com/csswarranty/technicianinfo/';
            }
            system.debug('endPointURL--->'+endPointURL);
            req1.setHeader('Authorization','Bearer '+access_token);
            //Building Request 
            req1.setHeader('Content-Type','application/json');
            req1.setMethod('POST');
            req1.setEndpoint(endPointURL);
            //string JSONReq = '{"Header": {"Sender": {"ServiceName": "GetTechInfo","SenderID": "CSS"},"Target": {"TargetID": "SIEBEL"}},"DataArea": {"SPCode": "'+getTechInfoReq.DataArea.SPCode+'","QualProgIDs": [{"QualProgId" : "'+getTechInfoReq.DataArea.QualProgIDs+'"}]}}'; 
            String JSONReq = JSON.serialize(getTechInfoReq);
            req1.setBody(JSONReq);
            
            System.debug('req1.getBody======'+req1.getBody());
            //Sending request  
            //res = h1.send(req1);
            //System.debug('Status Code >>> :: '+res.getStatusCode());
            //System.debug('REST response is :: '+res);
            //Setting response to the string
            //string jsonResponseBody = res.getBody();
            //mocking response for testing
            string jsonResponseBody = '{"DataArea": {"GetTechnicianInfoOutput": [{"SPCode": "13436","Region": "IN","Territory": "IN","ProductCertification": "Y","WarrantyTrainingCertification": "Y","PromotionIDFlag": "Y","TechDetails": [{"PassedDate": "2015-04-11T00:00:00.000-04:00","PromotionId": "1028676","UserLoginId": "od325","FirstName": "Blake","LastName": "Eaton","QualProgID": "842"}]}]},"Header": {"Status": "Success"} }';
            //de-serializing the response and mapping it to wrapper class
             techInfo= (CSS_getTechInfoResponseJ2A )JSON.deserialize(jsonResponseBody,CSS_getTechInfoResponseJ2A.class);

            //basicCoverageDetails= (CSS_getBasicCoverageResponseJ2A)JSON.deserialize(jsonResponseBody,CSS_getBasicCoverageResponseJ2A.class);
            
        }
          catch(Exception ex){
                  System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
              if(!Test.isRunningTest()){
                 message = ex.getMessage();
             
             if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL techInfo', 'RESPONSE IS NULL', 'SBL');
                }
                else{
              //      css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL techInfo', res.getBody(), 'SBL');
                }
            }

        }
              return techInfo;
    }
       
      
    //Start Method to get basic Coverage...This function is to be used in warranty coverage Search Functionality/
    public static CSS_getBasicCoverageResponseJ2A getBasicCoverage(CSS_getBasicCoverageReqJ2A getBasicCoverageReq)
    {
        System.debug('in getBasicCoverage of CSS_WS_SBL....');
        CSS_getBasicCoverageResponseJ2A basicCoverageDetails;
        string endPointURL;
         HttpResponse res = new HttpResponse();
        string message;
        try{
            
            string ESN;
            string Region;
            string Territory;
            string WarrantyStartDate;
            string EngineApplicationCode;
            string Jobd;
            string FailurePoint;//#85179
            string FailureUnit;//#85179
            //getBasicCoverageReq.DataArea.ESN='79384192';
            string reconFlag;
                                            
            ESN = getBasicCoverageReq.DataArea.ESN;
            Region = getBasicCoverageReq.DataArea.Region;   
            Territory = getBasicCoverageReq.DataArea.Territory;   
            WarrantyStartDate = getBasicCoverageReq.DataArea.WarrantyStartDate;   
            EngineApplicationCode = getBasicCoverageReq.DataArea.EngineApplicationCode;
            Jobd = getBasicCoverageReq.DataArea.JobId;   
            FailurePoint = getBasicCoverageReq.DataArea.FailurePoint; //#85179
            FailureUnit = getBasicCoverageReq.DataArea.FailureUnit; //#85179
            reconFlag = getBasicCoverageReq.DataArea.ReconFlag;
            
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            //HttpResponse res;
            //getting Access Token
            //String access_token = CSS_SRT.receiveToken(); //Commented for Dynamic Authentication
           // CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER').AuthEnv__c);
           CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER').AuthEnv__c,'CSS_SBL_BCOVER');//Added By Prabhakar OAG to Mule 19/05/2020
   
            String access_token = accessTokenOPWrap.accesstoken;
            system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token); 
            
            if(!Test.isRunningTest()){
                endPointURL =  CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER').End_Point__c; 
            }else{
                endPointURL = 'https://services-dev.cummins.com/csswarranty/';
            }

            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER');
            
            system.debug('endPoinbasiccoveragetURL--->'+endPointURL);
            req1.setHeader('Authorization','Bearer '+access_token);
            //Building Request 
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('client-id',conDetails.Username__c);
            req1.setHeader('client-secret',conDetails.Passcode__c);
            req1.setMethod('POST');
            
            req1.setEndpoint(endPointURL);
            //string JSONReq = '{"Header": {"Sender": {"ServiceName": "GetBasicCoverage","SenderID": "CSS"},"Target": { "TargetID": "SIEBEL" }},"DataArea": {"ESN": "'+ESN+'","EngineApplicationCode": "'+EngineApplicationCode+'","Region": "'+Region+'","Territory": "'+Territory+'","WarrantyStartDate": "'+WarrantyStartDate+'","PartsWarranty": "Y"}}';             
            System.debug('getBasicCoverage EngineApplicationCode>>>:'+EngineApplicationCode);
            string JSONReq = '{"Header": {"Sender": {"ServiceName": "GetBasicCoverage","SenderID": "CSS"},"Target": { "TargetID": "SIEBEL" }},"DataArea": {"ESN": "'+ESN+'","EngineApplicationCode": "'+EngineApplicationCode+'","Region": "'+Region+'","Territory": "'+Territory+'","WarrantyStartDate": "'+WarrantyStartDate+'","PartsWarranty": "Y", "FailurePoint":"'+FailurePoint+'", "FailureUnit":"'+FailureUnit+'", "ReconFlag":"'+reconFlag+'"}}';  //#85179           
            req1.setBody(JSONReq);
            System.debug('getBasicCoverage req1.getBody======'+req1.getBody());
            //Sending request 
             res = h1.send(req1);
            System.debug('getBasicCoverage res****'+res);
            //Setting response to the string
           // string jsonResponseBody = res.getBody();
            if(res.getStatusCode() == 200){
            string jsonResponseBody = res.getBody();
            system.debug('getBasicCoverage Response jsonrespbasiccov>>>>:'+jsonResponseBody);
           if(jobd != null && jobd != ''){            
                CSS_Job_Order__c srvjob = new CSS_Job_Order__c();
                srvjob.id = jobd;
                if(jsonResponseBody != null && jsonResponseBody != ''){
                   srvjob.CoverageResponse__c = jsonResponseBody;
                   srvjob.Territory__c = Territory;
                   srvjob.Region__c = Region;  
                        
                }
                    
                else{
                    srvjob.CoverageResponse__c ='';
                    srvjob.EditCoverage__c = '';
                    srvjob.Territory__c = Territory;
                    srvjob.Region__c = Region;
                     }
               update srvjob;
            } 
            //de-serializing the response and mapping it to wrapper class
            basicCoverageDetails= (CSS_getBasicCoverageResponseJ2A)JSON.deserialize(jsonResponseBody,CSS_getBasicCoverageResponseJ2A.class);
            System.debug('Status Code >>> :: '+res.getStatusCode());
            System.debug('REST response is :: '+res);
            system.debug('Response Body >>>'+res.getbody());
            system.debug('WarpperResponse'+basicCoverageDetails);
        }
            
            else{
                
                css_utility.LogOutIntError(endPointURL,res.toString()+'-SBL get basic Coverage', res.getStatus()+string.valueOf(res.getStatuscode()), 'SBL');
                }
        }
        catch(Exception ex){
                  System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getMessage*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                 message = ex.getMessage();
             
             if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get basic Coverage', 'RESPONSE IS NULL', 'SBL');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get basic Coverage', res.getBody(), 'SBL');
                }
            }
        }
       
        return basicCoverageDetails;
        
    }
    
    //END Method to get basic Coverage...This function is to be used in warranty coverage Search Functionality/
    
    
    
    //Start Method to get basic Coverage...This function is to be used in claims warranty coverage Search Functionality/
    public static CSS_getBasicCoverageResponseJ2A getClaimsBasicCoverage(CSS_getBasicCoverageReqJ2A getBasicCoverageReq,Boolean coverage)
    {
        System.debug('in getClaimsBasicCoverage of CSS_WS_SBL....');
         System.debug('in getClaimsBasicCoverage of CSS_WS_SBL....'+coverage);
        CSS_getBasicCoverageResponseJ2A basicCoverageDetails;
        string endPointURL;
        HttpResponse res = new HttpResponse();
        string message;
        try{
            
            string ESN;
            string Region;
            string Territory;
            string WarrantyStartDate;
            string EngineApplicationCode;
            string psnid;
            
            string FailurePoint;//#85179
            string FailureUnit;//#85179
            //getBasicCoverageReq.DataArea.ESN='79384192';
            string reconFlag;
                                            
            ESN = getBasicCoverageReq.DataArea.ESN;
            Region = getBasicCoverageReq.DataArea.Region;   
            Territory = getBasicCoverageReq.DataArea.Territory;   
            WarrantyStartDate = getBasicCoverageReq.DataArea.WarrantyStartDate;   
            EngineApplicationCode = getBasicCoverageReq.DataArea.EngineApplicationCode;
            psnid = getBasicCoverageReq.DataArea.JobId; /*************************/  
            FailurePoint = getBasicCoverageReq.DataArea.FailurePoint; //#85179
            FailureUnit = getBasicCoverageReq.DataArea.FailureUnit; //#85179
            reconFlag = getBasicCoverageReq.DataArea.ReconFlag;
            
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            //HttpResponse res;
            //getting Access Token
             //String access_token = CSS_SRT.receiveToken(); //Commented for Dynamic Authentication
           // CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER').AuthEnv__c);
           CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER').AuthEnv__c,'CSS_SBL_BCOVER');//Added By Prabhakar OAG to Mule 19/05/2020
   
            String access_token = accessTokenOPWrap.accesstoken;
            system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token); 
            
            if(!Test.isRunningTest()){
                endPointURL =  CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER').End_Point__c; 
            }else{
                endPointURL = 'https://services-dev.cummins.com/csswarranty/';
            }
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();//Added for mule
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER');//Added for mule
            
            system.debug('endPoinbasiccoveragetURL--->'+endPointURL);
            req1.setHeader('Authorization','Bearer '+access_token);
            //Building Request 
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('client-id',conDetails.Username__c);//Added for mule
            req1.setHeader('client-secret',conDetails.Passcode__c);//Added for mule
            req1.setMethod('POST');
            req1.setEndpoint(endPointURL);
            //string JSONReq = '{"Header": {"Sender": {"ServiceName": "GetBasicCoverage","SenderID": "CSS"},"Target": { "TargetID": "SIEBEL" }},"DataArea": {"ESN": "'+ESN+'","EngineApplicationCode": "'+EngineApplicationCode+'","Region": "'+Region+'","Territory": "'+Territory+'","WarrantyStartDate": "'+WarrantyStartDate+'","PartsWarranty": "Y"}}';             
            System.debug('getClaimsBasicCoverage EngineApplicationCode>>>:'+EngineApplicationCode);
            string JSONReq = '{"Header": {"Sender": {"ServiceName": "GetBasicCoverage","SenderID": "CSS"},"Target": { "TargetID": "SIEBEL" }},"DataArea": {"ESN": "'+ESN+'","EngineApplicationCode": "'+EngineApplicationCode+'","Region": "'+Region+'","Territory": "'+Territory+'","WarrantyStartDate": "'+WarrantyStartDate+'","PartsWarranty": "Y", "FailurePoint":"'+FailurePoint+'", "FailureUnit":"'+FailureUnit+'", "ReconFlag":"'+reconFlag+'"}}';  //#85179           
            req1.setBody(JSONReq);
            System.debug('getClaimsBasicCoverage req1.getBody======'+req1.getBody());
            //Sending request 
             res = h1.send(req1);
            
            System.debug('getClaimsBasicCoverage res****'+res);
            //Setting response to the string
           // string jsonResponseBody = res.getBody();
            if(res.getStatusCode() == 200){
            string jsonResponseBody = res.getBody();
            system.debug('getClaimsBasicCoverage Response jsonrespbasiccov>>>>>:'+jsonResponseBody);/*************************/
           
           //Below logic should be changed as query on CSS_Claims with claimId & update Claim instead of querying CSS_PSN__C
           if(psnid != null && psnid != '')
           {            
           list<CSS_PSN__C> psnlist=[select css_claims__c from CSS_PSN__C where id =: psnid];    
               css_claims__c clms=new css_claims__c();
        
                clms.id = psnlist[0].css_claims__c;
                if(jsonResponseBody != null && jsonResponseBody != ''){
                   clms.CoverageResponse__c = jsonResponseBody;
                   clms.Territory__c = Territory;
                   clms.Region__c = Region;  
                        
                }
                    
                else{
                    clms.CoverageResponse__c ='';
                    clms.Territory__c = Territory;
                    clms.Region__c = Region;
                     }
                if(coverage==true)
               update clms;
            } 
            //de-serializing the response and mapping it to wrapper class
            basicCoverageDetails= (CSS_getBasicCoverageResponseJ2A)JSON.deserialize(jsonResponseBody,CSS_getBasicCoverageResponseJ2A.class);
            System.debug('Status Code >>> :: '+res.getStatusCode());
            System.debug('REST response is :: '+res);
            system.debug('Response Body >>>'+res.getbody());
            system.debug('WarpperResponse'+basicCoverageDetails);
        }
            
            else{
                
                css_utility.LogOutIntError(endPointURL,res.toString()+'-SBL get basic Coverage', res.getStatus()+string.valueOf(res.getStatuscode()), 'SBL');
                }
        }
        catch(Exception ex){
                  System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getMessage*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                 message = ex.getMessage();
             
             if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get basic Coverage', 'RESPONSE IS NULL', 'SBL');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get basic Coverage', res.getBody(), 'SBL');
                }
            }
        }
       
        return basicCoverageDetails;
        
    }
    
    //END Method to get basic Coverage...This function is to be used in Claims warranty coverage Search Functionality/
    
     
    
    
     //Method to get EngineData of SIEBEL
     public static  CSS_getEngineDataResponseJ2A  getEngineData( CSS_getEngineDataReqJ2A getEngineDataReq){
        CSS_getEngineDataResponseJ2A  engineData;
        string endPointURL;
        HttpResponse res1;
        string ESN;
        string message;
        try{
            system.debug('SBL$$$$$$$$@@@@@@@@@@:::'+getEngineDataReq);
            String access_token;
            //system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token); 
            
            if(!Test.isRunningTest()){
                 //String access_token = CSS_SRT.receiveToken(); //Commented for Dynamic Authentication
           // CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_ENGDATA').AuthEnv__c);
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_ENGDATA').AuthEnv__c,'CSS_SBL_ENGDATA');
            ESN = getEngineDataReq.DataArea.ESN;
            access_token = accessTokenOPWrap.accesstoken;
                //endPointURL =  CSS_getConnnectionDetails.getConnection('CSS_SBL_ENGDATA').End_Point__c; 
            }else{
                access_token ='Test';
                endPointURL = 'https://services-dev.cummins.com/csswarranty/getEngineData';
            }
            if(access_token==null || access_token.trim() ==''){
                return null;
            }
            
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            //endPointURL = endPointURL+'/cmi-engine/engines?esn='+ESN;
            system.debug('endPointURL><><'+endPointURL);
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_ENGDATA');
            
            endPointURL = conDetails.End_Point__c+'/cmi-engine/engines?sender=CSS&target=CSSWarranty&esn='+ESN;//79488917;
            
            req1.setHeader('client-id',conDetails.Username__c);
            req1.setHeader('client-secret',conDetails.Passcode__c);
            
            //
    
            req1.setHeader('Authorization','Bearer '+access_token);
            req1.setHeader('Content-Type','application/json');
            req1.setMethod(conDetails.Method_Type__c);
            req1.setEndpoint(endPointURL);
            
           // ESN = getEngineDataReq.DataArea.ESN;
            
            //string reqWrpperInput = JSON.serialize(getEngineDataReq);
            //req1.setBody(reqWrpperInput); 
            string JSONReq = '{"Header": {"Sender": {"ServiceName": "GetEngineData","SenderID": "CSS"},"Target": { "TargetID": "SIEBEL" }},"DataArea": {"Esn": '+ESN+'}}';             
                         
           // req1.setBody(JSONReq);        
                       
            System.debug('req1.getBody======'+req1.getBody());
            //Sending request and mapping the response 
            String jsonResponseBody;
            System.debug('****before****req1***'+req1);
            System.debug('**inside isRunningTest****');
            if(!Test.isRunningTest()){
                System.debug('**inside isRunningTest****');
            res1 = h1.send(req1);
            System.debug('****After****res1***'+res1);
                System.debug('****After**getBody()**res1***'+res1.getBody());
            jsonResponseBody=res1.getBody();
                System.debug('***jsonResponseBody***'+jsonResponseBody);
            }
             else
             {
                 if(ESN == '12345678'){
                      jsonResponseBody ='{'+'"DataArea":{'+'"AutomotiveAppFlag":"",'+'"Model":"VNL SERIES",'+'"Esn":"79464646","'+'EtoConversionDate":"",'+'"EngineAppCode":"",'+'"MarineAppFlag":"",'+'"EngineBillToCode":"",'+'"EquipmentId":"EQ5437",'+'"CustomerName":"SOUTHEASTERN FRT",'+'"BuildDate":"2011-03-09T00:00:00.000-05:00",'+'"Manufacturer":"VOLVO",'+'"EngineFamilyCode":"10",'+'"WarrantyStartDate":"2013-10-14T00:00:00.000-04:00",'+'"ProdAppCode":"BB",'+'"ServiceModelName":"ISX15 CM2250",'+'"AccessCode":"B",'+'"ProdAppDesc":"AUTOMOTIVE",'+'"vin":"1234ZXASSDASASS121212",'+'"EngineAppDesc":""},'+'"Header":{"Status":"Failure"}'+'}'+'';
                      //jsonResponseBody = '{\r\n\t\"DataArea\": {\r\n\t\t\"EtoConversionDate\": \"\",\r\n\t\t\"EquipmentId\": \"EQ7503\",\r\n\t\t\"EngineAppCode\": \"130\",\r\n\t\t\"DesignPhaseCode\": \"21\",\r\n\t\t\"ETOOldPSN\": \"12345678\",\r\n\t\t\"ETOOldESN\": \"23231245\",\r\n\t\t\"Manufacturer\": \"AUTOCAR\",\r\n\t\t\"OEMSPCode\": \"01005\",\r\n\t\t\"CriticalPartsListNumber\": \"8257\",\r\n\t\t\"CustomerName\": \"testingTTMl\",\r\n\t\t\"ProdAppCode\": \"BB\",\r\n\t\t\"ServiceModelName\": \"ISX CM570\",\r\n\t\t\"EngineFamilyName\": \"ISXSIGNATURE(APEX)\",\r\n\t\t\"EquipmentConfiguration\": \"CAB OVER\",\r\n\t\t\"PACCARFlag\": \"\",\r\n\t\t\"Esn\": \"79462880\",\r\n\t\t\"EngineBillToCode\": \"01405\",\r\n\t\t\"MarineAppFlag\": \"N\",\r\n\t\t\"AccessCode\": \"B\",\r\n\t\t\"ShipDate\": \"2011-03-05 00:00:00.0\",\r\n\t\t\"AutomotiveAppFlag\": \"Y\",\r\n\t\t\"EngineFamilyCode\": \"10\",\r\n\t\t\"BuildDate\": \"2011-03-01T00:00:00.000-06:00\",\r\n\t\t\"EngineAppDesc\": \"AUTOMOTIVE\",\r\n\t\t\"NoWarranty\": \"N\",\r\n\t\t\"ProdAppDesc\": \"AUTOMOTIVE\",\r\n\t\t\"Model\": \"ACX\",\r\n\t\t\"VIN\": \"3HSDJAPT9CN565886\",\r\n\t\t\"WarrantyStartDate\": \"2018-10-01T00:00:00.000-05:00\"\r\n\t},\r\n\t\"Header\": {\r\n\t\t\"Status\": \"Success\"\r\n\t}\r\n}'+'';
                 System.debug('respone11======'+jsonResponseBody);
                 }else{
                    //jsonResponseBody='{"DataArea":{"EtoConversionDate": "","EquipmentId": "EQ7556","EngineAppCode": "130","DesignPhaseCode": "D3","ETOOldPSN": "","Manufacturer": "INTERNATIONAL","OEMSPCode": "08588","CriticalPartsListNumber": "4515","CustomerName": "STERLING LUMBER","ProdAppCode": "BB","ServiceModelName": "ISB6.7 CM2350 B101","EngineFamilyName": "6B 6.7","EquipmentConfiguration": "MED CONV",PACCARFlag": "N","ShipDate": "2015-02-18 00:00:00.0","AutomotiveAppFlag":"Y","Model":"ALL","Esn":"57788989","EtoConversionDate":"","VIN":"1NKDX4TX1EJ965298","EngineAppCode":"130","MarineAppFlag":"N","EngineBillToCode":"","EquipmentId":"EQ6632","CustomerName":"asdasda","BuildDate":"2013-01-15T00:00:00.000-05:00","Manufacturer":"UNLISTED","EngineFamilyCode":"10","WarrantyStartDate":"2013-01-15T00:00:00.000-05:00","ProdAppCode":"BX","ServiceModelName":"ISX15 CM2350 X101","AccessCode":"C","ProdAppDesc":"AUTOMOTIVE","EngineAppDesc":"AUTOMOTIVE"},"Header":{"Status":"Success"}}';
                 jsonResponseBody ='{'+'"DataArea":{'+'"AutomotiveAppFlag":"",'+'"Model":"VNL SERIES",'+'"Esn":"79464646","'+'EtoConversionDate":"",'+'"EngineAppCode":"",'+'"MarineAppFlag":"",'+'"EngineBillToCode":"",'+'"EquipmentId":"EQ5437",'+'"CustomerName":"SOUTHEASTERN FRT",'+'"BuildDate":"2011-03-09T00:00:00.000-05:00",'+'"Manufacturer":"VOLVO",'+'"EngineFamilyCode":"10",'+'"WarrantyStartDate":"2013-10-14T00:00:00.000-04:00",'+'"ProdAppCode":"BB",'+'"ServiceModelName":"ISX15 CM2250",'+'"AccessCode":"B",'+'"ProdAppDesc":"AUTOMOTIVE",'+'"vin":"1234ZXASSDASASS121212",'+'"EngineAppDesc":""},'+'"Header":{"Status":"Success"}'+'}'+'';
                 //jsonResponseBody = '{\r\n\t\"DataArea\": {\r\n\t\t\"EtoConversionDate\": \"\",\r\n\t\t\"EquipmentId\": \"EQ7503\",\r\n\t\t\"EngineAppCode\": \"130\",\r\n\t\t\"DesignPhaseCode\": \"21\",\r\n\t\t\"ETOOldPSN\": \"12345678\",\r\n\t\t\"ETOOldESN\": \"23231245\",\r\n\t\t\"Manufacturer\": \"AUTOCAR\",\r\n\t\t\"OEMSPCode\": \"01005\",\r\n\t\t\"CriticalPartsListNumber\": \"8257\",\r\n\t\t\"CustomerName\": \"testingTTMl\",\r\n\t\t\"ProdAppCode\": \"BB\",\r\n\t\t\"ServiceModelName\": \"ISX CM570\",\r\n\t\t\"EngineFamilyName\": \"ISXSIGNATURE(APEX)\",\r\n\t\t\"EquipmentConfiguration\": \"CAB OVER\",\r\n\t\t\"PACCARFlag\": \"\",\r\n\t\t\"Esn\": \"79462880\",\r\n\t\t\"EngineBillToCode\": \"01405\",\r\n\t\t\"MarineAppFlag\": \"N\",\r\n\t\t\"AccessCode\": \"B\",\r\n\t\t\"ShipDate\": \"2011-03-05 00:00:00.0\",\r\n\t\t\"AutomotiveAppFlag\": \"Y\",\r\n\t\t\"EngineFamilyCode\": \"10\",\r\n\t\t\"BuildDate\": \"2011-03-01T00:00:00.000-06:00\",\r\n\t\t\"EngineAppDesc\": \"AUTOMOTIVE\",\r\n\t\t\"NoWarranty\": \"N\",\r\n\t\t\"ProdAppDesc\": \"AUTOMOTIVE\",\r\n\t\t\"Model\": \"ACX\",\r\n\t\t\"VIN\": \"3HSDJAPT9CN565886\",\r\n\t\t\"WarrantyStartDate\": \"2018-10-01T00:00:00.000-05:00\"\r\n\t},\r\n\t\"Header\": {\r\n\t\t\"Status\": \"Success\"\r\n\t}\r\n}'+'';
                 System.debug('respone11======'+jsonResponseBody); 
                 }
                 
             }
            //de-serializing the response and mapping it to wrapper class
            engineData = (CSS_getEngineDataResponseJ2A)JSON.deserialize(jsonResponseBody,CSS_getEngineDataResponseJ2A.class);
            

                System.debug('Status Code >>> :: '+res1.getStatusCode());
            System.debug('REST response is :: '+res1);
            system.debug('Response Body >>>'+res1.getbody());
            system.debug('engineData >>>'+engineData);
         
        }catch(Exception ex){
            System.debug('in catch of getEngineData SIEBEL webservice>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            if(!Test.isRunningTest())
            {
                 message = ex.getMessage();
                 if(message.contains('timed out'))
                 {
                     // This is commented bcz Integration error shouldn't be inserted here bcz after completion of all webservices, perform DML
                        //css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get EngineData', 'RESPONSE IS NULL', 'SBL');
                 }
                 else{
                     // This is commented bcz Integration error shouldn't be inserted here bcz after completion of all webservices, perform DML
                        //css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get EngineData', res1==null?'RESPONSE IS NULL':res1.getBody(), 'SBL');
                 }
            }
        }
        return engineData;
     }
    
    
     //Method to DetailCoverage
     public static CSS_getDetailCoveResponseJ2A getDetailCoverage(CSS_getDetailCoverageReqJ2A getDetailCovReq){
        CSS_getDetailCoveResponseJ2A DetailCoverage;
        string endPointURL;
        HttpResponse res1;
        string message;
          try{

            system.debug('SBL$$$$$$$$@@@@@@@@@@:::'+getDetailCovReq);
            String access_token = CSS_SRT.receiveToken();
            system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token); 
            
            if(!Test.isRunningTest()){
                endPointURL =  CSS_getConnnectionDetails.getConnection('CSS_SBL_DCOVER').End_Point__c; 
            }else{
                endPointURL = 'https://services-dev.cummins.com/csswarranty/getDetailCoverage';
            }
        Http h1 = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setHeader('Authorization','Bearer '+access_token);
        req1.setHeader('Content-Type','application/json');
        req1.setMethod('POST');
        req1.setEndpoint(endPointURL);
        
        string reqWrpperInput = JSON.serialize(getDetailCovReq);
        req1.setBody(reqWrpperInput);              
        System.debug('req1.getBody======'+req1.getBody());
        //Sending request and mapping the response 
        res1 = h1.send(req1);
        String jsonResponseBody=res1.getBody();
        //de-serializing the response and mapping it to wrapper class
        DetailCoverage= (CSS_getDetailCoveResponseJ2A)JSON.deserialize(jsonResponseBody,CSS_getDetailCoveResponseJ2A.class);
        System.debug('Status Code >>> :: '+res1.getStatusCode());
        System.debug('REST response is :: '+res1);
        system.debug('Response Body >>>'+res1.getbody());
              }catch(Exception ex){
                  System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                 message = ex.getMessage();
             
             if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get DetailCoverage', 'RESPONSE IS NULL', 'SBL');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get DetailCoverage', res1.getBody(), 'SBL');
                }
            }
        }
        return DetailCoverage;
   }
    
   /**
     * This is used for Preparing Request JSON of SIEBEL webservices
     * 
     */
    public static CSS_WPR_SBL_ApplnCategoryListReqJSON prepareReqJSONForApplCategoryList(String senderID, String serviceName, String messageID, String currDate){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareReqJSONForApplCategoryList webservice of CSS_WS_SBL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_SBL_ApplnCategoryListReqJSON appliCatReqJSON = null;
        CSS_WPR_SBL_ApplnCategoryListReqJSON.Header headerObj = null;
        CSS_WPR_SBL_ApplnCategoryListReqJSON.Sender senderObj = null;
        try{
            //Prepare Request JSON
        appliCatReqJSON = new CSS_WPR_SBL_ApplnCategoryListReqJSON();
            headerObj = new CSS_WPR_SBL_ApplnCategoryListReqJSON.Header();
            senderObj = new CSS_WPR_SBL_ApplnCategoryListReqJSON.Sender();
            
            senderObj.SenderID = senderID;
            senderObj.ServiceName = serviceName;
            senderObj.MessageID = messageID;
            senderObj.CreationDateTime = currDate;
            
            headerObj.Sender =  senderObj;
            appliCatReqJSON.Header = headerObj;
            
        }catch(Exception ex){
            System.debug('in catch of prepareReqJSONForApplCategoryList of CSS_WS_SBL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{
            headerObj=null;senderObj=null;
        }
        return appliCatReqJSON;
    }
    
    public static String getAccessTokenOfOAGOAuth(){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getAccessTokenOfOAGOAuth webservice of CSS_WS_SRT $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        string accessToken;
        string endPoint;
        CSS_J2AToken_SRT tokenWC;
        try{
            HttpRequest req = new HttpRequest();
            string client_id;
            string client_secret;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            if(!Test.isRunningTest()){
                    conDetails = CSS_getConnnectionDetails.getConnection('OAGOAuth');
                    endPoint = conDetails.End_Point__c;
                    client_id = conDetails.Username__c;   
                    client_secret = ConDetails.Passcode__c;
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
            HttpResponse res = new HttpResponse();
            if(!Test.isRunningTest()){
                res = new Http().send(req);
            }else{
                res.setBody('{"access_token":"1qbB3Z5A6AWVmJe2kioYRnU4sGteyNOnn84Q15hiOijEy43Yx5BWMf","token_type":"Bearer","expires_in":1200,"refresh_token":"n3iboQhnqgCTm39vjbBcAcO9EMSRvgEUvvbLwl60QhFnga","scope":"CSSCloud"}');
                res.setStatusCode(200);
            }
            string jSONRequestBody = res.getBody();
            tokenWC = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
            accessToken = tokenWC.access_token;
            System.debug('BODY:'+res.getBody()+' Status:'+res.getStatus()+'Status Code:'+res.getStatusCode());  
        }catch(exception ex){
            System.debug('in catch of getAccessTokenOfOAGOAuth of CSS_WS_SBL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return accessToken;     
    }
 }