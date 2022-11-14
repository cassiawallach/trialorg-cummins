@isTest 
Public class FSL_CL_ServiceTerritory_Test {
    
    public static testmethod void getServiceTerritorydetails_Test() {
        // ServiceTerritory ST = FSLTestDataSetupCls.createServiceTerritory();
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory();
        sT.Name = 'ST001';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '01234-12345';
        sT.FSL_Service_Territory_Code__c = '12345';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='qt727@cummins.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='qt727@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345');
        insert u;
        
        System.runAs(u) {
            Test.StartTest();
            FSL_CL_ServiceTerritory.getServiceTerritorydetails();
            FSL_CL_ServiceTerritory.getOwnerPrimaryServiceTerritoryCheck(u.Id);
            Test.stopTest();
        }
    }
}