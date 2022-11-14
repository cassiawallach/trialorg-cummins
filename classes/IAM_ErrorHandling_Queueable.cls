/*************************************************************************************
Name:  IAM_ErrorHandling_Queueable
Copyright © 2022  Cummins
**************************************************************************************
Purpose: It stores catched exception in IAM_Identity_Management_Errors__c object. 
Inserts the exception in Queueable Context as Setup and non setup objects records 
can't be inserted in single execution context
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                      DATE               DETAIL                                
1.0      Suresh Rathod Nanavath       22/02/2022        INITIAL DEVELOPMENT
**************************************************************************************
**************************************************************************************/
public class IAM_ErrorHandling_Queueable implements Queueable {
    String processedData;
    String Origin;
    String ErrorDescription;
    String className;
    String username;
    
    public IAM_ErrorHandling_Queueable(String processedData,String Origin,String ErrorDescription,
    String className,String username)
    {
		this.processedData=processedData;
        this.Origin=Origin;
        this.ErrorDescription=ErrorDescription;
        this.className=className;
        this.username = username;
    }
	public void execute(QueueableContext Context){
        IAM_Identity_Management_Errors__c idm = new IAM_Identity_Management_Errors__c();        
        idm.IAM_Error_Source__c = this.Origin;
        idm.IAM_Error_Type__c = Label.IAM_Error_Type;
        idm.IAM_Error_Description__c = this.ErrorDescription;
        idm.IAM_Processed_Data__c = this.ProcessedData;
        idm.IAM_Class_Name__c = this.className;
        idm.IAM_Username__c = this.username;
        insert idm;
    }
    
}