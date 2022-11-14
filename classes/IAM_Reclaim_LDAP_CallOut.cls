/************************************************************
Name:  IAM_Reclaim_LDAP_CallOut
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Apex Class to make call to ldap to Authenticate user. 2                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020    Made Changes to the class for Mule API Conversion     
*****************************************************/
/********************************************************************************
***********************************************************************************/
Public Class IAM_Reclaim_LDAP_CallOut{
       
    Public Static Boolean authentication(String userName, String Password){
    System.debug('Printing future login');
     Http h = new Http();
     HttpResponse res;
     HttpRequest req;
     Boolean returnVariable;  
     String responseBody=''; 
     String ReqBody=''; 
     String accesstoken='';        
       try{
       //calling Location request parser class to get request body

            if(!Test.isRunningTest()){
                accesstoken=IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_Mule_oAuth');
            }else{
                accesstoken='12345678923456782345678345678';
            }
       
            if(String.isNotEmpty(userName)){ 
                ReqBody=authenticationBody(userName,Password);
            }
            System.debug('Priniting Request body from the parser class'+ReqBody); 
            if(ReqBody!=null&&ReqBody!=''){

            //need to set header parameters and then call the service.
            System.debug('Printing entered request body not equal to null');
             string url=System.Label.IAM_LDAP_Reclaim_URL;
             CSS_Integration_Details__c iamAuth = IAM_getConnnectionDetails.getConnection('IAM_LDAP_Authenticate_Mule');
             req = new HttpRequest();
             req.setEndpoint(iamAuth.End_Point__c);
             req.setMethod(iamAuth.Method_Type__c);
             req.setHeader('Content-Type', 'application/json');
             req.setBody(ReqBody);
             req.setHeader('Authorization','Bearer '+accesstoken);
               
             //not making callout if it is test class.
             if(!Test.isRunningTest()&&System.Label.IAM_org_label=='.cso'){
             
              res = h.send(req);
              System.debug('http response code is '+res.getStatusCode());
              //System.debug('Printing Response Body'+res.getBody());  
              if(res.getStatusCode()==200){
                  //This means authentication is Success.
                 IAM_AuthenticationMessage msg=IAM_AuthenticationMessage.Parse(res.getBody());
                 
                  //System.debug('Printing response a'+msg);
                  System.debug('Printing Status Code'+msg.data.SuccessCode);
                  if(msg.data.SuccessCode==200){
                 returnVariable=true;
                 responseBody=res.getBody(); 
                 }else{
                 returnVariable=false;
                 }  
              }

             }else{
                 if(!String.isEmpty(System.Label.IAM_Reclaim_Password)){
                 returnVariable=Password.equals(System.Label.IAM_Reclaim_Password);
                 }
             }
            
         }else{
             IAM_ErrorHandling.IAMerrorCapture(res.getbody(),'EDQ Address cleanse Future Method','No request Body');
             returnVariable=false;
         }
          }catch(exception e){
                System.debug('Printing exception message'+e.getMessage());
                //Calling IDM Error handling class to inser the error in to the error Object.
                IAM_ErrorHandling.IAMerrorCapture(responseBody,'EDQ Address cleanse Future Method',e.getMessage());
                returnVariable=false;
            } 
            System.debug('Printing return value'+returnVariable); 
              return returnVariable; 
    }
    
   
 Public Static String authenticationBody(String userName,String password){
     String JSONstring;
     authenticationPayload lstWapperforPut;
     lstWapperforPut=new authenticationPayload(userName,password);
     if(lstWapperforPut!=null){
         JSONString = JSON.serialize(lstWapperforPut);
     }
     System.debug('Printing return string '+JSONstring);
     return JSONstring;
 }
 
 Public Class authenticationPayload{
         Public DataArea DataArea{set;get;}
       
             
             Public authenticationPayload(String uName, String pWord){
                 this.DataArea=new DataArea(uName,pWord);
             }
     }
     
     Public class DataArea{
         Public String userName{set;get;}
         Public String password{set;get;}
             Public DataArea(String Name,String word){
                 This.userName=Name;
                 This.password=word;
             }
     }
     
}