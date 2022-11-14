@RestResource(urlMapping='/IAMsession/')
global with sharing class IAM_SessionManagement{       
    
    @HttpPost
    global static void IAMusersession(UserInfo UserInfo) {
      
     String username;
     String password;
     String domain;
     String sessionId ;
     String dealerCode;
     String activeSubscription;
     String OrgId;
     System.debug('Printing reponse from the servce'+UserInfo); 
     RestRequest request = RestContext.request;
   
      RestContext.response.addHeader('Content-Type', 'application/json');
        try{
           
            CSS_Integration_Details__c IAM = new CSS_Integration_Details__c();
            IAM = CSS_getConnnectionDetails.getConnection('IAM_Session_Management');
            domain=System.Label.IAM_Salesforce_Domain;
            username=UserInfo.userName;
            dealerCode = UserInfo.dealerCode;
            password=System.Label.IAM_PWC_AccountPassword;
            activeSubscription = checkActiveQSOLSubscription(dealerCode);
            String loginRes = sendLoginRequest(username,password,domain);
            system.debug('***********'+loginRes );
            if(!String.isBlank(loginRes) && !loginRes.containsIgnoreCase('INVALID_LOGIN')){
            
                Dom.Document loginDoc = new Dom.Document();
                loginDoc.load(loginRes);
                Dom.XmlNode resultElmt = loginDoc.getRootElement()
                  .getChildElement('Body','http://schemas.xmlsoap.org/soap/envelope/')
                  .getChildElement('loginResponse','urn:partner.soap.sforce.com')
                  .getChildElement('result','urn:partner.soap.sforce.com');
               
                 sessionId = resultElmt.getChildElement('sessionId','urn:partner.soap.sforce.com').getText();
                
               
            }
            
       }
       catch(Exception ex){
        System.debug('Prinritng exception'+ex.getMessage());   
       }
       System.debug('Printing session ID'+sessionId);
       RestContext.response.responseBody =  Blob.valueOf( 
                                    getResponse(sessionId.substring(15), activeSubscription));
       
       
       
        
       }

       /**
            Based on customer code we are checking is there any active QSOL subscriptions or not.
            @name: checkActiveQSOLSubscription  
            @param: dealer Code 
            @return: String - QuickServe Online subscription status
            @Date: 12/04/2022
        */
        private static string checkActiveQSOLSubscription(String dealerCode){      
            if(string.isNotBlank(dealerCode)){
                List<Account> accs = [select id,IAM_Service_Provider_Code__c, (select id,IAM_Status__c,IAM_Application_Name__c from Applications__r where IAM_Application_Name__c = 'QuickServe Online'AND IAM_Role__c = 'QSOL Dealer') from Account where IAM_Service_Provider_Code__c =: dealerCode];
           
                    if(accs.size() == 0){
                        return 'Dealer code not found';
                    } else {
                        //IAM_Service_Provider_Code__c is unique so we will get one Account record at max
                        for(IAM_Application__c app : accs[0].Applications__r){
                            if(app.IAM_Status__c == 'Active'){
                                return 'True';
                            }
                        } 
                        return 'False';
                    }      
            }
            return 'NA';
        }
       
       /**
        *  This method is used to call soap login service to get user session ID. 
        *  @name sendLoginRequest
        *  @param un-username,pw-user password+security token,domain-instance domain nane
        *  @return sessionId - user session ID 
         */

        private static String sendLoginRequest(String un,String pw,String domain){
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://' + domain + '.salesforce.com/services/Soap/u/30.0');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', '""');
        request.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header></Header><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + un + '</username><password>' + pw + '</password></login></Body></Envelope>');
        //request.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header><LoginScopeHeader xmlns="urn:partner.soap.sforce.com"><organizationId xmlns="urn:partner.soap.sforce.com">00D6C0000004p86</organizationId></LoginScopeHeader></Header><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + un + '</username><password>' + pw + '</password></login></Body></Envelope>');
        Http h = new Http();
        System.debug('Printing body'+request);
        if(!test.isRunningTest()){
        HttpResponse res = h.send(request);
        System.debug('Printing response code'+res.getBody());
        return res.getBody();
        }
        else{
        string mock='<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><loginResponse><result><metadataServerUrl>https://cumminscommerce--DBUCommSit.cs20.my.salesforce.com/services/Soap/m/30.0/00Dm00000003CgM</metadataServerUrl><passwordExpired>false</passwordExpired><sandbox>true</sandbox><serverUrl>https://cumminscommerce--DBUCommSit.cs20.my.salesforce.com/services/Soap/u/30.0/00Dm00000003CgM</serverUrl><sessionId>SESSION_ID_REMOVED</sessionId><userId>005m0000002VHvAAAW</userId><userInfo><accessibilityMode>false</accessibilityMode><currencySymbol>$</currencySymbol><orgAttachmentFileSizeLimit>5242880</orgAttachmentFileSizeLimit><orgDefaultCurrencyIsoCode>USD</orgDefaultCurrencyIsoCode><orgDisallowHtmlAttachments>false</orgDisallowHtmlAttachments><orgHasPersonAccounts>false</orgHasPersonAccounts><organizationId>00Dm00000003CgMEAU</organizationId><organizationMultiCurrency>false</organizationMultiCurrency><organizationName>Cummins DBU Commerce</organizationName><profileId>00em0000000M5AFAA0</profileId><roleId>00Em0000000V74tEAC</roleId><sessionSecondsValid>7200</sessionSecondsValid><userDefaultCurrencyIsoCode xsi:nil="true"/><userEmail>kiran.gadam@cummins.com</userEmail><userFullName>Fedex User1</userFullName><userId>005m0000002VHvAAAW</userId><userLanguage>en_US</userLanguage><userLocale>en_US</userLocale><userName>fedex@cummins.com</userName><userTimeZone>America/Indiana/Indianapolis</userTimeZone><userType>Standard</userType><userUiSkin>Theme3</userUiSkin></userInfo></result></loginResponse></soapenv:Body></soapenv:Envelope>';
        return mock;
        }
    }


         static String getResponse( String sessionid, String isAactive) {

            system.JSONGenerator gen = JSON.createGenerator(false);    
        
            gen.writeStartObject();
            gen.writeFieldName('Header');
            gen.writeStartObject();
            gen.writeStringField('Status', 'success');
            gen.writeStringField('ReturnCodeDescription', 'errDescription');
            gen.writeEndObject(); 

            If (sessionid != null  ) 
            {    
                gen.writeFieldName('DataArea');
                gen.writeStartObject();
                gen.writeFieldName('sessionManagement');
                gen.writeStartArray();             
                gen.writeStartObject();
                if(isAactive == 'true' || isAactive == 'NA'){
                  gen.writeStringField('sessionid',sessionid); 
                }
                    
                gen.writeStringField('Response',isAactive);                    
                gen.writeEndObject();
             }       

                return gen.getAsString();

    }   
   
    global class UserInfo{
           
             
             public string userName{set;get;}
             public string dealerCode{set;get;}
                    
        }  
  
}