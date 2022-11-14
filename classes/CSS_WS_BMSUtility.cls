/**********************************************************************
Name: CSS_WS_BMSUtility
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Global Functionality Class to handle reusable code modules  
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0    Rakesh Kumar         01/09/2016     INITIAL DEVELOPMENT                    

***********************************************************************/
public class CSS_WS_BMSUtility {
    
    
    //Method to get access token from OAG
    public static string receiveToken(){
        string accessToken;
        string endPoint;
        HttpResponse res;
        try{HttpRequest req = new HttpRequest();
            Http http = new Http();
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
            res = http.send(req);
            string jSONRequestBody = res.getBody();
            CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
            accessToken = wo1.access_token;
            System.debug('BODY: '+res.getBody());  
            System.debug('Status: '+res.getStatus());
            System.debug('Status Code: '+res.getStatusCode());
           }
        catch(exception e){
            if(!Test.isRunningTest()){
            css_utility.LogOutIntError(endPoint,e.getMessage()+'- OAG Token', res.getBody(), 'SRT');
            }
        }
        return accessToken;
    }
    
    
    
    //Method to get the Access Token from the BMS Org 
    public static string getAccessTokenFromBMSOrg(){
        CSS_OAuth2 objAuthenticationInfo= new CSS_OAuth2();
        try{
            //OAuth defining
            String userName='surender.madipeddi@cummins.com.cssbmsint';
            String password='Bhavi@123';
            String securityToken='MXAVkc4A2qtuI4B2G4C747pSQ';
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
            //String responeNew= JSON.serialize(response.getbody());
            //System.debug('REST responeNew *********************is :: '+responeNew);
                                   
            objAuthenticationInfo = (CSS_OAuth2)JSON.deserialize(response.getbody(), CSS_OAuth2.class);
            system.debug('accesstoken##########################:::'+objAuthenticationInfo.access_token);
        
        }catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
        }
        return objAuthenticationInfo.access_token;
    }

}