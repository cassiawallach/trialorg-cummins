/**********************************************************************
Name: FSL_CSSP_getServiceLocations_Test
Copyright Â© 2021  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This class is used for getting the service locations for customer portal search
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
2.0         Jesse Allen             2/22/2022       FBI-222; adding comment
********************************************************************************************************************/
@isTest 
Public class FSL_CSSP_getServiceLocations_Test {
   public static testmethod void getcurrentaddress_Test(){
   
   FSL_CSSP_getServiceLocations.LocationSearch LocationSearchwrapper= new FSL_CSSP_getServiceLocations.LocationSearch();
   LocationSearchwrapper.businessDay='test';
   LocationSearchwrapper.businessHrs='test';
   LocationSearchwrapper.storeLocationCode='AX';
   LocationSearchwrapper.stateCode='ER';
   
    FSL_CSSP_getServiceLocations.GeoLocationSearch GeoLocationSearchwrapper= new FSL_CSSP_getServiceLocations.GeoLocationSearch();
    GeoLocationSearchwrapper.Phone='1234567890';
    FSL_CSSP_getServiceLocations.Location  LocationWrapper = new FSL_CSSP_getServiceLocations.Location();
    LocationWrapper.description='TEST';
    LocationWrapper.isLocationMatched=TRUE;
    FSL_CSSP_getServiceLocations.GeoLocation  GeoLocationWrapper =new FSL_CSSP_getServiceLocations.GeoLocation();
   //LocationSearchwrapper.name = 'Test Wrapper';
   
      Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
         
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = accRecId;
        acc.FSL_Source_ERP__c='BMS';
        insert acc;
        
        Contact con= new Contact();
        con.FirstName='test1';
        con.LastName='test';
        con.AccountId=acc.id;
        con.Email = 'test@cummins.com';
        con.Language_Preferences__c = 'French';
        con.MobilePhone ='9999999999';
        con.Email_Notification_Frequency__c='Nightly';
        
        con.IAM_Contact_Status__c = 'Active'; 
        con.Language_Preferences__c = 'English';
        con.CMI_IsActive__c = true;
       
        con.Send_Nightly_Communication__c= true;
        con.MailingStreet='test';
        con.MailingPostalcode='98000';
        con.MailingCity='Miri';
        con.MailingState='Sarawak';
        con.MailingCountry='Malaysia';
        insert con;
        /*GeoLocation geoInfo = new GeoLocation();
            geoInfo.Street = con.MailingStreet;
            geoInfo.PostalCode = con.MailingPostalcode;
            geoInfo.City = con.MailingCity;
            geoInfo.State = con.MailingState;
            geoInfo.Country = con.MailingCountry;*/
        
        OperatingHours  oh = new OperatingHours();
        oh.Name = 'new1';
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
        sT.latitude = -34;
        sT.longitude= -58;
        sT.Street='test';
        sT.postalcode='98000';
        sT.City='Miri';
        sT.State='Sarawak';
        sT.Country='Malaysia';
        sT.Phone__c='+6085657517';
        sT.description='scqw';
        Insert sT;
        
        case cs1 = new case();
        cs1.Product_Hours__c = 2;
        cs1.Product_Mileage_Unit__c = 'km';
        cs1.Product_Mileage__c = 1211;
        cs1.Available_for_Service__c=datetime.now()+2;
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
        cs1.Location__c='test test Alaska United States 4545';
        insert cs1;
        

        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='qt727@cummins.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='qt727@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345');
        insert u;
        string road='xyz';
        List<string> loc= cs1.Location__c.Split(',');
            Test.StartTest();
              FSL_CSSP_getServiceLocations.getcurrentaddress(sT.latitude,sT.longitude);
               FSL_CSSP_getServiceLocations.getLocPointes(sT.postalcode,sT.City,sT.Country,road,sT.state,sT.description);
               FSL_CSSP_getServiceLocations.getalllocations(sT.latitude,sT.longitude);
               FSL_CSSP_getServiceLocations.getallContacts(con.id);
               FSL_CSSP_getServiceLocations.updateServiceReq(cs1.id,loc);
            Test.stopTest();
   }

}