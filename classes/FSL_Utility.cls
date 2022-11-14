/************************************************************************************************************************************************************
Name: FSL_Utility 
------------------------------------------------------------------------------------------------------------------------------------       
Purpose: This class is used as a utility class for FSL Guidanz Integration Services.
------------------------------------------------------------------------------------------------------------------------------------
VERSION      AUTHOR                     DATE               DETAIL                                
1.0        Rajashekar Nallapati       11/04/2019         INITIAL DEVELOPMENT 
1.1        Sriprada Sesham            04/09/2020         Added methods for populating Country and State values 
*************************************************************************************************************************************************************/
public class FSL_Utility {
    
    /* Method Name : setEligibilityForApplicationLogging()
    *  Description : Set Eligible Flag To 'True' to create execution log 
    *  Parameter   : None
    *  Return Type : void
    */
    public static boolean setEligibilityForApplicationLogging(){
        boolean isEligibleForAppLogging = false;
        if(FSL_UserAppLoggingCS__c.getValues(UserInfo.getProfileId()) != null || FSL_UserAppLoggingCS__c.getValues(UserInfo.getUserId()) != null){
            isEligibleForAppLogging = true;
        }  
        return   isEligibleForAppLogging;      
    }
    
    /**
    * Name: SetNow
    * Description: This method is used to Set the Current Date. 
    * @parameters: None
    * @return: String
    **/
    public static String SetNow() {
        Datetime dt = System.now();       
        String dtTimeStr = dt.format(FSL_Constants.DATEFORMAT);
        return dtTimeStr;
    }
    
    //Added by Harsha on 4th March, 2020
    public static void LogInbIntError(string FSLResp, string sysError, string SrcMsg,string sSource){
        FSL_Integration_Error_Log__c errfsl = new FSL_Integration_Error_Log__c();
        errfsl.Error_Description__c = sysError + ' *** External Message ** ' + FSLResp;
        errfsl.Source__c = sSource;
        errfsl.Processed_Data__c = SrcMsg;
        insert errfsl;
    }
    
    public static void LogOutIntError(string FSLReq, string sysError, string SrcMsg,string sSource){ 
        FSL_Integration_Error_Log__c errObj = new FSL_Integration_Error_Log__c();
        errObj.Error_Description__c = sysError + ' *** External Message ** ' + SrcMsg;
        errObj.Source__c = sSource;
        errObj.Processed_Data__c = FSLReq;
        insert errObj;
    }
    
    Public Static User UserInfo() {
        User objUser = [SELECT Id, FederationIdentifier FROM User WHERE Id =:UserInfo.getUserId()];
        return objUser;
    }
     public static string getCountryCode(string cd){
        string strQuery;

        strQuery = [select CountryCode__c,CountryName__c from CSS_CountryStateValues__c where CountryName__c=:cd LIMIT 1].CountryCode__c;
        //CountryCode__c
        return strQuery;

    }
     public static string getStateCode(string ctcd, string stcd){
        //string strQuery;  commented by Rajesh Narra
        List<CSS_CountryStateValues__c> strQuery;
        String noStateValue = System.Label.CSS_State_and_Country_Error;
        strQuery = [select StateName__c, StateCode__c, CountryName__c from CSS_CountryStateValues__c where CountryName__c=:ctcd and StateName__c=:stcd LIMIT 1];
	//system.debug('StateCode:'+strQuery+''+strQuery[0].StateCode__c);
        if(strQuery.size()>0){
            return strQuery[0].StateCode__c;
        }else{
            return noStateValue;
        }
    }        
    
      public static string getCountryDesc(string cd){
        string strQuery;

        strQuery = [select CountryName__c,CountryCode__c from CSS_CountryStateValues__c where CountryCode__c=:cd LIMIT 1].CountryName__c;
        //CountryCode__c
        return strQuery;

    }
     public static string getStateDesc(string ctcd, string stcd){
        //string strQuery;  commented by Rajesh Narra
        List<CSS_CountryStateValues__c> strQuery;
        String noStateValue = System.Label.CSS_State_and_Country_Error;
        strQuery = [select StateName__c, CountryName__c from CSS_CountryStateValues__c where CountryCode__c=:ctcd and StateCode__c=:stcd LIMIT 1];

        if(strQuery.size()>0){
            return strQuery[0].StateName__c;
        }else{
            return noStateValue;
        }
    }
    
    /** Charan : Begin for Phoen-224**/
    public static string addEscapeChar(string inputString) {
        
        if(inputString.contains('"') || inputString.contains('\\')){
        inputString.escapeHtml4();
        system.debug('inputString  :::' +inputString);
        }
        return inputString;
    } 
       
    /**Phoen-224 Code ends **/

}