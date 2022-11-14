public class IAM_OTPPageController {
     Public String OTP {get;set;}
     Public Map<String,String> params{get;set;}
     public IAM_OTPPageController()
     {
         //SendOTPToUser();
         
         params=ApexPages.CurrentPage().getparameters();
        System.debug('Printing all parameters'+params);
     }
      
     public pageReference redirectRegistartionpage(){
             PageReference retURL ;
         //
           /* String url = '';
            if(!String.isBlank(ApexPages.CurrentPage().getparameters().get('appid')))
            {
                url += 'appid='+ApexPages.CurrentPage().getparameters().get('appid');
            }
            if(!String.isBlank(ApexPages.CurrentPage().getparameters().get('returl')))
            {
                if(url != '')
                    url += '&';
                url += 'returl='+ApexPages.CurrentPage().getparameters().get('returl');
            }
            if(!String.isBlank(ApexPages.CurrentPage().getparameters().get('lang')))
            {
                if(url != '')
                    url += '&';
                url += 'lang='+ApexPages.CurrentPage().getparameters().get('lang');
            }
            if(!String.isBlank(ApexPages.CurrentPage().getparameters().get('resource_url')))
            {
                if(url != '')
                    url += '&';
                url += 'resource_url='+ApexPages.CurrentPage().getparameters().get('resource_url');
            }
             string headerdata= ApexPages.currentPage().getHeaders().get('Host') + '/IAM_CumminsRedirectPage_new?';
         
             String urlvalue=Apexpages.currentPage().getUrl() ;         
             //url='https://' + headerdata+ url;
            System.debug('headerdata=='+headerdata);
         System.debug('urlvalue=='+urlvalue);*/
         
        // System.debug('url=='+url);
             retURL =new PageReference(IAM_Relay_Values.GetValueFromParam('finalStartUrl')+'&RelayState='+IAM_Relay_Values.GetValueFromParam('RelayState')+'&binding='+IAM_Relay_Values.GetValueFromParam('binding')+'&inresponseto='+IAM_Relay_Values.GetValueFromParam('inresponseto'));
            System.debug('return URL ='+retURL);
             retURL.setRedirect(true);
        return retURL;
     }
     
     public void SendOTPToUser()
     {
     Contact c=new Contact();
        String uId = UserInfo.getUserId();
         User u = [Select id,Email,ContactId from user where id =: uId];
         //Email  =u.Email;//ApexPages.CurrentPage().getparameters().get('Email');
         
      String rand = string.valueof(Math.abs(Crypto.getRandomInteger()));
       OTP = rand.substring(0,6);
        String[] toAddresses=new String[]{};
        /*This is for Email testing*/
    c= [select email,id,phone from contact where id=:u.ContactId limit 1];
    system.debug('printing contact details for otp'+c);
    c.OTP_Code__c=OTP;
    
     toAddresses.add(c.Email);
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
    {
     if(owa.Address.contains('noreply')) 
      mail.setOrgWideEmailAddressId(owa.id); 
    }
    String fromAddress='noreply.identity@cummins.com';
    mail.setTargetObjectId(c.Id);
    mail.setTreatTargetObjectAsRecipient(false); 
       
    
    if(!Test.isRunningTest()){
    EmailTemplate template = [SELECT id FROM EmailTemplate WHERE name  ='BOX_OTP'];
    update c;
        system.debug('toAddresses=='+toAddresses);
    
    mail.setTemplateId(template.id);
    mail.setToAddresses(toAddresses);
   // mail.setWhatId(otp);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    system.debug('####################################'+OTP);
    }
    //return otp;
    

     } 

        
}