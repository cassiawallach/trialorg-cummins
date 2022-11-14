/************************************************************
Name:  IAM_Reclaim_Contact_Update_Queueable
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Class for Reclaim Process Contact Update.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Golakram       09/02/2020        INITIAL DEVELOPMENT 
1.1 -    Karthik Golakaram      10/19/2020        Made change to guidanz contact
                                                  account location is not IAM Default. 
1.2      Shubhangi Sardar       12/03/2020        Added NPBU Diagnostic Expration            
*****************************************************/
public class IAM_Reclaim_Contact_Update_Queueable Implements Queueable{
    
    Private Contact cn;
    Private String newUsername;
    Private String newEmail;
    Private Boolean isGuidanzUSer;
    Private Map<String,Boolean> reclaimTracker;
    Private Boolean isDuplicateUser;
    Private id guidanzContactId;
    Private user userCreated;

    public IAM_Reclaim_Contact_Update_Queueable(user userCreated,id guidanzContactId,Contact cn,String newUsername,String newEmail,Boolean isGuidanzUSer,Map<String,Boolean> reclaimTracker,Boolean isDuplicateUser) {
        this.userCreated=userCreated;
        this.guidanzContactId=guidanzContactId;
        this.cn=cn;
        this.newUsername=newUsername;
        this.newEmail=newEmail;
        this.isGuidanzUSer=isGuidanzUSer;
        this.reclaimTracker=reclaimTracker;
        this.isDuplicateUser=isDuplicateUser;
    }

    Public Void execute(QueueableContext Context){
        try{
            List<User> usr=[Select id,IAM_Application_Roles__c,IAM_Promotion__c from User where id=:userCreated.id];
            if(!String.isEmpty(newUsername)&&!String.isEmpty(cn.IAM_Ext_Legacy_UID__C)){
                IAM_Reclaim_Utility.UpdateNewUserName(cn.IAM_Ext_Legacy_UID__C,newUsername);
            }
            if(!reclaimTracker.isEmpty()){
                IAM_Reclaim_Utility.UpdateReclaimTracker(newUsername,reclaimTracker);
            }
            if(isGuidanzUSer){
                // Process if it is a guidanz User or contact does have  a User record.
                System.debug('Guidanz User is Present');
                //Chech the respective Contact of the Guidanz user and update the contact attributes of the Guidanz User.
                Contact gzCon= new Contact(id=guidanzContactId);
                if(gzCon.AccountId==Label.IAM_Default_Location_ID_1||gzCon.AccountId==Label.IAM_Default_Location_ID_2){
                    gzCon.AccountId=cn.AccountId;
                }
                gzCon.FirstName=(cn.FirstName!=null?cn.FirstName:'');
                gzCon.LastName=(cn.LastName!=null?cn.LastName:'');
                //email that user entered from the Reclaim page
                gzCon.email=(newEmail!=null?newEmail:'');
                gzCon.Username__c=(newUsername!=null?newUsername:'');
                //Username the user enterd in reclaim Page
                /*if(label.css_org=='.cso'){
                    gzCon.Username__c=(newUsername!=null?newUsername:'');
                }else{
                    gzCon.Username__c=(newUsername!=null?newUsername+Label.css_org:'');   
                }*/
                gzCon.CMI_Contact_Type__c=(cn.CMI_Contact_Type__c!=null?cn.CMI_Contact_Type__c:'');
                gzCon.IAM_Contact_Status__c='Active';//Making Contact status Active since there is user already present.
                gzCon.IAM_Applications__c=(cn.IAM_Applications__c!=null?cn.IAM_Applications__c:'');
                gzCon.IAM_Application_Roles__c=(usr[0].IAM_Application_Roles__c!=null?usr[0].IAM_Application_Roles__c:'');
                gzCon.IAM_is_Member_of__c=(cn.IAM_is_Member_of__c!=null?cn.IAM_is_Member_of__c:'');
                gzCon.IAM_Product_Group_Access__c=(cn.IAM_Product_Group_Access__c!=null?cn.IAM_Product_Group_Access__c:'');
                gzCon.IAM_Qsolexpiration__c=(cn.IAM_Qsolexpiration__c!=null?cn.IAM_Qsolexpiration__c:'');
                gzCon.IAM_Qsolview__c=(cn.IAM_Qsolview__c!=null?cn.IAM_Qsolview__c:'');
                /* 12/03/2020 - Added NPBU Diagnostic Expration */
                gzCon.IAM_NpbuDiagExpire__c=(cn.IAM_NpbuDiagExpire__c!=null?cn.IAM_NpbuDiagExpire__c:'');
                //Work group ID should be check While inserting the Contact.
                gzCon.IAM_Work_Group_Id__c=(cn.IAM_Work_Group_Id__c!=null?cn.IAM_Work_Group_Id__c:'');
                gzCon.IAM_swregexpire__c=(cn.IAM_swregexpire__c!=null?cn.IAM_swregexpire__c:'');
                //gzCon.IAM_ABO_Code_Formula__c=cn.IAM_ABO_Code_Formula__c;
                gzCon.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                gzCon.IAM_Ext_Legacy_Uid__c=(cn.IAM_Ext_Legacy_Uid__c!=null?cn.IAM_Ext_Legacy_Uid__c:'');
                gzCon.IAM_Legacy_User__c=false;
                gzCon.IAM_Promotion__c=(usr[0].IAM_Promotion__c!=null?usr[0].IAM_Promotion__c:'');
                //gzCon.IAM_DN_Value__c = IAM_Utility.getDNValue(newUsername, false, gzCon.IAM_Internal__c);
               gzCon.IAM_DN_Value__c = IAM_Utility.getDNValue(newUsername,gzCon.IAM_Person_Type__c);//added by vineet
   
        //Deleting the contact the is inserted as a part of data loading.
                Contact conRec = new Contact();
               if(cn.id!=gzCon.id){
                updateUserFeature(cn.Id);
                conRec = [Select IAM_Applications__c, IAM_is_Member_of__c, IAM_Promotion__c from Contact
                         where Id =: cn.Id];
                    // before deleting contact delete User access features frst.
                    List<IAM_Contact_Provisioning__c> conDel= [SELECT id,IAM_Reject_Reason__c,IAM_Reason__c FROM IAM_Contact_Provisioning__c WHERE IAM_Contact__C=:cn.id];
                    if(!conDel.isEmpty()){
                        for(IAM_Contact_Provisioning__c iamCP: conDel){
                            iamCp.IAM_Status__c='Inactive';
                            iamCP.IAM_Reject_Reason__c='Other';
                            iamCP.IAM_Reason__c='Deactivated because we already have a guidanz User.';
                        }
                        Update conDel;
                    }
                    cn.IAM_Ext_Legacy_UID__c='';
                    cn.IAM_Contact_Status__c='Inactive';
                    Update cn;
                }
                gzCon.IAM_Applications__c=(conRec.IAM_Applications__c!=null?conRec.IAM_Applications__c:'');
                gzCon.IAM_is_Member_of__c=(conRec.IAM_is_Member_of__c!=null?conRec.IAM_is_Member_of__c:'');
                Update gzCon;
                //Create User access and Features under new guidanz contact using Application groups attributre.
                ID jobID = System.enqueueJob(new IAM_Reclaim_Queable_API_Class(gzCon,isDuplicateUser));
            System.debug('Printing Secondary JOB ID'+jobID); 
            }else{
                //Case where Contact does not have any user record.
                System.debug('Updating Contact where wthere is no guidanz user record');
                /*if(label.css_org=='.cso'){
                    cn.Username__c=(newUsername!=null?newUsername:'');
                }else{
                    cn.Username__c=(newUsername!=null?newUsername+label.css_org:'');
                }*/
                //cn.IAM_DN_Value__c = IAM_Utility.getDNValue(newUsername, false, cn.IAM_Internal__c);
                cn.IAM_DN_Value__c = IAM_Utility.getDNValue(newUsername,cn.IAM_Person_Type__c);//added by vineet
                cn.Username__c=(newUsername!=null?newUsername:'');
                cn.email=(newEmail!=null?newEmail:'');
                cn.IAM_Contact_Status__c='Active';
                cn.IAM_Legacy_User__c=false;
                cn.IAM_Promotion__c=(userCreated.IAM_Promotion__c!=null?userCreated.IAM_Promotion__c:'');
                cn.IAM_Application_Roles__c=(usr[0].IAM_Application_Roles__c!=null?usr[0].IAM_Application_Roles__c:'');
                Update cn;
                //below method call to update any user feature record in Pending status to Active for this contact - @Anupam CHG0065797
                updateUserFeature(cn.Id);
                // Update User access and feature with respective new username and also create if any new has to be ceated.
                ID jobID = System.enqueueJob(new IAM_Reclaim_Queable_API_Class(cn,isDuplicateUser));
                System.debug('Printing Secondary JOB ID'+jobID); 
            }

            reclaimTracker.put('Is_Contact_Update',true);
            IAM_Reclaim_Utility.UpdateReclaimTracker(newUsername,reclaimTracker);
            
             
        }catch(exception e){
            System.debug('Printing exception'+e);
            System.debug('Prinitng Stack Trace String'+e.getStackTraceString());
            //Code write to error Object and Reclaim tracker status.
            String processedData = 'Method - execute, Contact Id - '
            + cn.Id + ', New Username User Choose - ' + newUsername;
            IAM_ErrorHandling.IAMerrorCapture(processedData, Label.IAM_Reclaim_Flow, 
            e.getStackTraceString() + ' - ' + e.getMessage(),
            IAM_Reclaim_Contact_Update_Queueable.class.getName());
        }
    }
    
    //CHG0065797 @Anupam - to update user feature status from Pending to active for reclaim contacts
    Public Static void updateUserFeature(Id conRecId){
        system.debug('Inside updateUserFeature method--->');
        List<IAM_Contact_Provisioning__c> updateListUserFeat = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> userFeatPendingList = [Select Id, IAM_Status__c,IAM_Application_Name__c,IAM_swregexpire__c,
                                                                 IAM_Qsolexpiration__c,IAM_Role__c,IAM_Contact__c,IAM_User__c,
                                                                 IAM_Cumpas_Modularity__c,IAM_Promotion__c,IAM_Subscription_Name__c,
                                                                 IAM_Remaining_Units__c,IAM_Remaining_Count_Formatted__c,IAM_NpbuDiagExpire__c
                                                                 from IAM_Contact_Provisioning__c
                                                                 where IAM_Contact__c =: conRecId AND IAM_Status__c =: System.Label.IAM_Status_Pending];
        
        if(userFeatPendingList.size() > 0){
            for(IAM_Contact_Provisioning__c conFeatRec : userFeatPendingList){
                conFeatRec.IAM_Status__c = 'Active';
                updateListUserFeat.add(conFeatRec);
            }
        }
        system.debug('updateListUserFeat--->'+updateListUserFeat);
        if(updateListUserFeat.size() > 0){
            update updateListUserFeat;
        }
		IAM_contactHelperClass.updateApplicationContact(updateListUserFeat);        
    }

}