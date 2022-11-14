@isTest
public class CG_CL_MyAccount_Test {
    Public static  TestMethod void MyAccountMethod1()
    {
        /*Account acc = new Account();
           acc.name='Rtest';
           acc.CSS_DistributorCode__c='562701';
           acc.IAM_Service_Provider_Code__c='562551';
            insert acc;*/
        UserRole empRole = [Select Id From UserRole Where Name = 'DFSE-CUMMINS CENTRAL' Limit 1];
        //UserRole empRole = [Select Id From UserRole Where Name = 'DFSE-CSSNA- Central Region' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User objUser1 =[SELECT id, DefaultCurrencyIsoCode, CurrencyIsoCode From User Where id =: userInfo.getUserId() limit 1];
        /*new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com', User_Location__c='123456',DefaultCurrencyIsoCode='USD',CurrencyIsoCode='USD');
       insert objUser1;*/
       List<CSS_UserLocation__c> JobLocations1 =new List<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation1 = new CSS_UserLocation__c(isActive__c=true,isServiceJobs__c=true,isPrimary__c=true,UserId__c=objUser1.Id,Location_code__c='LDAP');
        insert userLocation1;
        JobLocations1.add(userLocation1);
        List<CSS_UserLocation__c> ClaimLocations1=new List<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation2 = new CSS_UserLocation__c(isActive__c=true,isClaims__c = true,isPrimary__c=true,UserId__c=objUser1.Id,Location_code__c='ARF');
        insert userLocation2;
        ClaimLocations1.add(userLocation2);
        list<CurrencyType> Currencies1=new list<CurrencyType>();
        CurrencyType cur=new CurrencyType();
        cur.IsoCode='USD';
            cur.ConversionRate=10.0;
        cur.IsActive=true;
      //update cur;
      Currencies1.add(cur); 
        CG_CL_MyAccount myacc=new CG_CL_MyAccount();
        myacc.JobLocations=JobLocations1;
        myacc.ClaimLocations=ClaimLocations1;
        myacc.selectedValue='USD';
        myacc.selCurrency='USD';
        myacc.Currencies=Currencies1;
        List<SelectOption> opt= myacc.getOptions();
        myacc.OnChangeSelectedCurrency();
        myacc.SaveAndContinue();
        CG_CL_MyAccount.activeLocationsWrapper wrapclass = new CG_CL_MyAccount.activeLocationsWrapper('03520','Boyer truck',true);
        
        
        
    }
 Public static  TestMethod void CatchMethod1()
 {
       CurrencyType cur=null;
     CG_CL_MyAccount myacc=new CG_CL_MyAccount();
   
     myacc.Currencies=null;
     myacc.getOptions();
         }
}