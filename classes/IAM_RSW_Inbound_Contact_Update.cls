public class IAM_RSW_Inbound_Contact_Update Implements Queueable{
    
    Public String statusFromIntegration;
    Public id contactId;
    Public String usernameFromIntegration;
    Public id userAccessAndFeatureId;
    
    Public IAM_RSW_Inbound_Contact_Update(String statusFromIntegration,id contactId,String usernameFromIntegration,id userAccessAndFeatureId){
        this.statusFromIntegration=statusFromIntegration;
        this.contactId=contactId;
        this.usernameFromIntegration=usernameFromIntegration;
        this.userAccessAndFeatureId=userAccessAndFeatureId;
    }
    
    Public Void execute(QueueableContext context){
        List<Contact> rswContact = IAM_RSW_Inbound.getContactList(usernameFromIntegration);
        if(!rswContact.isEmpty()){
            //Updating Contact
            Set<id> updateId= new Set<id>();
            updateId.add(rswContact[0].id);
            List<User> usr= [select id,isActive from user where Contact.id=:rswContact[0].id];
            rswContact[0].IAM_from_Registration__c=false;
            if(statusFromIntegration == Label.IAM_Status_Active) {
                rswContact[0].IAM_Contact_Status__c = Label.IAM_Status_Active;
            } else if(statusFromIntegration == Label.IAM_RSW_Status_Cancelled) {
                List<IAM_Contact_Provisioning__c> conProList = getContactProvisioning(rswContact[0].Id);
                System.debug('#### conProList - '+conProList);
                if(conProList.isEmpty()) {
                    String updatedUsername = String.valueOfGmt(System.now()).replaceAll('[-:\\s+]', '')
                        + '.' + rswContact[0].Username__c ;
                    System.debug('#### Now updatedUsername '+ updatedUsername);
                    rswContact[0].IAM_Contact_Status__c = Label.IAM_Rejected_Label;
                    rswContact[0].Username__c = updatedUsername;
                }                                
            }
            System.debug('#### rswContact before - '+rswContact);
            Update rswContact;
            System.debug('#### rswContact after - '+rswContact);
            //end of Contact update
            if(rswContact[0].IAM_Contact_Owner__c != null){
                //if(usr[0].isActive==false){
                //perform Update or call user update function 
                System.debug('Printing User update function');
                IAM_contactHelperClass.updateUserdetails(updateId,false,null);
                IAM_RSW_CreateUser.UpdateUser(updateId,userAccessAndFeatureId);
                //}
            } 
            else if(!usr.isempty()){
                if(usr[0].isActive==false){
                    System.debug('Printing User update function');
                    IAM_contactHelperClass.updateUserdetails(updateId,false,null);
                    IAM_RSW_CreateUser.UpdateUser(updateId,userAccessAndFeatureId);
                }
            }
            else {
                //call a class which will create user
                //IAM_RSW_CreateUser.CreateUser(updateId,rswContact[0].Contact_Provisionings__r[0].id);
                if(!test.isRunningTest()){
                    id JobId=System.enqueueJob(new IAM_RSW_CreateUser(updateId,userAccessAndFeatureId));
                    System.debug('before making LDAP UTIL call activeConInsert.... '+ rswContact);
                    IAM_LDAP_Util.invokeapexcallout(rswContact,'Insert');   
                }  
            }           
        }
    }
    
    /* Return list of inactive Contact Provisioning for given Contact */
    public static List<IAM_Contact_Provisioning__c> getContactProvisioning(Id conId) {
        return [
            SELECT Id
            , IAM_Account_Application__r.Id
            , IAM_Status__c
            , IAM_Contact__r.Id
            FROM IAM_Contact_Provisioning__c
            WHERE IAM_Contact__c = :conId
            AND IAM_Status__c != :Label.IAM_Status_Inactive
        ];
    }
    
}