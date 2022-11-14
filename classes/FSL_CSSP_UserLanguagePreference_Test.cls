@isTest
public class FSL_CSSP_UserLanguagePreference_Test {
    @isTest static void pos1() {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'test', Email='standarduser@testorg.com.gdnz', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.gdnz',
            State = 'Nevada', City = 'Naperville', Country = 'United States', 
            street = '2526 looking', PostalCode = '12345');

        Insert u;
        
        test.startTest();
        FSL_CSSP_UserLanguagePreference.updateUser(u.Id,'en_US');
        test.stopTest();
    }
}