public without sharing class OSM_SW_PermissionMatrixDao {
    public static OSM_Account_Permission_Matrix__c getPermissionsFromAccount(Id accountID){
        OSM_Account_Permission_Matrix__c matrix = null; 
        List<OSM_Account_Permission_Matrix__c> permMatrixs = [SELECT PO_invoice_bill_to_HQ__c,Contacts_Required__c,Send_Email_to_Branch__c,Show_price_for_branch_accounts__c,Account__r.Type,Account__r.Parent.name FROM OSM_Account_Permission_Matrix__c WHERE Account__c=:accountID];
        if(permMatrixs != null && !permMatrixs.isEmpty()){
            matrix = permMatrixs[0];
        }
        return matrix;
    }
     public static Account getAccountFromId(Id accountId){
        Account retAccount = null;
        List<Account> accounts = new List<Account>();
        accounts = [SELECT Id, Is_Internal_Account__c,CSS_DistributorCode__c,Is_Training_Account__c,Type,Parent.Id,BillingCountry FROM Account WHERE id=:accountId];
        if(accounts!=null && !accounts.isEmpty()){
            return accounts[0];
        }
        return retAccount;

    }


}