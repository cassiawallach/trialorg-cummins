/**
* Name : dbu_AddressSelectionCtrlTest 
* Description: Test Class for Auto Address Completion
* @Date 05/05/2022
*/ 
@isTest
public class dbu_AddressSelectionCtrl_Test {
    @testSetup 
    static void SettingUpTestData() {
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='dbu_google_places';
        conDetails.End_Point__c= 'https://maps.googleapis.com/maps/api/place/details/json';
        conDetails.Key__c= 'AIzaSyB--yU7qdi26kYfozz5bK2-W9wlqUNWiTE';
        conDetails.Logging__c = 'https://maps.googleapis.com/maps/api/geocode/json';
        conDetails.Resource__c = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
        insert conDetails;
    }

    public static testMethod void getAddressDetailsFromPlaceIdTest(){
        Test.setMock(HttpCalloutMock.class, new dbu_AddressCalloutMockTest());
        String strResults = dbu_AddressSelectionCtrl.getAddressDetailsFromPlaceId('ChIJM7fNVZZbwokRvakIrEgV7WA', '404 Franklin St, San Francisco, CA , USA');
        System.assert(strResults != null, true);
    }
    
    public static testMethod void getAddressAutoCompleteTest(){
        String input='';
        String countryCode='91';
        String strResults = dbu_AddressSelectionCtrl.getAddressAutoComplete(input,countryCode);
        System.assert(strResults != null, true);
    }
    
    public static testMethod void getAddressDetailsFromPlaceIdOldAPITest(){
        Test.setMock(HttpCalloutMock.class, new dbu_AddressCalloutMockTest());
        String strResults = dbu_AddressSelectionCtrl.getAddressDetailsFromPlaceIdOldAPI('404 Franklin St, San Francisco, CA , USA');
        System.assert(strResults != null, true);
    }
}