/*
This class is a controller class gets invoked by QSOL or any PWC flow team for integration or login of PWC accounts.
*/
public class IAM_PWC_CumminsRedirectPage{ 
public user u{set;get;}
Public Static String loginNumber;
Public map<String,String> params{set;get;}
 
//public id appId{set;get;}
    Public IAM_PWC_CumminsRedirectPage(){
       loginNumber= IAM_RandomNumber.getRandom();
        System.debug('Printing random number'+loginNumber);
         user usr=[select id,name,ProfileId,username,FederationIdentifier,IAM_Random_Number__c,IAM_UID__C from user where user.Id=:userinfo.getUserId()]; 
        
        params=ApexPages.CurrentPage().getparameters();
        System.debug('Printing all parameters'+params); 
         
    }

  
   //Commented for testing purpose
    public PageReference Redirect(){
    
    
    user u=[select id,name,ProfileId,username,FederationIdentifier,IAM_Random_Number__c,IAM_UID__C from user where user.Id=:userinfo.getUserId()];
    u.IAM_Random_Number__c=loginNumber;
    Update U;
    
    params=ApexPages.CurrentPage().getparameters();
    System.debug('Printing all parameters line 28'+params);
    System.debug('Printing relay URL'+IAM_Relay_Values.GetValueFromParam('appURL')); 
    
     
   PageReference pageRef;
   Boolean setRedirect=false;//Redirect variable to send to request access page     
    String appId = apexpages.currentpage().getparameters().get('appid');
    String fedexReturnURL=ApexPages.currentpage().getParameters().get('fedexReturnUrl');
    String fedexEmail=ApexPages.CurrentPage().getParameters().get('FedexemailId');
    String fedexSessionId=ApexPages.CurrentPage().getParameters().get('sessionId');
    
    System.debug('Printing app id'+appId);
    
    //Directly redirecting the page
   List<App_Mapping__c> app=[select id,CMI_External_Start_Url__c from App_Mapping__c where id=:appId];
            
            system.debug('federation string'+fedexEmail);
            if(String.isEmpty(fedexEmail)){
            System.debug('Printing email case where fedex is null');
            pageRef=new pageReference(System.Label.IAM_PWC_Domain_Name+appId+'&UID='+u.IAM_UID__C+'&code='+loginNumber+'&appURL='+IAM_Relay_Values.GetValueFromParam('appURL'));
            }else{
            System.debug('Printing email case where fedex is not null');
            pageRef=new pageReference(System.Label.IAM_PWC_Domain_Name+appId+'&UID='+u.IAM_UID__C+'&code='+loginNumber+'&fedexReturnUrl='+fedexReturnURL+'&FedexemailId='+fedexEmail+'&sessionId='+fedexSessionId);
            }
            System.debug('Printing return String'+pageRef);
            pageRef.setRedirect(true);
            return pageRef;
            
    //Need to remove above lines of code
    //Commenting below lines for QSOL PWC account testing
   
    }

}