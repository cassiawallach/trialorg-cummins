@isTest 
Public class FSL_CSSP_googleAddressAutofill_Test {
     public static testmethod void testmethod1(){
        case cs1 = new case();
        cs1.Product_Hours__c = 2;
        cs1.Product_Mileage_Unit__c = 'km';
        cs1.Product_Mileage__c = 1211;
        cs1.Available_for_Service__c=datetime.now()+2;
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
        cs1.Location__c='test test Alaska United States 4545';
        insert cs1;
        String SearchText = 'test';
        String PlaceID = 'test';
        Test.StartTest();
              FSL_CSSP_googleAddressAutofill.getAddressDetailsbyId(cs1.id);
                FSL_CSSP_googleAddressAutofill.saveAddressDetailsbyId(cs1.id,cs1.Location__c);
                FSL_CSSP_googleAddressAutofill.getAddressSet(SearchText);
                FSL_CSSP_googleAddressAutofill.getAddressDetailsByPlaceId(PlaceID);
   
            Test.stopTest();
     }
     static testmethod void testmethod2(){
  
      //LocationSearch LocationSearchwrapper= new LocationSearch;
      FSL_CSSP_googleAddressAutofill.GeoLocation LocationSearchwrapper= new FSL_CSSP_googleAddressAutofill.GeoLocation();
      LocationSearchwrapper.Street='test';
      LocationSearchwrapper.PostalCode='test';
      LocationSearchwrapper.City='test';
      LocationSearchwrapper.State='test';
      LocationSearchwrapper.Country='test';

     }
}