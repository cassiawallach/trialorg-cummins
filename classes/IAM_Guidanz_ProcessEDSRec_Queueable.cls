/**************************************************************************
Name:  IAM_Guidanz_ProcessEDSRec_Queueable
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class will call IAM_contactHelperClass to update contact
attributes
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -     Anupam Adhikari              14/02/2022        INITIAL DEVELOPMENT 
*******************************************************************************/
public class IAM_Guidanz_ProcessEDSRec_Queueable Implements Queueable{
    
    Private List<IAM_Contact_Provisioning__c> guiConProvInsertList;
    
    public IAM_Guidanz_ProcessEDSRec_Queueable(List<IAM_Contact_Provisioning__c> guiConProvInsertList){
        this.guiConProvInsertList=guiConProvInsertList;
    }
    
    public void execute(QueueableContext Context){
        
        IAM_contactHelperClass.updateApplicationContact(guiConProvInsertList);       
    }
}