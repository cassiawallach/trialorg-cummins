/*************************************************************************************
Name:  IAM_LDAP_Util_ReqParser
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It is used to form JSON request structure for LDAP create an update API call.
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                      DATE               DETAIL                                
1.0      Keerthy Gutumurthy        11/16/2018        INITIAL DEVELOPMENT
1.2      Shubhangi Sardar          27/04/2021        Get branch name from  IAM_DN_Value__c
**************************************************************************************
**************************************************************************************/
public without sharing class IAM_LDAP_Util_ReqParser {

    public static String IAM_LDAP_Util_ReqBody(Set<Id> conIds) {
        String JSONString;
        
        try {
            System.debug('Contact Ids in request Parser class'+conIds);
            List<Contact> conList = getConList(conIds);       
            System.debug('Printing Contact List'+conList);
            UserPayload lstWrapper = new UserPayload(conList);
            System.debug('Printing request wrapper'+lstWrapper);
            if(lstWrapper != null){
                JSONString = JSON.serialize(lstWrapper);
                System.debug('Printing serialized string '+JSONString);
            }
        } catch(Exception e){
            System.debug('Printing exception '+e);
            System.debug('Printing Stack trace String'+e.getStackTraceString());
            IAM_ErrorHandling.IAMerrorCapture('Processed Contact Ids - ' + conIds,
            Label.IAM_Identity_LDAP, e.getStackTraceString() + ' - '+ e.getMessage(),
            IAM_LDAP_Util_ReqParser.class.getName());
        }
        return JSONString;
    }

    /* Return list of Contacts for given Ids */
    private static List<Contact> getConList(Set<Id> conIds) {
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
                 , IAM_DN_value__c
                 , Account.CSS_DistributorCode__c
                 , Account.CSS_DealerCode__c
                 , Account.CSS_DBCode__c
                 , Account.CSS_FleetCode__c
                 , Account.IAM_ABO_Code_Formula__c
                 , Account.IAM_Service_Provider_Code__c
                 , Account.Type
              FROM Contact
             WHERE Id = :conIds
        ];
    }

    //to create/update user upload wrapper class
    public class UserPayload {
        public List<UserInfo> Userinfo{set;get;}
        public UserPayload(List<Contact> conts){
            Userinfo = new List<Userinfo>();
            for(contact c:conts){
                this.Userinfo.add(new Userinfo(c));
            }
        }
    }

    public class Userinfo{
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
        public string usertype {set;get;}
        public string branch {set;get;}
        public string workgroupid {set;get;}
        
        public Userinfo(Contact con){
            system.debug('calling the userinfo');
            this.cn = con.Name;
            this.mail = con.email;
            this.givenName = con.FirstName;
            this.uid = con.Username__c;
            this.sn = con.LastName;
            this.telephoneNumber = con.Phone;
            this.workgroupid = con.IAM_Work_Group_Id__c;         
            this.extlegacyuid = con.IAM_Ext_Legacy_Uid__c;
            this.Productgroupaccess = con.IAM_Product_Group_Access__c;
            this.DistributorCode = con.Account.CSS_DistributorCode__c;
            if(con.Account.Type == 'Dealer Account') {
                this.DealerCode = con.Account.IAM_Service_Provider_code__c;
            } else {
                this.DealerCode = '';
            }            
            if(con.Account.Type == 'Distributor Branch Account') {
                this.DistributorBranchCode = con.Account.CSS_DBCode__c;
            } else {
                this.DistributorBranchCode = '';
            }
            //Setting fleet Customer code depending upon the type of the account
            if(con.Account.Type == 'Fleet'|| con.Account.Type == 'CIHR') {
                this.fleetcode = con.Account.IAM_Service_Provider_code__c;
            }
            this.ABOCode = con.Account.IAM_ABO_Code_Formula__c;
            this.swregexpire = con.IAM_swregExpire__c;
            this.qsolexpiration = con.IAM_Qsolexpiration__c;
            this.branch = IAM_Utility.getBranchName(con.IAM_DN_Value__c);
            if(con.IAM_Contact_Status__c == Label.IAM_Status_Active && con.IAM_Internal__c == true
            && con.IAM_Legacy_User__c == true) {
                this.usertype = Label.IAM_Value_Internal;
            } else if((con.IAM_Contact_Status__c == Label.IAM_Status_Active
            || con.IAM_Contact_Status__c == Label.IAM_Inactive_Label) && con.IAM_Internal__c == false
            && con.IAM_Legacy_User__c == false) {
                //In this case user will be purly of external user.
                //After reclaim for extenal users we need to update the legacy flag to false.
                this.usertype = Label.IAM_Value_External;
            } else if((con.IAM_Contact_Status__c == Label.IAM_Status_Active
            || con.IAM_Contact_Status__c == Label.IAM_Inactive_Label
            || con.IAM_Contact_Status__c == Label.IAM_Reclaim)
            && con.IAM_Internal__c == false && con.IAM_Legacy_User__c == true){
                //In this case user will be ready to reclaim but not yet reached their phase.
                this.usertype = Label.IAM_Value_Legacy;
            }
        }
    }
}