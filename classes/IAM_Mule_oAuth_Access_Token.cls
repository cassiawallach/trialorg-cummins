/************************************************************
Name:  IAM_Mule_oAuth_Access_Token
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is class for IAM_Mule_oAuth_Access_Token class.This class is used for generating 
Access Token for Mule Services 2                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2020        INITIAL DEVELOPMENT          
*****************************************************/
/********************************************************************************
***********************************************************************************/
public without sharing class IAM_Mule_oAuth_Access_Token {
    
    //Method for Access token Generation.

    Public Static String generateAccessToken(String connectionName){
      String accessToken='';
        try{
            //Get Connection Details from CSS Remote Connections Object.
            //CSS_Integration_Details__c iamMuleoAuth = IAM_getConnnectionDetails.getConnection('IAM_Mule_oAuth');
            CSS_Integration_Details__c iamMuleoAuth = IAM_getConnnectionDetails.getConnection(connectionName);
            System.debug('Printing Connection Details'+iamMuleoAuth);
            String requestBody=oAuthBody(iamMuleoAuth);
            //Calling the service.
            if(!String.isBlank(requestBody)&&!String.isEmpty(requestBody)){
                Http http= new Http();
                HttpRequest request = new HttpRequest();
                request.setEndPoint(iamMuleoAuth.End_Point__c);
                request.setMethod(iamMuleoAuth.Method_Type__c);
                request.setHeader('Content-Type','application/json');
                request.setBody(requestBody);
                HttpResponse response = http.send(request);
                System.debug('Printing response from the mule'+response.getBody());
                System.debug('Printing response status from the mule'+response.getStatusCode());
                if(response.getStatusCode()==200){
                    //Parse the response
                    resBodyToApex resBody=parse(response.getBody());
                    accessToken=resBody.access_token;
                }
            }
        }catch(exception e){
            System.debug('Printing Exception in Mulesoft oAuth Generation Class'+e);
        }
      System.debug('Printing access token for Mule Soft'+accessToken);
      return accessToken;
    }

    //Method to generate oAuth Token body.to serialize
    Public Static String oAuthBody(CSS_Integration_Details__c iam){
        String responseBody='';
        oAuthBodyGenerator muleoAuth= new oAuthBodyGenerator(iam);
        responseBody=json.serialize(muleoAuth);
        System.debug('Printing JSON Body for oAuth'+responseBody);
        return responseBody;
    }

    public class oAuthBodyGenerator{
        public String client_id;
        Public String client_secret;
        Public String resource;
        
        Public oAuthBodyGenerator(CSS_Integration_Details__c intMule){
            this.client_id=intMule.Key__c;
            this.client_secret=intMule.Passcode__c;
            this.resource=intMule.Resource__c;
        }
    }

    //Method to deserealize the oAuth response.
    Public Static resBodyToApex parse(String reponseBody){
        return (resBodyToApex) System.JSON.deserialize(reponseBody,resBodyToApex.class);
    }

    Public class resBodyToApex{
        Public String token_type;
        Public String expires_in;
        Public String ext_expires_in;
        Public String expires_on;
        Public String not_before;
        Public String resource;
        Public String access_token;
    }
}