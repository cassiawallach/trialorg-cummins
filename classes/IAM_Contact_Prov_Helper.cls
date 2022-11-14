Public Class IAM_Contact_Prov_Helper{

    //In this method we will call this method only for active users who has login access.
    
    Public Static Void UpdateToActive(Set<id> ids){
        List<IAM_Contact_Provisioning__c> ConProv=[Select id,IAM_Active_Contact_Provisioning__c,IAM_Contact__c,IAM_Status__c,IAM_Application_Name__c,IAM_User__c from IAM_Contact_Provisioning__c where id=:ids];
        Set<id> ConIds=new Set<id>();
        
        if(!ConProv.isEmpty()){
            for(IAM_Contact_Provisioning__c c:ConProv){
               
               ConIds.add(c.IAM_Contact__c);   
            }
            
            List<user> usr=[Select id,Name,username,contactId from user where ContactId=:ConIds and isActive=True];
            System.debug('Printing user list'+usr);
            Map<id,User> userMap=new Map<id,User>();
            
            if(!usr.isEmpty()){
                  for(user u:usr){
                      userMap.Put(u.ContactId,u);
                  }
            }
            List<IAM_Contact_Provisioning__c> nonRSWListconprov = new List<IAM_Contact_Provisioning__c>();
            for(IAM_Contact_Provisioning__c cn:ConProv){
                cn.IAM_Active_Contact_Provisioning__c=cn.IAM_Contact__c;
                system.debug('Printing is key Present or not'+userMap.ContainsKey(cn.IAM_Contact__c));
                if(!userMap.isEmpty()){
                if(userMap.ContainsKey(cn.IAM_Contact__c)){
                   cn.IAM_User__c= userMap.get(cn.IAM_Contact__c).id;
                }
              }
                if(cn.IAM_Application_Name__c !='Rapid Serve Web'){
                    nonRSWListconprov.add(cn);
                }
            }
            Update ConProv;
            IAM_contactHelperClass.updateApplicationContact(ConProv);
            if(!nonRSWListconprov.isempty())
            IAM_Assign_Application_Permissionset.AssignApplication(nonRSWListconprov);
        }
    }
    
    Public Static Void CreationOfUser(List<Contact> lstCont){
        
        System.debug('Printing Contact Ids'+lstCont.Size());
        Set<id> ConIds=new Set<id>();
        
        if(!lstCont.isEmpty()){
            String userCreation='';
            if(!Test.isRunningTest()){ 
           		userCreation= IAM_CreateUser.CreateUser(lstCont); 
            }else{
                userCreation='OK';
            }
           System.debug('USer creation is'+userCreation);
           if(userCreation=='OK') {
               for(Contact c:lstCont){
                   ConIds.add(c.id);
               }
               System.debug('Printing Contact Ids'+ConIds);
               List<IAM_Contact_Provisioning__c> ConProv=[Select id,IAM_Contact__c,IAM_User__c,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:ConIds];
               Set<id> ProvID= new Set<id>();
               /*System.debug('Printing Cont provisionings'+ConProv);
               List<User> usr=[Select id,ContactId from user where ContactId=:ConIds]; 
               System.debug('Printing User records'+usr);
               Map<id,User> userMap=new Map<id,User>();
               for(user u:usr){
                   userMap.put(u.ContactId,u);
               } 
               System.debug('user Map'+userMap);*/
               if(!ConProv.isEmpty()){
                   for(IAM_Contact_Provisioning__c c:ConProv){
                       
                      ProvId.add(c.id); 
                   }
                   
                 if(!ProvID.isEmpty()){
                       UpdateToActive(ProvId);  
                 }
                   
               }  
           }
        }
    }
    
}