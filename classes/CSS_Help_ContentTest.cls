@isTest
public class CSS_Help_ContentTest{
    
    public Static String UserLicence = 'Customer Community Plus';
    static testMethod void ContentHelp(){
       CSS_Help_Content contentHelp = new CSS_Help_Content();
       set<String> contentUserAdmin = new set<String>();
       Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
         User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US',  ProfileId = p1.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '04959-02065');
            insert u;
            
           String uLicence = [Select id,Profile.UserLicense.Name from User where Id=: u.id].Profile.UserLicense.Name;
           System.assertNotEquals(UserLicence,uLicence);
           contentUserAdmin.add(u.id);
           
    }
    
    static testMethod void ContentHelpNeg(){
        CSS_Help_Content contentHelp = new CSS_Help_Content();
       set<String> contentUserAdmin = new set<String>();
       Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Advanced']; 
       Account ac = new Account(name ='Guidanz Test Content') ;
       insert ac;
       
        Contact con = new Contact(LastName ='Guidanz',FirstName='Content',AccountId = ac.Id);
        insert con;
        
         User u = new User(Alias = 'Guidanz', Email='standarduserDealer@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Guidanz', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US',  ProfileId = p1.Id, 
        TimeZoneSidKey='America/Los_Angeles', ContactId = con.Id, UserName='UtilityTestUser4@testorg.com',User_Location__c = '02860-19134');
        
        insert u;
            
           String uLicence = [Select id,Profile.UserLicense.Name from User where Id=: u.id].Profile.UserLicense.Name;
           System.assertEquals(UserLicence,uLicence);
    }
}