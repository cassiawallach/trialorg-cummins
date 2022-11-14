/**************************************************************************
Name:  IAM_GuiAssign_ConProv_Queueable
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class assign the new Partner Community user created to all
Guidanz and non-Guidanz User Feature record associated to
contact.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -     Anupam Adhikari              30/12/2021        INITIAL DEVELOPMENT 
******************************************************************************/
public class IAM_GuiAssign_ConProv_Queueable Implements Queueable{
    
    Private Map<Id, IAM_Contact_Provisioning__c> mapGuidanzConprov;
    Private Map<Id, List<IAM_Contact_Provisioning__c>> mapOtherConprov;
    Private Map<Id, Id> mapConIdNewUser;
    //Private List<IAM_Contact_Provisioning__c> nonCusCommUserProv;
    
    public IAM_GuiAssign_ConProv_Queueable(Map<Id, IAM_Contact_Provisioning__c> mapGuidanzConprov, Map<Id, List<IAM_Contact_Provisioning__c>> mapOtherConprov, Map<Id, Id> mapConIdNewUser){
        this.mapGuidanzConprov=mapGuidanzConprov;
        this.mapOtherConprov=mapOtherConprov;
        this.mapConIdNewUser=mapConIdNewUser;
        //this.nonCusCommUserProv=nonCusCommUserProv;
    }
    
    public void execute(QueueableContext Context){
        List<IAM_Contact_Provisioning__c> guidanzUserFeatList = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> allUserFeatList = new List<IAM_Contact_Provisioning__c>();
        //List<IAM_Contact_Provisioning__c> userProvListGuidanz = new List<IAM_Contact_Provisioning__c>();
        try{
            system.debug('mapGuidanzConprov in IAM_GuiAssign_ConProv_Queueable class--->'+mapGuidanzConprov);
            system.debug('mapOtherConprov in IAM_GuiAssign_ConProv_Queueable class--->'+mapOtherConprov);
            if(!mapGuidanzConprov.isEmpty() && !mapConIdNewUser.isEmpty()){
                updatePartneFlagCon(mapConIdNewUser);
                //guidanzUserFeatList = newUserAssignConProv(mapGuidanzConprov,mapConIdNewUser,mapOtherConprov);
                allUserFeatList = newUserAssignConProv(mapGuidanzConprov,mapConIdNewUser,mapOtherConprov);
                for(IAM_Contact_Provisioning__c ccp : allUserFeatList){
                    if(ccp.IAM_Application_Name__c == 'Guidanz'){
                        guidanzUserFeatList.add(ccp); 
                    }
                }
            }
            // this queueable class will assign Guidanz, EVL Dealer Adv, EVL Dealer Technician PS to users based
            // on the role of Guidanz User Feature record.
            system.debug('guidanzUserFeatList in IAM_GuiAssign_ConProv_Queueable class--->'+guidanzUserFeatList); 
            if(guidanzUserFeatList.size() > 0){
                if(!Test.isRunningTest()){
                    //assignGuidanzPSToUser(guiUserFeatList);
                    ID jobID = System.enqueueJob(new IAM_Guidanz_PSAssign_Queueable(guidanzUserFeatList,mapConIdNewUser,allUserFeatList));
                    System.debug('Printing Secondary JOB ID'+jobID);
                }               
            }
                     
        }catch(exception e){
            System.debug('Printing exception'+e.getMessage());
            System.debug('Printing exception Stack Trace String'+e.getStackTraceString());
            IAM_ErrorHandling.IAMerrorCapture('', '', 
            e.getStackTraceString() + ' : ' + e.getMessage(),
            IAM_GuiAssign_ConProv_Queueable.class.getName());
        }       
    }
    
    public static List<IAM_Contact_Provisioning__c> newUserAssignConProv(Map<Id, IAM_Contact_Provisioning__c> mapGuidanzConprov, Map<Id, Id> mapConIdNewUser, Map<Id, List<IAM_Contact_Provisioning__c>> mapOtherConprov){
        List<IAM_Contact_Provisioning__c> guiConProvList = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> updatedUserFeatList = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> guidanzUserFeatList = new List<IAM_Contact_Provisioning__c>();
        //List<IAM_Contact_Provisioning__c> userFeatUpdFlagList = new List<IAM_Contact_Provisioning__c>();
        Set<Id> conProvIdSet = new Set<Id>();
        //this loop will update new Partner user in the IAM_USER__C field of Guidanz Contact Prov
        for(Id contId : mapGuidanzConprov.keySet()){
            if(mapConIdNewUser.containsKey(contId) && mapConIdNewUser.get(contId) != null){
                IAM_Contact_Provisioning__c userFeat = new IAM_Contact_Provisioning__c();
                userFeat.Id = mapGuidanzConprov.get(contId).Id;
                userFeat.IAM_User__c = mapConIdNewUser.get(contId);
                userFeat.IAM_Guidanz_Skip_Validation__c = True;
                guiConProvList.add(userFeat);
            }
        }
        //this loop will update new Partner user in the IAM_USER__C field of all other Contact Prov
        for(Id conId : mapConIdNewUser.keySet()){
            if(mapOtherConprov.containsKey(conId) && mapOtherConprov.get(conId) != null){
                for(IAM_Contact_Provisioning__c conP : mapOtherConprov.get(conId)){
                    conP.IAM_User__c = mapConIdNewUser.get(conId);
                    conP.IAM_Guidanz_Skip_Validation__c = True;
                    guiConProvList.add(conP);
                }
            }
        }
        system.debug('guiConProvList--->'+guiConProvList);
        if(guiConProvList.size() > 0){
            Database.SaveResult[] srList = Database.update(guiConProvList, false);
            System.debug('#### srList of User Feature User field update - '+srList);
            for(Integer i = 0; i < srList.size(); i++){
                if(srList.get(i).isSuccess()){
                   conProvIdSet.add(srList.get(i).Id);                        
                }else if(!srList.get(i).isSuccess()){
                    for(Database.Error err : srList.get(i).getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('User Feature fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
        if(conProvIdSet.size() > 0){
            updatedUserFeatList = [Select Id, IAM_User__c, IAM_Contact__c,IAM_Role__c,IAM_Guidanz_Skip_Validation__c,
                                   IAM_Application_Name__c
                                   FROM IAM_Contact_Provisioning__c
                              WHERE Id IN : conProvIdSet AND IAM_Status__c = 'Active'];
        }           
        return updatedUserFeatList;
        
    }
    
    public static void updatePartneFlagCon(Map<Id, Id> mapConIdNewUser){
        List<Contact> conPartnerListUpd = new List<Contact>();
        List<Contact> conPartnerList = [Select Id, IAM_Partner_User_Record__c FROM Contact
                                       WHERE Id IN : mapConIdNewUser.keySet()];
        if(conPartnerList.size() > 0){
            for(Contact c : conPartnerList){
                c.IAM_Partner_User_Record__c = False;
                conPartnerListUpd.add(c);
            }
        }
        if(conPartnerListUpd.size() > 0){
            update conPartnerListUpd;
        }
    }          
}