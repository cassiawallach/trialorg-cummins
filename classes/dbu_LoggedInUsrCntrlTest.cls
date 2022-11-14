@isTest
public class dbu_LoggedInUsrCntrlTest {
    
    private static string ACCOUNT_REGION 		=	'US and Canada';
    private static string TIMEZONE 				=	'America/Panama';
    private static string EMAIL_ENCODING 		=	'ISO-8859-1';
    private static string LOCALE				=	'English(United States)';
    private static string LANGUAGE				=	'English';
    private static string BILLING_COUNTRY		=	'United States';
    private static string EMAIL					=	'testuser@gmail.com';    
    private static string COMPANY_NAME			=	'test user company';   
    private static string PHONE					=	'83689376493';   
    private static string STATUS				=	'Active';
    private static string FIRSTNAME				=	'Test';
    private static string LASTNAME				=	'Customer';
    private static string NICKNAME				=	'NickCustomer';
    private static string EMAIL_ENCODING_USER	=	'UTF-8';
    private static string USERNAME              =   '38788ullmann@cmiuser.com.fulluat'; 
    private static Date START_DATE				=	Date.parse('6/20/2019');
    private static Date END_DATE				=	Date.parse('12/31/2099'); 
    
    
    
    static testMethod void testfetchCCAddressShipping() {
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;  
        
        System.runAs(admin){
            
            
            Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
            
            
            Account acc 							=	dbu_FactoryDataTest.createIAMAccount('Identity Individual Users12yTest', AccountRecordType);
            insert acc;
            
            String orgId = UserInfo.getOrganizationId();  
            String dateString =   
                String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;
            
            Contact con = new Contact(LastName = LASTNAME, FirstName = FIRSTNAME ,AccountId = acc.id);  
            con.Username__c = uniqueName + '@test' + orgId + '.org'; 
            insert con;
            
            Id profileId = [Select Id From Profile Where Name='IAM User'].id;
                        
            
            user usr                                =   new User();
            usr.FirstName                           =   FIRSTNAME;
            usr.LastName                            =   LASTNAME;
            usr.Alias                               =   'Tsr';
            usr.CompanyName                         =   COMPANY_NAME;
            usr.Username                            =   string.valueof(Math.random())+USERNAME;
            usr.Email                               =   'xyz'+EMAIL;
            usr.Country                             =   BILLING_COUNTRY;
            usr.CommunityNickname                   =   NICKNAME;
            usr.TimeZoneSidKey                      =   TIMEZONE;
            usr.LocaleSidKey                        =   'en_US';
            usr.ProfileId                           =   profileId;
            usr.ContactId                           =   con.id;
            usr.Phone                               =   PHONE;
            usr.EmailEncodingKey                    =   EMAIL_ENCODING_USER;
            usr.CSS_User_MultiLocValues__c          =   'null-P';
            usr.UserGroup__c                        =   'EDS_User';
            usr.IAM_UID__c                          =   EMAIL;
            usr.IAM_Abocode__c                      =   '1';
            usr.IAM_Final_Approver__c               =   'N';
            usr.IAM_WorkGroup_id__c                 =   'null-P';
            usr.tableauId__c                        =   LASTNAME;
            usr.activeEquipmentDuration__c          =   '21';
            usr.sessionTimeout__c                   =   '86400000';
            usr.LanguageLocaleKey					=	'en_US';
            usr.PortalRole 							= 'Manager';
            usr.IsActive = true;
            usr.ccrz__CC_CurrencyCode__c 			=	'USD';
            insert usr;     
            system.runAs(usr){
                
                List<String> lststr = new List<String>();
                List<ccrz__E_ContactAddr__c> conAddressList = new List<ccrz__E_ContactAddr__c>();
                ccrz__E_ContactAddr__c objAddress1 = new ccrz__E_ContactAddr__c();  
                objAddress1.ccrz__CompanyName__c = 'TestCompany';
                objAddress1.dbu_Contact__c = usr.ContactId;
                objAddress1.ccrz__ShippingComments__c = 'Shipping Comments';
                conAddressList.add(objAddress1);
                
                ccrz__E_ContactAddr__c objAddress2 = new ccrz__E_ContactAddr__c();  
                objAddress2.ccrz__CompanyName__c = 'TestCompany';
                objAddress2.dbu_Contact__c = usr.ContactId;
                objAddress2.ccrz__ShippingComments__c = 'Billing Comments';
                conAddressList.add(objAddress2);
                insert conAddressList;
                
                
                lststr.add(conAddressList[0].ccrz__CompanyName__c);
                
                Test.startTest();
                dbu_LoggedInUsrCntrl.fetchCCAddressShipping();
                dbu_LoggedInUsrCntrl.getContactIDFrLoginUsr();
                dbu_LoggedInUsrCntrl.shippingAddressData();
                dbu_LoggedInUsrCntrl.fetchCCAddressBilling();
                dbu_LoggedInUsrCntrl.billingAddressData(lststr);
                dbu_LoggedInUsrCntrl.fetchCCAddressShippingAndBilling();
                
                Test.stopTest();
            }
        }
    }
}