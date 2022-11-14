public class OSM_SW_BoltInformation_Helper
{
    public static void updateBoltInfo(List<Account> accList)
    {
        List<Account> lstAccountDistributorHead = new List<Account>();
        List<String> accountDistributorCodes = new List<String>();
        List<Account> updateAccountList = new List<Account>();
        Map<String, Account> mapAccount = new Map<String, Account>();
        
        for(Account objAcc : accList)
        {
            if((objAcc.Type == 'Distributor Branch Account' || objAcc.Type == 'Distributor Branch') && objAcc.CSS_DistributorCode__c != null && objAcc.CSS_DistributorCode__c != '')
            {
                lstAccountDistributorHead.add(objAcc);
                accountDistributorCodes.add(objAcc.CSS_DistributorCode__c);
            }
        }
        
        if(accountDistributorCodes != null && accountDistributorCodes.size() >0)
        {
            List<Account> lstAccount = new List<Account>();
            lstAccount = [Select Id,BOLT_Account_Number__c,Bolt_Credit_Hold__c,Bolt_Customer_Account_Status__c,Bolt_BC_Code__c, Bolt_Payment_Terms__c , IAM_Service_Provider_Code__c from Account where IAM_Service_Provider_Code__c IN: accountDistributorCodes and Type = 'Distributor Account'];
            
            
            for(Account objAc : lstAccount)
            {
                mapAccount.put(objAc.IAM_Service_Provider_Code__c, objAc);
            }
        }
        
        if(mapAccount != null && mapAccount.size() > 0)
        {
            for(Account objAcc : lstAccountDistributorHead)
            {
                if(mapAccount.containsKey(objAcc.CSS_DistributorCode__c) && mapAccount.get(objAcc.CSS_DistributorCode__c).BOLT_Account_Number__c != null && mapAccount.get(objAcc.CSS_DistributorCode__c).BOLT_Account_Number__c != '')
                {
                    objAcc.BOLT_Account_Number__c = mapAccount.get(objAcc.CSS_DistributorCode__c).BOLT_Account_Number__c;
                    objAcc.Bolt_Credit_Hold__c = mapAccount.get(objAcc.CSS_DistributorCode__c).Bolt_Credit_Hold__c;
                    objAcc.Bolt_Customer_Account_Status__c = mapAccount.get(objAcc.CSS_DistributorCode__c).Bolt_Customer_Account_Status__c;
                    objAcc.Bolt_BC_Code__c = mapAccount.get(objAcc.CSS_DistributorCode__c).Bolt_BC_Code__c;
                }
            }
        }
    }
}