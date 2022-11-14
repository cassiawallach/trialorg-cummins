//Test Class for the class OSM_SW_AccountPermMatrixHelper
// 22/07/21 MAR-1861 Subbu K
/********************************************************/
@isTest
public class OSM_SW_AccountPermissionMatrix_Ctrl_Test {

    
    static testMethod void AccountPermissionMatrix(){
        // Account Data insert
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        insert testAccount;
        
        
        //OSM_Account_Permission_Matrix__c Data insert
        OSM_Account_Permission_Matrix__c testMatrix = new OSM_Account_Permission_Matrix__c();
        testMatrix.Account__c = testAccount.Id;
        insert testMatrix;
        
        OSM_SW_PermissionMatrixDao.getPermissionsFromAccount(testAccount.Id);
        ccrz.cc_CallContext.initRemoteContext(new ccrz.cc_RemoteActionContext());
        OSM_SW_AccountPermissionMatrix_Ctrl APMC = new OSM_SW_AccountPermissionMatrix_Ctrl();
        ccrz.cc_CallContext.currAccountId = testAccount.Id;
        OSM_SW_AccountPermissionMatrix_Ctrl APMC1 = new OSM_SW_AccountPermissionMatrix_Ctrl();
        OSM_SW_AccountPermMatrixHelper APMH = new OSM_SW_AccountPermMatrixHelper();
       // OSM_SW_AccountPermMatrixHelper.getAccountPermissions(testAccount.id);
        
    }
}