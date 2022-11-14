/**************************************************************************
Name:  IAM_Guidanz_PSAssign_Queueable
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class assign Guidanz and EVL(Advanced or Technician) PS 
based on role for Guidanz User Feature & Access record
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -     Anupam Adhikari              03/01/2022        INITIAL DEVELOPMENT 
******************************************************************************/
public class IAM_Guidanz_PSAssign_Queueable Implements Queueable{
    
    Private List<IAM_Contact_Provisioning__c> guiUserFeatList;
    Private Map<Id, Id> mapConIdNewUser;
    Private List<IAM_Contact_Provisioning__c> allUserFeatList;
    
    public IAM_Guidanz_PSAssign_Queueable(List<IAM_Contact_Provisioning__c> guiUserFeatList,Map<Id, Id> mapConIdNewUser,List<IAM_Contact_Provisioning__c> allUserFeatList){
        this.guiUserFeatList = guiUserFeatList;
        this.mapConIdNewUser = mapConIdNewUser;
        this.allUserFeatList = allUserFeatList;
    }
    //this method will assign Guidanz and EVL(Advanced or Technician) PS based on role for Guidanz User Feature & Access record
    public void execute(QueueableContext Context){
        try{
            Set<Id> userIdSetAdv = new Set<Id>();
            Set<Id> userIdSetTech = new Set<Id>();
            List<PermissionSet> permissionSetListAdv = new List<PermissionSet>();
            List<PermissionSet> permissionSetListTech = new List<PermissionSet>();
            List<PermissionSetAssignment> existPSAssignListAdvnced = new List<PermissionSetAssignment>();
            List<PermissionSetAssignment> existPSAssignListTech = new List<PermissionSetAssignment>();
            Set<Id> setPSIdGuiAdv = new Set<Id>();
            Set<Id> setPSIdGuiTech = new Set<Id>();
            List<PermissionSetAssignment> psAssignListNewAdvTech = new List<PermissionSetAssignment>();
            List<PermissionSetAssignment> oldPSAList = new List<PermissionSetAssignment>();
            
            for(IAM_Contact_Provisioning__c userProv : guiUserFeatList){
                if(userProv.IAM_Role__c == 'Advanced'){
                    userIdSetAdv.add(userProv.IAM_User__c);
                }else{
                    userIdSetTech.add(userProv.IAM_User__c);
                }
            }
            system.debug('userIdSetAdv--->'+userIdSetAdv);
            system.debug('userIdSetTech--->'+userIdSetTech);
            List<PermissionSet> permissionSetList = [SELECT Id, Label, Name, ProfileId
                                                     FROM PermissionSet
                                                     WHERE Label = :Label.IAM_Guidanz
                                                     OR Label = :Label.IAM_GuidanzPSet_EVLDealerAdv
                                                     OR Label = :Label.IAM_GuidanzPSet_EVLDealerTechnician
                                                     OR Label = :Label.IAM_GuidanzPS_EVLClassicAdv
                                                     OR Label = :Label.IAM_GuidanzPS_EVLClassicTechnician];
            for(PermissionSet perSet : permissionSetList){
                if(perSet.Label == System.Label.IAM_Guidanz || perSet.Label == System.Label.IAM_GuidanzPSet_EVLDealerAdv || perSet.Label == System.Label.IAM_GuidanzPS_EVLClassicAdv){
                    permissionSetListAdv.add(perSet);
                    setPSIdGuiAdv.add(perSet.Id);
                }
                if(perSet.Label == System.Label.IAM_Guidanz || perSet.Label == System.Label.IAM_GuidanzPSet_EVLDealerTechnician || perSet.Label == System.Label.IAM_GuidanzPS_EVLClassicTechnician){
                    permissionSetListTech.add(perSet);
                    setPSIdGuiTech.add(perSet.Id);
                }
            }
            system.debug('permissionSetListAdv--->'+permissionSetListAdv);
            system.debug('permissionSetListTech--->'+permissionSetListTech);
            if(userIdSetAdv.size() > 0){
                existPSAssignListAdvnced = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment
                 							WHERE AssigneeId IN :userIdSetAdv AND PermissionSetId IN : setPSIdGuiAdv];
                system.debug('existPSAssignListAdvnced--->'+existPSAssignListAdvnced);
                if(existPSAssignListAdvnced.size() > 0){
                    for(PermissionSetAssignment psa : existPSAssignListAdvnced) {
                        psa.Id = null;
                        oldPSAList.add(psa);
                    }
                }
            }
            system.debug('oldPSAList--->'+oldPSAList);
            if(userIdSetTech.size() > 0){
                existPSAssignListTech = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment
                 					     WHERE AssigneeId IN :userIdSetTech AND PermissionSetId IN : setPSIdGuiTech];
                if(existPSAssignListTech.size() > 0){
                    for(PermissionSetAssignment ps : existPSAssignListTech) {
                        ps.Id = null;
                        oldPSAList.add(ps);
                    }
                }
            }
            //assign Guidanz & EVL Dealer Adv PS to new user who has Advanced role for Guidanz User Feature record
            if(permissionSetListAdv.size() > 0 && userIdSetAdv.size() > 0){
                for(Id usr : userIdSetAdv){
                    for(PermissionSet psGuiAdv : permissionSetListAdv){
                        PermissionSetAssignment psa = new PermissionSetAssignment();
                        psa.PermissionSetId = psGuiAdv.Id;
                        psa.AssigneeId = usr;
                        psAssignListNewAdvTech.add(psa);
                    }
                }
            }
            system.debug('psAssignListNewAdvTech--->'+psAssignListNewAdvTech);
            //assign Guidanz & EVL Dealer Technician PS to new user not having 'Advanced' role for Guidanz User Feature record
            if(permissionSetListTech.size() > 0 && userIdSetTech.size() > 0){
                for(Id u : userIdSetTech){
                    for(PermissionSet psGuiTech : permissionSetListTech){
                        PermissionSetAssignment ps = new PermissionSetAssignment();
                        ps.PermissionSetId = psGuiTech.Id;
                        ps.AssigneeId = u;
                        psAssignListNewAdvTech.add(ps);
                    }
                }
            }
            system.debug('psAssignListNewAdvTech--->'+psAssignListNewAdvTech);
            psAssignListNewAdvTech.addAll(oldPSAList);
            system.debug('psAssignListNewAdvTech--->'+psAssignListNewAdvTech);
            //insert Guidanz, EVL Dealer ADV, EVL Dealer Technician PS to new users 
            if(!psAssignListNewAdvTech.isEmpty()) {
                Database.SaveResult[] srList = Database.insert(psAssignListNewAdvTech, false);
                System.debug('#### srList - '+srList);
            }
            if(mapConIdNewUser.size() > 0){
                sendPasswordEmail(mapConIdNewUser);
            }
            if(!Test.isRunningTest()){
                if(allUserFeatList.size() > 0){
                    //this queueable class will send psw set email to new users created. 
                    ID jobID = System.enqueueJob(new IAM_Guidanz_validationFlag_Queueable(allUserFeatList));
                    System.debug('Printing Secondary JOB ID'+jobID);
                }               
            }
        }catch(exception e){
            if(mapConIdNewUser.size() > 0){
                sendPasswordEmail(mapConIdNewUser);
            }
            IAM_ErrorHandling.IAMerrorCapture('', '', 
                                              e.getStackTraceString() + ' : ' + e.getMessage(),
                                              IAM_Guidanz_PSAssign_Queueable.class.getName());
        } 
    }
    
    public static void sendPasswordEmail(Map<Id, Id> mapConIdNewUser){
        Set<Id> newUserIdSet = new Set<Id>();
        for(Id conId : mapConIdNewUser.keySet()){
            newUserIdSet.add(mapConIdNewUser.get(conId));
        }
        if(newUserIdSet.size() > 0){
            for(Id usr : newUserIdSet) {
                if(!test.isRunningTest()){
                    system.resetPasswordWithEmailTemplate(usr, true,'IAM_Set_password');                   
                }
                /*else{
system.resetPasswordWithEmailTemplate(usr, true,'IAM_Set_password'); 
}*/               
            }        
        }
    }
}