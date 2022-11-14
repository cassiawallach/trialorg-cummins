/**************************************************************************
Name:  IAM_Guidanz_writeException_Queueable
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class will retrigger the updateUserProfile method in 
IAM_Guidanz_PartnerAccountAutomation class if any exception 
occures during profile update
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -     Anupam Adhikari              17/02/2022        INITIAL DEVELOPMENT 
*******************************************************************************/
public class IAM_Guidanz_writeException_Queueable Implements Queueable{
    
    Private Map<Id, String> mapUserIdRole; 
    Private Map<Id, String> mapUserIdAppRole;
    Private Map<Id, String> mapUserIdAppGrp;
    Private List<String> errorListRec;
    Private Boolean sFlagCheck;
    
    public IAM_Guidanz_writeException_Queueable(Map<Id, String> mapUserIdRole, Map<Id, String> mapUserIdAppRole, Map<Id, String> mapUserIdAppGrp,List<String> errorListRec, Boolean sFlagCheck){
        this.mapUserIdRole=mapUserIdRole;
        this.mapUserIdAppRole=mapUserIdAppRole;
        this.mapUserIdAppGrp=mapUserIdAppGrp;
        this.errorListRec=errorListRec;
        this.sFlagCheck=sFlagCheck;
    }
    
    public void execute(QueueableContext Context){
        List<IAM_Identity_Management_Errors__c> errorRecList = New List<IAM_Identity_Management_Errors__c>();
        if(sFlagCheck){
            system.debug('inside exception queueable class--->');
            //IAM_Guidanz_PartnerAccountAutomation.updateUserProfile(mapUserIdRole,mapUserIdAppRole,mapUserIdAppGrp);
        }
        
        if(!sFlagCheck){
            for(String err : errorListRec){
                IAM_Identity_Management_Errors__c idm = new IAM_Identity_Management_Errors__c();        
                idm.IAM_Error_Source__c = 'Guidanz Evolution - Partner User Creation';
                idm.IAM_Error_Type__c = Label.IAM_Error_Type;
                //idm.IAM_Error_Description__c = err.getStatusCode() + ': ' + err.getMessage();
                idm.IAM_Error_Description__c = err;
                //idm.IAM_Processed_Data__c = err.getFields();
                idm.IAM_Class_Name__c = 'IAM_GuiCreate_PartnerUser';
                //idm.IAM_Username__c = this.username;
                errorRecList.add(idm);           
            }
            system.debug('errorRecList--->'+errorRecList);
            if(errorRecList.size() > 0){
                insert errorRecList;
            } 
        }             
    }
}