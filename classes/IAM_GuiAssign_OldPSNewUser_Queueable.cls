/**************************************************************************
Name:  IAM_GuiAssign_OldPSNewUser_Queueable
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class assign old PS of the old deactivated user to the 
new Partner Community user created
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -     Anupam Adhikari              28/12/2021        INITIAL DEVELOPMENT 
*******************************************************************************/
public class IAM_GuiAssign_OldPSNewUser_Queueable Implements Queueable{
    
    Private Map<Id, Id> mapConIdNewUser;
    Private Map<Id, Id> mapContUserId;
    Private Map<Id, List<String>> mapUserIdPsId;
    Private Map<Id, IAM_Contact_Provisioning__c> mapGuidanzConFeat;
    Private Map<Id, List<IAM_Contact_Provisioning__c>> mapOtherConFeat;
    
    public IAM_GuiAssign_OldPSNewUser_Queueable(Map<Id, Id> mapConIdNewUser, Map<Id, Id> mapContUserId, Map<Id, List<String>> mapUserIdPsId, Map<Id, IAM_Contact_Provisioning__c> mapGuidanzConFeat, Map<Id, List<IAM_Contact_Provisioning__c>> mapOtherConFeat){
        this.mapConIdNewUser=mapConIdNewUser;
        this.mapContUserId=mapContUserId;
        this.mapUserIdPsId=mapUserIdPsId;
        this.mapGuidanzConFeat=mapGuidanzConFeat;
        this.mapOtherConFeat=mapOtherConFeat;
    }
    //Method to assign permission sets of old user to new user created.
    public void execute(QueueableContext Context){
        system.debug('inside oldpsnewuser queueable class');
        //List<IAM_Contact_Provisioning__c> nonCusCommUserProv = new List<IAM_Contact_Provisioning__c>();
        Map<Id, Id> mapOldUserConId = new Map<Id, Id>();
        Map<Id, List<String>> mapConIdPSValue = new Map<Id, List<String>>();
        List<PermissionSetAssignment> psAssignmentList = new List<PermissionSetAssignment>();
        try{
            if(!mapContUserId.isEmpty()){
                for(Id conId : mapContUserId.keyset()){
                    if(mapConIdNewUser.containsKey(conId)){
                        if(!mapOldUserConId.containsKey(conId)){
                            mapOldUserConId.put(mapContUserId.get(conId), conId);//this map will hold old user Id as key and contact records Id as value
                        }
                    }
                }
                system.debug('mapOldUserConId--->'+mapOldUserConId);
                if(!mapOldUserConId.isEmpty() && !mapUserIdPsId.isEmpty() && !mapConIdNewUser.isEmpty()){
                    for(Id userId : mapOldUserConId.keyset()){
                        if(mapUserIdPsId.containsKey(userId) && mapUserIdPsId.get(userId) != null){
                            for(String psValue : mapUserIdPsId.get(userId)){
                                if(!mapConIdPSValue.containsKey(mapOldUserConId.get(userId))){
                                    mapConIdPSValue.put(mapOldUserConId.get(userId), New List<String>{psValue});
                                }else{
                                    mapConIdPSValue.get(mapOldUserConId.get(userId)).add(psValue);// map of Con Id as key and PS assignments of old user as value
                                }
                            }
                        }
                    }
                    system.debug('mapConIdPSValue--->'+mapConIdPSValue);
                    for(Id cId : mapConIdNewUser.keySet()){
                        if(mapConIdPSValue.containskey(cId) && mapConIdPSValue.get(cId) != null){
                            for(String perSet : mapConIdPSValue.get(cId)){
                                PermissionSetAssignment psa = new PermissionSetAssignment();
                                psa.AssigneeId = mapConIdNewUser.get(cId);
                                psa.PermissionSetId = perSet;
                                psAssignmentList.add(psa);
                            }
                        }
                    }
                }
                system.debug('psAssignmentList--->'+psAssignmentList);
                if(!psAssignmentList.isEmpty()) {
                    Database.SaveResult[] srList = Database.insert(psAssignmentList, false);
                    System.debug('#### srList of PS assignment - '+srList);
                }
            }
            if(!Test.isRunningTest()){
                //call queueable class to assign new user record to all contact prov records including Guidanz
                ID jobID = System.enqueueJob(new IAM_GuiAssign_ConProv_Queueable(mapGuidanzConFeat,mapOtherConFeat,mapConIdNewUser));
                System.debug('Printing Secondary JOB ID'+jobID);
            }           
        }catch(exception e){
            System.debug('Printing exception'+e.getMessage());
            System.debug('Printing exception Stack Trace String'+e.getStackTraceString());
            IAM_ErrorHandling.IAMerrorCapture('', '', 
                                              e.getStackTraceString() + ' : ' + e.getMessage(),
                                              IAM_GuiAssign_OldPSNewUser_Queueable.class.getName());
        }
    }

}