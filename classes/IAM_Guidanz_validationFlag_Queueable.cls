/**************************************************************************
Name:  IAM_Guidanz_validationFlag_Queueable
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class will uncheck the IAM_Guidanz_Skip_Validation__c flag
at the end off process, so that user field on User Feature & 
Access record is not editable again.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -     Anupam Adhikari              03/01/2022        INITIAL DEVELOPMENT 
******************************************************************************/
public class IAM_Guidanz_validationFlag_Queueable Implements Queueable{
    
    Private List<IAM_Contact_Provisioning__c> allUserFeatList;
    
    public IAM_Guidanz_validationFlag_Queueable(List<IAM_Contact_Provisioning__c> allUserFeatList){
        this.allUserFeatList = allUserFeatList;
    }
    
    public void execute(QueueableContext Context){
        List<IAM_Contact_Provisioning__c> userFeatUpdFlagList = new List<IAM_Contact_Provisioning__c>();
        for(IAM_Contact_Provisioning__c conP : allUserFeatList){
            conP.IAM_Guidanz_Skip_Validation__c = False;
            userFeatUpdFlagList.add(conP);
        }
        system.debug('userFeatUpdFlagList--->'+userFeatUpdFlagList);
        if(userFeatUpdFlagList.size() > 0){
            update userFeatUpdFlagList;
        }
    }

}