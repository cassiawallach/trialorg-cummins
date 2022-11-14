/**********************************************************************
Name: EVL_Utility
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This component is used accross all the classes.
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Anirudh Pesari      05/05/2020      INITIAL DEVELOPMENT  
2.0 - Krishnamoorthi      06/22/2020      CLONE METHODS FROM FSL_Utility. 
***********************************************************************/
public class EVL_Utility {

    public static List<String> getStageValues(String loggedInProfileName) {
        
        String profileName = '%'+loggedInProfileName+'%';
        List<EVL_PathSetting__mdt> strIsActiveFor = [SELECT MasterLabel,isActive_For__c
                                                 FROM EVL_PathSetting__mdt 
                                                 WHERE isActive_For__c LIKE : profileName];
        System.debug(strIsActiveFor);
        List<String> stageValues = new List<String>();
        for(EVL_PathSetting__mdt objPathSetting : strIsActiveFor) {
            stageValues.add(objPathSetting.MasterLabel);
        }
        System.debug(stageValues);
        return stageValues;
    }
    
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
}