/*************************************************************************************
Name:  IAM_LDAP_Util_ReqParser_Reclaim
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It is a parser class to create a user in LDAP. Called from Reclaim flow
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Karthik Raj Golakaram     09/02/2020        INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar          27/04/2021        LDAP Sync Issue Fix
**************************************************************************************
**************************************************************************************/

public without Sharing class IAM_LDAP_Util_ReqParser_Reclaim {

   public static String IAM_LDAP_Util_ReqBody_Reclaim(String username, String legacyID, String email,
   Id conIds) {
        
        String JSONString;
        try{
            System.debug('Contact Ids in request Parser class'+conIds);
            List<Contact> conList = getContactList(conIds);
            System.debug('Printing Contact List'+conList);
            UserPayload lstWrapper = new UserPayload(username, legacyId, email, conList);
            System.debug('Printing request wrapper from Reclaim LDAP Service'+lstWrapper);
            if(lstWrapper != null){
                JSONString = JSON.serialize(lstWrapper);
                System.debug('Printing serialized string from Reclaim LDAP Service '+JSONString);
            }
        } catch(Exception e) {
            System.debug('Printing exception e'+e.getStackTraceString());
            System.debug('Printing Exception e'+e.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(JSONString, Label.IAM_Identity_LDAP, 
            e.getStackTraceString() + ' - ' + e.getMessage(), 
            IAM_LDAP_Util_ReqParser_Reclaim.class.getName());
        }
        return JSONString;
    }

    /* to create/update user upload wrapper class */
    public class UserPayload {
        public List<UserInfo> Userinfo {set;get;}
        public UserPayload(String username, String legacyId, String email, List<Contact> contactList){
            Userinfo = new List<Userinfo>();
            for(contact con : contactList){
                this.Userinfo.add(new Userinfo(username, LegacyId, email, con));
            }
        }
    }

    /* Request Wrapper */
    public class Userinfo {
        public string cn {set;get;}
        public string mail {set;get;}
        public string givenName {set;get;}
        public string uid {set;get;}
        public string sn {set;get;}
        public string telephoneNumber {set;get;}
        public string extlegacyuid {set;get;}
        public string DistributorCode {set;get;}
        public string DealerCode {set;get;}
        public string DistributorBranchCode {set;get;}
        public string fleetcode {set;get;}
        public string ABOCode {set;get;}
        public string Productgroupaccess {set;get;}
        public string swregexpire {set;get;}
        public string qsolexpiration {set;get;}
        public string branch {set;get;}
        public string usertype {set;get;}
        public string workgroupid {set;get;}
        
        public Userinfo(String username, String LegacyId, String email, Contact con){
            system.debug('calling the userinfo');
            this.cn = con.Name;
            this.mail = email;
            this.givenName = con.FirstName;
            this.uid = username;
            this.sn = con.LastName;
            this.telephoneNumber = con.Phone;
            this.workgroupid = con.IAM_Work_Group_Id__c;            
            this.extlegacyuid = LegacyId;
            this.Productgroupaccess = con.IAM_Product_Group_Access__c;
            this.DistributorCode = con.Account.CSS_DistributorCode__c;
            if(con.Account.Type =='Dealer Account') {
                this.DealerCode = con.Account.IAM_Service_Provider_code__c;
            } else {
                this.DealerCode = '';
            }            
            if(con.Account.Type == 'Distributor Branch Account') {
                this.DistributorBranchCode = con.Account.CSS_DBCode__c;
            } else {
                this.DistributorBranchCode = '';
            }
            /* Setting fleet Customer code depending upon the type of the account */
            if(con.Account.Type == 'Fleet' || con.Account.Type == 'CIHR') {
                this.fleetcode = con.Account.IAM_Service_Provider_code__c;
            }
            this.ABOCode = con.Account.IAM_ABO_Code_Formula__c;
            this.swregexpire = con.IAM_swregExpire__c;
            this.qsolexpiration = con.IAM_Qsolexpiration__c;            
            /* since it is being called during reclaim we can default the values to external user
            * and branch as external. */            
            this.usertype = Label.IAM_Value_External;
            this.branch = Label.IAM_Value_External;
        }
    }

    /* Return Contact List */
    public static List<Contact> getContactList(Id contactId) {
        return [
            SELECT Id
                 , Name
                 , IAM_Contact_Status__c
                 , IAM_Internal__c
                 , LastName
                 , IAM_Legacy_User__c
                 , IAM_Work_Group_Id__c
                 , IAM_swregexpire__c
                 , IAM_Qsolexpiration__c
                 , CreatedDate
                 , LastModifiedDate
                 , Username__c
                 , Email
                 , FirstName
                 , Phone
                 , IAM_Applications__c
                 , IAM_Ext_Legacy_Uid__c
                 , IAM_Product_Group_Access__c
                 , Account.CSS_DistributorCode__c
                 , Account.CSS_DealerCode__c
                 , Account.CSS_DBCode__c
                 , Account.CSS_FleetCode__c
                 , Account.IAM_ABO_Code_Formula__c
                 , Account.IAM_Service_Provider_Code__c
                 , Account.Type
              FROM Contact
             WHERE Id = :contactId
        ];
    }
}