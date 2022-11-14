public with sharing class OSM_SW_AccountDao {
   public static List<Account> getAccountsHierarchy(Id parentAccountID)
    {

        List<Account> accounts = [
            SELECT
                Id,
                Name,
                Type,
                AccountNumber,
                BillingStreet,
                BillingCity,
                BillingState,
                BillingPostalCode,
                BillingCountry,
                ShippingStreet,
                ShippingCity,
                ShippingState,
                ShippingPostalCode,
                ShippingCountry,
                ccrz__E_AccountGroup__c,
               IAM_Service_Provider_Code__c
            FROM
                Account
            WHERE
            // (ParentId =:parentAccountID AND Type = 'Distributor Branch Account') OR (Id=:parentAccountID AND Type = 'Distributor Account')
            (Id =: parentAccountID OR ParentId =: parentAccountID)
            //AND (AccountSource = 'WWSPS' OR AccountSource = 'Web' OR AccountSource = 'QSOL')
            //  AND Type = 'Distributor Branch Account')
            //  OR (Id=: parentAccountID AND Type = 'Distributor Account')
            // OR (ParentId =: parentAccountID AND Type = 'Fleet' AND AccountSource = 'WWSPS')
            // OR (ParentId=: parentAccountID AND Type = 'Dealer Account' AND AccountSource = 'WWSPS')
            // order by Name asc
        ];

        return accounts;


    }

    public static Account getDistributorAdminAccountRelateData(id accId){
        List<Account> accs = [SELECT id,Type, parentId,Parent.parentId FROM Account WHERE id=:accId ];
        if(accs.isEmpty()){
            return null;
        }else{
            return accs[0];
        }

    }

    public static List<Account> getDistributorAccountsHierarchy(Id accountID)
    {

        List<Account> accounts = [
            SELECT
                Id,
                Name,
                Type,
                AccountNumber,
                BillingStreet,
                BillingCity,
                BillingState,
                BillingPostalCode,
                BillingCountry,
                ShippingStreet,
                ShippingCity,
                ShippingState,
                ShippingPostalCode,
                ShippingCountry,
                ccrz__E_AccountGroup__c,
               IAM_Service_Provider_Code__c
            FROM
                Account
            WHERE
            ((ParentId =: accountID OR parent.parentId=:accountID) AND  (Type = 'Distributor Branch Account' OR Type = 'Distributor Account'))
            order by Name asc
        ];

        return accounts;


    }

    public static List<Account> getAListOfAccount(Set<String> accIds){
        List<Account> accounts =[
            SELECT
                Id,
                Name,
                AccountNumber,
                BillingStreet,
                BillingCity,
                BillingState,
                BillingPostalCode,
                BillingCountry,
                ShippingStreet,
                ShippingCity,
                ShippingState,
                ShippingPostalCode,
                ShippingCountry,
                ccrz__E_AccountGroup__c
            FROM 
                Account
            WHERE
            Id IN: accIds
        ];
        return accounts;
    }
    public Static Account getParentAccount(Id currentAccountId){
        List<Account> accs = [SELECT Id,parentId,Type,EBU_Channel_of_Distribution__c,PSBU_Channel_of_Distribution__c,PO_invoice_bill_to_HQ__c,CSS_DistributorCode__c,IAM_Service_Provider_Code__c FROM Account WHERE Id =:currentAccountId];
        if(!accs.isEmpty()){
            return accs[0];
        }
        return null;

    }
}