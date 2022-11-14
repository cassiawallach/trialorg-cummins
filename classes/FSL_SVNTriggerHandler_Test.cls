@isTest
public class FSL_SVNTriggerHandler_Test {
    
    @TestSetup
    static void testData(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'testuserDivya@test.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'testuserDivya@test.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345', ERP__c = 'MOVEX');
        insert u;
        
        User currentUser=[select id from User where Id=:UserInfo.getUserId()];
        
        OperatingHours  operatinghour = new OperatingHours ();
        operatinghour.Name = 'new';
        operatinghour.TimeZone = 'America/Chicago';
        insert operatinghour;
        
        Test.startTest();
        
        ServiceTerritory servTerritory = new ServiceTerritory();
        servTerritory.name = 'TEST ST Mobile';
        servTerritory.OperatingHoursId=operatinghour.id;
        servTerritory.Location_Code__c='03250-02851';
        servTerritory.FSL_Service_Territory_Code__c = '02851';
        servTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        servTerritory.Territory__c = 'AUSTRALIA';
        servTerritory.IsActive=true;
        
        insert servTerritory;     
        
        Shop_Vehicle_Number__c shpVehiNum = new Shop_Vehicle_Number__c();
        shpVehiNum.Name='Test Record 1';
        shpVehiNum.User__c=currentUser.Id;
        shpVehiNum.Service_Territory__c=servTerritory.Id;
        insert shpVehiNum;
        
        Shop_Vehicle_Number__c shpVehiNum1 = new Shop_Vehicle_Number__c();
        shpVehiNum1.Name='Test Record 2';
        // shpVehiNum1.User__c=currentUser.Id;
        shpVehiNum1.User__c=u.Id;
        shpVehiNum1.Service_Territory__c=servTerritory.Id;
        insert shpVehiNum1;  
        /*try{
insert shpVehiNum1;  
}
catch(Exception e){
System.debug('exception'+e);
}*/
        Test.stopTest();
        
    }
    
    @isTest
    static void avoidDuplicateUserTest(){
        Test.startTest();
        Shop_Vehicle_Number__c shpVehicle  =[select id,Name,User__c,Service_Territory__c from Shop_Vehicle_Number__c limit 1];
        shpVehicle.Name='Test record 3';
        update shpVehicle;
        Test.stopTest();
        
    }
}