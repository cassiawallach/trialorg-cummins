public without sharing class OSM_SW_AccountPermMatrixHelper {
    public static UserPermissions getAccountPermissions(id accountId,Boolean isOnBehalf,Contact currContact,Id effAccountId) {
        UserPermissions perm = new UserPermissions();
        OSM_Account_Permission_Matrix__c matrix = null;
        Boolean distOnBehalf = false;
        Boolean resellerAdmin=false;
        String strUserType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
        Account currEffAccount = OSM_SW_PermissionMatrixDao.getAccountFromId(effAccountId);
        if((strUserType == Label.OSM_Distributor_Admin_UserType) || (strUserType == Label.OSM_Sales_Admin_UserType) || Test.isRunningTest()){
            List<Contact> contacts = new List<Contact>();
            //Account currEffAccount = OSM_SW_PermissionMatrixDao.getAccountFromId(effAccountId);
            ccrz.ccLog.log('OSM_SW_AccountPermMatrixHelper1');
            contacts = [Select ID, IAM_Contact_Owner__c,OSM_Distributor_Admin_Last_Sel__c,OSM_Distributor_Admin_Last_Sel_acc__c,AccountId from Contact where IAM_Contact_Owner__c =:UserInfo.getUserId() LIMIT 1];
            ccrz.ccLog.log('OSM_SW_AccountPermMatrixHelper contacts ' + contacts);
            ccrz.ccLog.log('OSM_SW_AccountPermMatrixHelper currAccount ' + currEffAccount);
            if(!contacts.isEmpty()){
                if(currEffAccount != null && currEffAccount.Type == 'Distributor Branch Account'){
                    ccrz.ccLog.log('OSM_SW_AccountPermMatrixHelper2');
                    perm.isDistrBranch = true;
                }
                if(contacts[0].id != currContact.Id){
                    distOnBehalf=true;
                }
            }
           
           if(strUserType == Label.OSM_Distributor_Admin_UserType){
                perm.isDistAdmin = true;
            }else if(strUserType == Label.OSM_Sales_Admin_UserType){
                perm.isSalesAdmin = true;
            }
            
        } 
        if(strUserType == Label.OSM_Support_Admin_UserType){
            perm.isSupportAdmin = true;
        }
       if(strUserType == Label.OSM_SSOEM_Admin_UserType){
            perm.SsoemUsers = true;
       }
       if(strUserType == Label.OSM_Reseller_Admin_UserType){
        perm.resellerAdmin = true;
        }

       if(!label.OSM_North_America_Country.contains(currEffAccount.BillingCountry) && !label.OSM_PO_Distributor_List.contains(currEffAccount.CSS_DistributorCode__c) )
       {
        perm.GOMSUser=true;
       }

       if(currEffAccount != null && (currEffAccount.Is_Internal_Account__c || currEffAccount.Is_Training_Account__c))
         perm.isInternalOrTrainingAccount = true;
        matrix = OSM_SW_PermissionMatrixDao.getPermissionsFromAccount(accountId);
        ccrz.ccLog.log('OSM_SW_AccountPermMatrixHelper3');                                                
        if(matrix != null){
            perm.updatePermissions(matrix);
        }
        if(isOnBehalf || distOnBehalf || strUserType == Label.OSM_Training_Admin_UserType){
            perm.isOnBehalf = true;
        }
        perm.isdistdirectlogin=isOnBehalf;
        
        
        return perm;
 

    }
    public class UserPermissions {

        public Boolean sendEmail {get; set;}
        public Boolean showPriceForBranch {get; set;}
        public Boolean seeContacts {get; set;}
        public Boolean isDistAdmin {get; set;}
        public Boolean isOnBehalf {get; set;}
        public Boolean isDistrBranch {get; set;}
        public Boolean SsoemUsers {get; set;}
        public Boolean isSalesAdmin {get; set;}
        public Boolean isSupportAdmin {get; set;}
        public Boolean isInternalOrTrainingAccount {get; set;}
        public Boolean GOMSUser {get; set;}
        public Boolean resellerAdmin {get; set;}
        public Boolean POInvoiceBillToHQ{get;set;}
        public Boolean isdistdirectlogin{get;set;}
        public Boolean distOnBehalf{get;set;}

        public UserPermissions() {
            this.sendEmail = false;
            this.showPriceForBranch = false;
            this.seeContacts = false;
            this.isDistAdmin = false;
            this.isOnBehalf =false;
            this.isDistrBranch = false;
            this.SsoemUsers = false;  
            this.isSalesAdmin = false; 
            this.isSupportAdmin = false;
            this.isInternalOrTrainingAccount = false;
            this.GOMSUser=false;
            this.resellerAdmin=false;
            this.POInvoiceBillToHQ=false;
            this.isdistdirectlogin=false;
            this.distOnBehalf=false;
            
        }
        public void updatePermissions(OSM_Account_Permission_Matrix__c permMatrix){
            this.sendEmail = permMatrix.Send_Email_to_Branch__c;
            this.showPriceForBranch = permMatrix.Show_price_for_branch_accounts__c;
            this.seeContacts = permMatrix.Contacts_Required__c;
            this.POInvoiceBillToHQ=permMatrix.PO_invoice_bill_to_HQ__c;
        }
    }
        
}