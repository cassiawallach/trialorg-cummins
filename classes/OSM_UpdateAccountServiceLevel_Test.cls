//Added for 1236
@isTest 
public class OSM_UpdateAccountServiceLevel_Test 
{
	public static Account createAccount()
    {
        Account acc = new Account();
        
        acc.Name = 'Test Account';
        acc.CMI_Account_Status__c = 'Active';
        acc.CMI_CDA_Status__c = 'New Customer Request';
        acc.CMI_Region__c = 'North America';
        acc.CSS_Language__c = 'English';
        
        insert acc;
        
        return acc;
    }
    
    @isTest
    public static void updateAccountServiceLevelTrigger_test()
    {
        Account acc = createAccount();
        List<CSS_Accreditation__c> accreditationList = new List<CSS_Accreditation__c>();
        
        CSS_Accreditation__c accre = new CSS_Accreditation__c();
        accre.Name = 'Test';
        accre.Account__c = acc.ID;
        accre.Service_Level__c = 'Parts Only';
        accre.SP_CODE__c = 'test';
        accreditationList.add(accre);
        
        acc.IAM_Service_Provider_Code__c = accre.SP_CODE__c+'';
        update acc;
        insert accreditationList;
        
        accre.Service_Level__c = 'Full Service';
        
        update accreditationList;
        
    }
    
    @isTest
    public static void updateAccountServiceLevelManually_test()
    {
        Account acc = createAccount();
        
        List<CSS_Accreditation__c> accreditationList = new List<CSS_Accreditation__c>();
        
        CSS_Accreditation__c accre = new CSS_Accreditation__c();
        accre.Name = 'Test';
        accre.Account__c = acc.ID;
        accre.Service_Level__c = 'Parts Only';
        
        accreditationList.add(accre);
        
        insert accreditationList;
        
        OSM_UpdateAccountServiceLevel_Helper.updateAllAccountServiceLevelsManually();
        OSM_UpdateAccountServiceLevel_Helper.updateAllAccountServiceLevelsManually();
    }
}