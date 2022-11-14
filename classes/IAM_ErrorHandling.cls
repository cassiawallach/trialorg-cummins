/*************************************************************************************
Name:  IAM_ErrorHandling
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It stores catched exception in IAM_Identity_Management_Errors__c object
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                      DATE               DETAIL                                
1.0      Karthik Raj Golakaram        11/16/2018        INITIAL DEVELOPMENT
1.2      Shubhangi Sardar             27/04/2021        Added extra method to pass Class Name
1.3      Karthik Raj Golakaram        05/21/2021        Added extra method and few other fields_Push.
**************************************************************************************
**************************************************************************************/
global with sharing class IAM_ErrorHandling {

    public static void IAMerrorCapture(String ProcessedData, String Origin, String ErrorDescription) {
        IAM_Identity_Management_Errors__c idm = new IAM_Identity_Management_Errors__c();        
        idm.IAM_Error_Source__c = Origin;
        idm.IAM_Error_Type__c = Label.IAM_Error_Type;
        idm.IAM_Error_Description__c = ErrorDescription;
        idm.IAM_Processed_Data__c = ProcessedData;
        insert idm;      
    }

    /* Create exception in IAM_Identity_Management_Errors__c */
    public static void IAMerrorCapture(String ProcessedData, String Origin, String ErrorDescription,
    String className) {
        IAM_Identity_Management_Errors__c idm = new IAM_Identity_Management_Errors__c();        
        idm.IAM_Error_Source__c = Origin;
        idm.IAM_Error_Type__c = Label.IAM_Error_Type;
        idm.IAM_Error_Description__c = ErrorDescription;
        idm.IAM_Processed_Data__c = ProcessedData;
        idm.IAM_Class_Name__c = className;
        insert idm;
    }

    /* Create exception in IAM_Identity_Management_Errors__c with Username attribute */
    public static void IAMerrorCapture(String ProcessedData, String Origin, String ErrorDescription,
    String className, String username) {
        IAM_Identity_Management_Errors__c idm = new IAM_Identity_Management_Errors__c();        
        idm.IAM_Error_Source__c = Origin;
        idm.IAM_Error_Type__c = Label.IAM_Error_Type;
        idm.IAM_Error_Description__c = ErrorDescription;
        idm.IAM_Processed_Data__c = ProcessedData;
        idm.IAM_Class_Name__c = className;
        idm.IAM_Username__c = username;
        insert idm;
    }
    
     public virtual class Log{
        public string Type;
        public String Apexclass;
        public String ErrorDescription;
        public string ProcessedData;
        public string StackTrace;
        public string ErrorSource;
        public string errorMessage;
    }

    public class Error extends Log{
        public Error(string className, string errorDescription, string processedData, string errorSource, exception ex){
            this.Type='IDENTITY-ERROR';
            this.ApexClass=className;
            this.ErrorDescription=errorDescription;
            this.ProcessedData=processedData;
            this.ErrorSource= errorSource;
            this.errorMessage=ex.getMessage();
            this.stackTrace=ex.getStackTraceString();  
        }
    }

    public void createLog(log logToCreate){
        try{
            IAM_Identity_Management_Errors__c iamError=new IAM_Identity_Management_Errors__c();
            iamError.IAM_Class_Name__c=logToCreate.ApexClass;
            iamError.IAM_Error_Type__c=logToCreate.Type;
            iamError.IAM_Error_Source__c=logToCreate.errorSource;
            iamError.IAM_Error_Description__c=logToCreate.errorDescription;
            iamError.IAM_Processed_Data__c=logToCreate.processedData;
            iamError.IAM_Error_Message__c=logToCreate.errorMessage;
            iamError.IAM_Stack_Trace__c=logToCreate.stackTrace;
            Database.insert(iamError,false);
           
        }catch(exception ex){
            System.debug('Printing exception in error log class');
        }
    }
}