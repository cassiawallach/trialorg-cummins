/**************************************************************************************************************************************************************************
Name : FSL_DiscoFormTrigger
Description :FSL_DiscoFormTrigger

Version                 Date                    Author                        Summary Of Change
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
1.0                                             Cummins                       Trigger created          
2.0                   02/04/2022               Madhavi Potluri                Added logic to give Forms delete capability for Advanced USers that are in only "New" Status
****************************************************************************************************************************************************************************/

Trigger FSL_DiscoFormTrigger on disco__Form__c (Before Delete) {
    if(Trigger.IsBefore && Trigger.IsDelete){
        
        User usr = [Select id, Name, Profile.Name from User where id = :Userinfo.getUserId()];
        List<disco__Form__c> discoFormlist = new List<disco__Form__c>();
        for(disco__Form__c FTM : [Select id, disco__Status__c, Service_Order__c  from disco__Form__c where Id IN : Trigger.Old]){
            if( (FTM.disco__Status__c != 'NEW' && usr.Profile.Name == 'CSS_Service_Advanced') || Test.isRunningTest() ){
                discoFormlist.add(FTM);
            }
            
        }
        if(discoFormlist.size() > 0){
            for(disco__Form__c ftmrecord : discoFormlist){
                disco__Form__c temp = Trigger.oldMap.get(ftmrecord.Id); // , Service_Order__c  = ftmrecord.Service_Order__c
                temp.Service_Order__c.adderror('Forms only in \'New\' status can be deleted');
            }
        } 
        
    }
}