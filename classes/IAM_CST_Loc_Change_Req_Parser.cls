public with sharing class IAM_CST_Loc_Change_Req_Parser {
    public Static String newCSTUserLocationChangePayload(Set<id> conids){
        String JSONString='';
        
        List<Contact> conList=[SELECT id
                                     ,IAM_Internal__c
                                     ,IAM_Promotion__c
                                     ,IAM_Ext_Legacy_Uid__c
                                     ,Firstname
                                     ,lastname
                                     ,email
                                     ,phone
                                     ,Username__c
                                     ,Account.IAM_Service_Provider_Code__c
                                     FROM Contact
                                     WHERE id=:conids];
        List<UserPayload> lstWrapper = new List<UserPayload>();
        for(Contact con:conList){
            lstWrapper.add(new Userpayload(con));
        }
           System.debug('Printing request wrapper'+lstWrapper);
           if(lstWrapper!=null){
               JSONString = JSON.serialize(lstWrapper);
               System.debug('Printing serialized string '+JSONString);
           }
        
        return JSONString;
           
       }
       
       public class UserPayload{
           public string username{set;get;}
           public string sp_code{set;get;}
           public string current_username{set;get;}

           public UserPayload(Contact con){
           
               system.debug('calling the userinfo');
               
                this.username=con.Username__c;
                this.sp_code=con.Account.IAM_Service_Provider_Code__c;
                this.current_username=UserInfo.getusername();  
               }
   }
}