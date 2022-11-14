public with sharing class IAM_CST_Contact_Updates{

    Public Static Void CheckUserStatus(set<id> conIds,map<id,String> oldUsername,map<id,String> newUsername){
        
        System.debug('Printing user details'+conIds);
        System.debug('Printing user details'+newUsername);
        System.debug('Printing user details'+oldUsername);
        
       
        callCSTUpdate(ConIds,oldUsername,newUsername);
       
    }
    
    @future(callout=true)
    Public static Void callCSTUpdate(set<id> conIds,map<id,String> oldUsername,map<id,String> newUsername){
    
    String oldUname='';
        String newUname='';
        String conId='';
     List<Contact> Con=[select id,phone,Username__c,firstName,LastName,email,IAM_Ext_Legacy_Uid__c,Account.IAM_Service_Provider_Code__c,IAM_Contact_Status__c from Contact where id=:conIds and IAM_Contact_Status__c='Active'];
        
     if(!con.isEmpty()){
         
          List<IAM_Contact_Provisioning__c> conAppCST=[select id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:con[0].id and IAM_Status__c='Active' and IAM_Application_Name__c='Cummins Service Training'];
          System.debug('Printing CST application'+conAppCST);
          if(!conAppCST.isEmpty()){
          System.debug('Printing applications'+con);
        If(oldUsername.ContainsKey(Con[0].id)){
            oldUname=oldUsername.get(Con[0].id);
        }
        
        if(newUsername.ContainsKey(Con[0].id)){
            newUname=newUsername.get(Con[0].id);
        }
        conId=con[0].Id;
        IAM_CSTUserOutboundHelper_Reclaim.CstOutboundCall(Con[0].FirstName,Con[0].LastName,Con[0].Email,Con[0].Phone,Con[0].Account.IAM_Service_Provider_Code__c,conid,oldUname,newUname); 
          
          
          }  
     }   
        
    
    }
}