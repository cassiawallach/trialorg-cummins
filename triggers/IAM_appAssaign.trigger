/*trigger to update user id field on the application record before insert.then only process builder will kick in.
need to update contact application groups field when ever an application is added to contact after insert of application.
After update of apllication status we need to make modifications to application groups on contact.*/

trigger IAM_appAssaign on IAM_Contact_Provisioning__c (after insert,after update,before insert) {
}
/*{
 
 List<IAM_Contact_Provisioning__c> newapps=new List<IAM_Contact_Provisioning__c>();//Variable to store list of newly created applications
 List<IAM_Contact_Provisioning__c> updateApps= new List<IAM_Contact_Provisioning__c>();//Variable to store updated apps.
 List<user> usr=new List<user>();
 
 //define a set too store unique contact ids from the list of applications
 set<id> cids=new set<id>();
     
 if(Trigger.isInsert|| Trigger.isUpdate){
 
  for(IAM_Contact_Provisioning__c apps:Trigger.new){
         if(apps.IAM_Application_Name__c!=null&&apps.IAM_Contact__c!=null){
             System.debug('Trigger line to insert new records to list');
             newapps.add(apps);
             cids.add(apps.IAM_Contact__c);
         }
     }
 }
 
 System.debug('Printing new apps'+newapps);
 System.debug('Printing contact ids'+cids);
 if(trigger.isbefore&&trigger.isinsert){
 //perform the logic to update the user id on the application record.     
     //query on the user object to get user records with the new apps contact ID
     
     usr=[Select id,firstname,LastName,Username,isActive,Contactid,Contact.Accountid,Contact.IAM_Contact_Status__c from user where Contact.id=:cids and isActive=True];
     System.debug('Printng all the users got in the query'+usr);
     
     //looping through list to update the user id value.
     if(!usr.isEmpty()){
         for(user u:usr ){
             for(IAM_Contact_Provisioning__c p:newapps){
             System.debug('Printing contact and user contact id'+u.contactid+''+p.IAM_Contact__c);
             
                 if(u.Contactid==p.IAM_Contact__c)
                 p.IAM_User__c=u.id;
             }
         }
     }
     
 }  
 
 
 //
 if((trigger.isInsert || trigger.isUpdate) && Trigger.isAfter) {
  set<id> setConIds = new set<id> ();
  set<id> setAppIds= new set<id>();
  Set<id> setConAppIdArcher=new Set<id>();
  Set<id> setAppIdArcher=new Set<id>();
  string applicationName;
  string roleName;
  List<String> lstAppRoles = new List<String>();
  for(IAM_Contact_Provisioning__c idm : trigger.new) {
     if(idm.IAM_Application_Name__c !=null && idm.IAM_Contact__c !=null && idm.IAM_Role__c !=null && idm.IAM_Status__c == 'Active') {
       setConIds.add(idm.IAM_Contact__c);
       
       applicationName = idm.IAM_Application_Name__c;
       roleName = idm.IAM_Role__c;
       lstAppRoles.add(roleName+'*'+applicationName);
       system.debug('enter in Application name'+lstAppRoles);
     }
     
     //Need to make sure record has user ID before we add ids to set
     if(idm.IAM_Application_Name__c !=null && idm.IAM_Contact__c !=null && idm.IAM_Role__c !=null && idm.IAM_Status__c == 'Active'&&idm.IAM_User__c!=null){
     setAppIds.add(idm.id);
     }
     
     //Code to hanlde Archer requirement on user provision request handler
                    if(idm.IAM_Application_Name__c =='Archer' && idm.IAM_Contact__c != null && idm.IAM_Role__c != null && idm.IAM_Status__c == System.Label.IAM_Active ){
                         System.debug('Printing inside application Archer');
                        setConAppIdArcher.add(idm.IAM_Contact__c);
                        setAppIdArcher.add(idm.id);
                    }
  }
  
   if(setConIds.size() >0 && !setConIds.isEmpty()) {
     //IAM_contactHelperClass.updateApplicationContact(setConIds,lstAppRoles);
   }
     
     if(setAppIds.size()>0 && !setAppIds.isEmpty()){
     //below method is a future method and will update user with App specific Fields.
     IAM_Assign_Application_Permissionset.updateUserAppAttributes(setAppIds);
     }
     
     
       System.debug('Printing application id '+setAppIdArcher+'Printg conAppID'+setConAppIdArcher);
                if(!setAppIdArcher.isEmpty()&&!setConAppIdArcher.isEmpty()){
                System.debug('Calling Archer user create class');
                    if(!Test.isRunningTest()){
                        IAM_Archer_User_Creation.createUser(setConAppIdArcher,setAppIdArcher);
                    }
                }
 } //End Logic

  //logic  to update application group on the contact level with appropriate application names
  if((trigger.isInsert||trigger.isUpdate)&&Trigger.isAfter&&CSS_checkRecursive.runOnce()){
      //call the class to update cn values irrespective of the user status.but should not assign permission set. Permission set
       // assaignment should happen only during the process builder.
       //IDM_Assign_Application_Permissionset.APPgroups(newapps);
  
  }
 
 
 if(trigger.isUpdate&& trigger.isAfter){
    List<Contact> con=new List<Contact>();
    Set<id> conids=new Set<id>();
    
    for(IAM_Contact_Provisioning__c apps:Trigger.new){
        if(apps.IAM_Application_Name__c=='BOX External Partners'&&apps.IAM_Status__c=='Active'){
            conids.add(apps.IAM_Contact__c);
        }
    }    
    
    if(!conids.isEmpty()){
         con=[select id,FirstName,LastName,email,Account.Name,CMI_Contact_Type__c from Contact where id=:conids];
    }
    
    if(!con.isEmpty()){
        IAM_CreateUser.CreateUser(con);
    }     
 }

}*/