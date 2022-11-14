public class CSS_sendGSQParts{

   public static string getAccessTokenFromBMSOrg(){
        CSS_OAuth2 objAuthenticationInfo= new CSS_OAuth2();
        try{
            //OAuth defining
            String userName='pasupuletir@cummins.com.cssbmsint';
            String password='Pasupuleti@59';
            String securityToken='tMFzb2jK7L4E1rw6Pv4ppGKWR';
            String OAutAuthURL = 'https://cumminscss--CSSBMSINT.cs30.my.salesforce.com/services/oauth2/token';
            System.debug('going to execute$$$$$$$$$$$$$$$$$$$$$...');
            HttpRequest req = new HttpRequest();
            req.setEndpoint( OAutAuthURL );
            req.setMethod('POST');
            Map<String,String> postBody = new Map<String,String>();
            postBody.put('grant_type','password');
            postBody.put('client_id','3MVG9PerJEe9i8iKBxBU01.Gh4lfDED9G9GX11YUSuk8Tkfe78sUKJ.RheEZgmpzbYPXk2nVgFG7FaSujA0WZ');
            postBody.put('client_secret','5112909483908316652');
            postBody.put('redirect_uri','https://connectedsolutions.cummins.com');
            postBody.put('username',EncodingUtil.urlEncode(userName, 'UTF-8'));
            postBody.put('password',password+securityToken);
            String reqBody = 'grant_type=' + postBody.get('grant_type') + '&' + 'client_id=' + postBody.get('client_id') + '&' + 'client_secret=' + postBody.get('client_secret') + '&' + 'username=' + postBody.get('username') + '&' + 'password=' + postBody.get('password')+'&'+'redirect_uri='+postBody.get('redirect_uri');
            System.debug(reqBody);
            req.setBody(reqBody);
            Http http = new Http();
            System.debug('before execute$$$$$$$$$$$$$$$$$$$$$...');
            HttpResponse response = http.send(req);
            System.debug('response getStatusCode is :: '+response.getStatusCode());
            System.debug('after execution execute$$$$$$$$$$$$$$$$$$$$$...');
            System.debug('REST response is :: '+response);
            objAuthenticationInfo = (CSS_OAuth2)JSON.deserialize(response.getbody(), CSS_OAuth2.class);
            system.debug('accesstoken##########################:::'+objAuthenticationInfo.access_token);
        
        }catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
        }
        return objAuthenticationInfo.access_token;
    }
    
    //  Method to Call sendGSQParts 
   public static CSS_getPartsListBMSResponseJ2A sendGSQParts(CSS_getPartsListBMSRequestJ2A sendGSQPartsReq){
       CSS_getPartsListBMSResponseJ2A sendGSQPartsRes;
        String message;
        String endPointURL;
        HttpResponse res1;
        String access_token = getAccessTokenFromBMSOrg();
        system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);
        system.debug('SBL$$$$$$$$@@@@@@@@@@:::'+sendGSQPartsReq);
        try
        {
        Http h1 = new Http();
        HttpRequest req1 = new HttpRequest();
        
        if(!Test.isRunningTest()){
                endPointURL = 'https://cumminscss--CSSBMSINT.cs30.my.salesforce.com/services/apexrest/SendGSQPartsService/';

            }else{
                endPointURL = 'https://cumminscss--CSSBMSINT.cs30.my.salesforce.com/services/apexrest/SendGSQPartsService/';            }
               
        req1.setHeader('Authorization','Bearer '+access_token);
        req1.setHeader('Content-Type','application/json');
        req1.setMethod('POST');
        req1.setEndpoint(endPointURL);
        
        String reqWrpperInput = JSON.serialize(sendGSQPartsReq);
        req1.setBody(reqWrpperInput);              
        System.debug('req1.getBody======'+req1.getBody());
        //Sending request and mapping the response 
        res1 = h1.send(req1);
        String jsonResponseBody=res1.getBody();
        //de-serializing the response and mapping it to wrapper class
        sendGSQPartsRes= (CSS_getPartsListBMSResponseJ2A )JSON.deserialize(jsonResponseBody,CSS_getPartsListBMSResponseJ2A.class);
        System.debug('Status Code >>> :: '+res1.getStatusCode());
        System.debug('REST response is :: '+res1);
        system.debug('Response Body >>>'+res1.getbody());
        }
         catch(Exception ex){
                  System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
             if(!Test.isRunningTest()){
                 message = ex.getMessage();
             
             if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- SendGSQPartsRes', 'RESPONSE IS NULL', 'BMS');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- SendGSQPartsRes', res1.getBody(), 'BMS');
                }
            }
            }
        return sendGSQPartsRes;
    }
    
    }