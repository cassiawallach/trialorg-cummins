Public class IAM_PWC_Login{
Public String username{set;get;}
Public String UID{set;get;}
Public Map<String,String> params{set;get;}

    public IAM_PWC_Login(){
       
       
         UID=ApexPages.CurrentPage().getparameters().get('UID');
         System.debug('Printing UID'+UID);
        if(String.isNotBlank(UID)){
            List<User> usr=[select id,username,FederationIdentifier,IAM_UID__C from user where IAM_UID__C=:UID];
            if(!usr.isEmpty()){
            username=usr[0].username;
            }
        }     
    }
    

 Public pagereference doPWCLogin(){
        
        pageReference pReg;
        pageReference login;
        
        
        params=ApexPages.CurrentPage().getparameters();
        System.debug('Printing all parameters line 28'+params);
        System.debug('Printing relay URL'+IAM_Relay_Values.GetValueFromParam('appURL')); 
        
        System.debug('Printing Random Number'+IAM_PWC_CumminsRedirectPage.loginNumber);
        String currentRecordId  = ApexPages.CurrentPage().getparameters().get('appid');
        String fedexReturnURL=ApexPages.currentpage().getParameters().get('fedexReturnUrl');
        String fedexEmail=ApexPages.CurrentPage().getParameters().get('FedexemailId');
        String fedexSessionId=ApexPages.CurrentPage().getParameters().get('sessionId');
        
        String loginNumber=ApexPages.CurrentPage().getParameters().get('code');
        System.debug('Printing code from URL'+loginNumber);
        
        
        
        System.debug('Pritning appid '+currentRecordId);
        System.debug('Printing federation return URL'+fedexReturnURL);
        System.debug('Printing fedex email'+fedexemail);
        System.debug('Printing session ID'+fedexSessionId);
        
       
        List<User> usr=[select id,username,FederationIdentifier,IAM_Random_Number__c,IAM_UID__C from user where IAM_UID__C=:UID];
        
        
        if(!usr.isEmpty()){
        username=usr[0].username;
        System.debug('Printing random Number'+usr[0].IAM_Random_Number__c);
           if(usr[0].IAM_Random_Number__c==loginNumber){ 
             App_Mapping__c ap=[select id,CMI_External_Start_Url__c from App_Mapping__c where id=:currentrecordId];
            System.debug('app details'+ap);
            String finalURL='';
            if(String.isEmpty(fedexemail)){
            System.debug('Printing fedex email is null');
                finalURL=ap.CMI_External_Start_Url__c+'&RelayState='+IAM_Relay_Values.GetValueFromParam('appURL');
            }else if(!string.isEmpty(fedexemail)){
           
                String relayState='&fedexReturnUrl='+fedexReturnURL+'&FedexemailId='+fedexEmail+'&sessionId='+fedexSessionId;
                String encodedURL = EncodingUtil.urlEncode(relayState, 'UTF-8');
                finalURL=System.Label.IAM_PWC_Cumpas_Redirect_URL+ap.id+encodedURL;
                System.debug('Printing fedex email is not null'+finalURL);
            }
            pReg = Site.login(usr[0].username,System.Label.IAM_PWC_AccountPassword,finalURL);
            System.debug('Printing site login '+pReg);
            
           // pReg=new pagereference();
           if(pReg!=null){
            pReg.setredirect(true);
            System.debug('Printing pReg regular'+pReg);
            if(usr[0].IAM_Random_Number__c!=null&&usr[0].IAM_Random_Number__c!=''){
                usr[0].IAM_Random_Number__c='';
                Update usr;
            }
            return pReg;
           }
         }  
         return null; 
        }
        System.debug('Printing pReg null'+pReg);
        return null;
    }
 }