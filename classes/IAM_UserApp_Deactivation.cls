/************************************************************
Name:  IAM_UserApp_Deactivation
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Below class will be invoked from the trigger of IAM_Contact_Provisioning__c and will pickup  all the records
and for loop will be present in order to execute for each record and apex transactions will have 100 callouts.2                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020    Made Changes to the class for Mule API Conversion 
                                                 Also Made changes for username that needs to be send in API.       
*****************************************************/
/********************************************************************************
***********************************************************************************/

Public with sharing Class IAM_UserApp_Deactivation{
    
    @future(Callout=True)
    Public Static void deactivateCallOut(set<id> conProvIds){
     try{
     List<IAM_Contact_Provisioning__c> conProv=[select id,IAM_Application_Name__c,IAM_End_Date__c,IAM_User__c,IAM_Username__c,IAM_Contact__r.Username__c,IAM_Contact__r.IAM_Ext_Legacy_UID__C from IAM_Contact_Provisioning__c where id=:conProvIds];
     System.debug('lsit of classes'+conProv);
     

     if(!conProv.isEmpty()){  
     
     //string accessToken=getoAuthToken();
     String accessToken= IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_Mule_oAuth');
     CSS_Integration_Details__c iamDeactivate = IAM_getConnnectionDetails.getConnection('IAM_User_Deactivation_Cumpas_Mule');
         if(!String.isEmpty(accessToken) || Test.isRunningTest()){
             
             system.debug('conProv@@@@@@@@@'+conProv);
             for(IAM_Contact_Provisioning__c iam:conProv){
                 httpRequest req= new httpRequest();
                 Http h = new Http();
                 httpResponse res;
                 //new get body of the request
                 String jsonBody=deactivationPayload(iam);
                 if(!string.isEmpty(jsonBody)){
                 try{
                 req.setMethod(iamDeactivate.Method_Type__c);
                 req.setEndPoint(iamDeactivate.End_Point__c);
                 req.setHeader('Content-Type','application/json');
                 req.setHeader('Authorization','Bearer '+accessToken);
                 req.setHeader('resource', iamDeactivate.Resource__c);
                 req.setBody(jsonBody);
                 res = h.send(req);
                 System.debug('http response code is '+res.getStatusCode());
                 System.debug('Printing Response Body'+res.getBody());  
                 }catch(exception es){
                    System.debug('Printing debug'+es.getStackTraceString()); 
                    IAM_ErrorHandling.IAMerrorCapture(es.getStackTraceString(),'user Deactivate',jsonBody);                    
                 }
                 }else{
                     //loop if body is not present 
                     System.debug('Printing no body');
                     IAM_ErrorHandling.IAMerrorCapture('No Body for the reques','user Deactivate',iam.id); 
                 }
             }
     
         }else{
         //loop to say if no access token is assaigend 
         IAM_ErrorHandling.IAMerrorCapture('No access token is provided','user Deactivate',conProv[0].id);
         
         }
        }else{
        //loop where no records present.
        IAM_ErrorHandling.IAMerrorCapture('No records to Process','user Deactivate','No records to process');
        
        }    
     }catch(exception e){
         System.debug('Printing exeption from the main class'+e.getMessage());
         IAM_ErrorHandling.IAMerrorCapture(e.getStackTraceString(),'user Deactivate',e.getMessage());
     }
    }
    
    
   /* //Method to generate Access token 
    Public Static String getoAuthToken(){
     httpRequest req=new httpRequest();
        httpResponse res;
        string error='';
       try{
        
        req.SetMethod('POST');  
        req.setEndpoint('https://services-stg-oauth.cummins.com/api/oauth/token/iam');
        //Access Token & Refresh Token
        req.setBody('grant_type=client_credentials&client_id=97f54892-5bf4-4f07-9d8b-5b2af8c06f4c&client_secret=9021845c-126b-4fec-8af9-3f7c662fbc31&scope=IAM');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');        
         res = new http().send(req);
        System.debug(res.getBody());
        string jSONRequestBody= res.getBody();
         LDAP_util  wo1 = (LDAP_util)JSON.deserializeStrict(jSONRequestBody,LDAP_util.class); 
        String accessToken=wo1.access_token;//Access token from IAM authentication class. 
        System.debug('Printing access Token '+accessToken );
         
        return accessToken;
        }catch(exception e){
            System.debug('Printing error Message for OAG Access token'+e.getMessage());
            //Calling IDM error Handiling Class to insert the error into the error Object.
            error=e.getMessage();
            IAM_ErrorHandling.IAMerrorCapture(res.getbody(),'EDQ oAuth',e.getMessage());
            return null;
            }    
        }*/
    //End of Token Method
    
    //Method to generate Payload
    
     Public static String deactivationPayload(IAM_Contact_Provisioning__c conProv){
     String JSONstring;
     UserPayload lstWapperforPut;
     lstWapperforPut=new UserPayload(conProv);
        if(lstWapperforPut!=null){
            JSONString = JSON.serialize(lstWapperforPut);
        }
    System.debug('Printing return string '+JSONstring);
    return JSONstring;
    }
    
    //Methond to generate Payload and Wrapper Classes.   
       Public Class UserPayload{
            Public UserAppDeprovisionInfo UserAppDeprovisionInfo{set;get;}
               
               Public UserPayload(IAM_Contact_Provisioning__c conProvision ){
                   this.UserAppDeprovisionInfo=new UserAppDeprovisionInfo(conProvision);
               }
       }
       
       Public Class UserAppDeprovisionInfo{
           Public String applicationName{set;get;}
           Public String userName{set;get;}
           Public date endDate{set;get;}     
                Public UserAppDeprovisionInfo(IAM_Contact_Provisioning__c conP){
                    this.applicationName=conP.IAM_Application_Name__c;
                    //Changing the logic for user name assignment - Karthik Golakaram  on 12/09/2020.
                    if(String.isEmpty(conp.IAM_Contact__r.IAM_Ext_Legacy_UID__C)){
                        this.userName=conP.IAM_Contact__r.Username__c;
                    }else{
                        this.userName=conP.IAM_Contact__r.IAM_Ext_Legacy_UID__C;
                    }
                    
                    //End of Changes - KArthik Golakaram 12/09/2020.
                    this.endDate=conP.IAM_End_Date__c;
                }
        }
        
        
        

}