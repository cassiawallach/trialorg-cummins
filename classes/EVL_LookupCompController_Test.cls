/**********************************************************************
Name:EVL_LookupCompController_Test
Copyright © 2020  Cummins
======================================================
======================================================
Purpose: Test Class for EVL_LookupCompController.                                                          
======================================================
======================================================
History                                                            
VERSION  	AUTHOR            			DATE                DETAIL                                 
1.0 	 	Krishnamoorthi N			06/26/2020			INITIAL DEVELOPMENT 
2.0         Diksha Rajpurohit           08/25/2022        	SOQL INJECTION SAFE
***********************************************************************/
@isTest
public class EVL_LookupCompController_Test {
    static testMethod void myTest() {
    	
        Account a=new Account();
        a.name='name';
        a.CSS_DistributorCode__c='test';
        a.IAM_Service_Provider_Code__c='P12345';
        a.Type='Dealer Account';
        a.Region__c = 'US and Canada';
        a.CMI_Account_Status__c = 'Active';
        a.IAM_Service_Provider_Code__c = '562551';
		a.BMS_Enabled__c = true;
        insert a;
        
        CSS_UserLocation__c  usloc = new CSS_UserLocation__c();
        usloc.UserId__c=userInfo.getUserId();
        usloc.Location_code__c=a.Location__c;
        usloc.isActive__c=true;
        usloc.AccountId__c = a.Id;
        usloc.isPrimary__c = true;
        usloc.Name = 'krishna';
        insert usloc ;
        
        Asset AssRec = new Asset();
        
        AssRec.Name = '79464646';
        insert AssRec;
        
        test.startTest();
        EVL_LookupCompController.fetchLookUpValues('AssetNumber','name', 'Account'); 
        EVL_LookupCompController.fetchLookUpValues('UnitNumber','krishna', 'Asset');
        EVL_LookupCompController.fetchUser();
        EVL_LookupCompController.saveServiceOrder(a.Id,'testCon',AssRec.Id,'test','testing','te','12','555','km');
        test.stopTest();
        
    }
}