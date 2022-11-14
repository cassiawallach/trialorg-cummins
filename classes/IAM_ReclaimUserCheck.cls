public class IAM_ReclaimUserCheck{

public pageReference send_reclaim_userCheck(){
String userValue = ApexPages.currentPage().getParameters().get('uNumber');
            String randomValue = ApexPages.currentPage().getParameters().get('randomNumber');
            String currentRecordId  = ApexPages.currentPage().getParameters().get('appid');
            String langValue = ApexPages.currentPage().getParameters().get(Label.Language_Parameter);
           System.debug('Printing Random value from URL'+randomValue);
           System.debug('Printing user random value'+userValue);
        
        try{

            User userdta = [Select id,Username,Name,IAM_Random_Number__c,IAM_External_User_Num__c From User WHERE IAM_External_User_Num__c =: userValue];
             System.debug('Printing random value from USer'+userdta.IAM_Random_Number__c); 
            if(userdta.IAM_Random_Number__c== randomValue){
             // currentUserName=userDta.Username;
              userDta.IAM_Random_Number__c='';
              Update userDta;
               PageReference pageRef = new pagereference('/IAM_CIHR_Change_Password?appid='
                + escapeHtml(currentRecordId) + '&uNumber=' + escapeHtml(userdta.IAM_External_User_Num__c)
                + '&' + Label.Language_Parameter + '=' + escapeHtml(langValue));
                pageRef.setRedirect(true);
                return pageRef;
            }else{
                System.debug('Inside Else');
                PageReference pageRef = Page.IAM_No_Authorization;
                pageRef.setRedirect(true);
                return pageRef;
            }
        }catch(exception ex){
            System.debug('Printing Exception'+ex.getStackTraceString());
            IAM_ErrorHandling.IAMerrorCapture('User unique external number'+userValue,'IAM CIHR FLOW',ex.getStackTraceString());
            PageReference pageRef = Page.IAM_No_Authorization;
            pageRef.setRedirect(true);
            return pageRef;
        }
   
}
/* Escape characters from string to avoid XSS attacks */
    String escapeHtml(String str) {
        if(String.isNotBlank(str)) {
            return str.escapeHtml3();
        } else {
            return str;
        }
    }    

}