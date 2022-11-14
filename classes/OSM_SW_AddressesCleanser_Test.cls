//Updated on 04/04/2022
//Updated by Nandigam Sasi as part of MAR-1482
@isTest/*(SeeAllData = true)*/
global class OSM_SW_AddressesCleanser_Test 
{
    public static testMethod void testMethod1() 
    {
        CSS_Integration_Details__c objCID1 = new CSS_Integration_Details__c(Logging__c = 'CDH',
	                                                                       IsActive__c = true,
	                                                                       Timeout__c = 120000,
	                                                                       Name = 'IAM_EDQ_Mule_Address_Validation',
	                                                                       Method_Type__c = 'POST',
	                                                                       AuthEnv__c = 'IAM_EDQ_Mule_Address_Validation',
	                                                                       ApplicationName__c = 'OSM_EDQ_Auth',Resource__c='https://services-stg-oauth.cummins.com/api/oauth/token/cdh',
	                                                                       grant_type__c = 'client_credentials',
	                                                                       Key__c = '5c810857-3b0c-4cf8-8210-54a292f5166c',
	                                                                       Passcode__c = 'ca74af57-be7f-4dcd-a9fe-ac41a8bdb539',
	                                                                       End_Point__c = 'https://services-stg-oauth.cummins.com/api/oauth/token/cdh');
        insert objCID1;
        
       TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
          
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        Profile profile1 = [Select Id, Name from Profile where id =:transecRes.objSetupDate.loggedInUser.ProfileId];
        
        System.debug('TEST User : ' + transecRes.objSetupDate.loggedInUser);
        System.debug('TEST Profile : ' + profile1);
        
        System.Runas(transecRes.objSetupDate.loggedInUser){
        
       
            Account acc = transecRes.objSetupDate.account;
        
        
   
            Test.startTest();
            
            OSM_SW_Addresses objAddress = new OSM_SW_Addresses();
                objAddress.billingAddress = new OSM_SW_Addresses.Address();
                objAddress.billingAddress.address1 = '400 BROWN ST';
                objAddress.billingAddress.address2 = '';
                objAddress.billingAddress.address3 = '';
                objAddress.billingAddress.city = 'Scottsdale';
                objAddress.billingAddress.state = 'IN';
                objAddress.billingAddress.country = 'United States';
                objAddress.billingAddress.postalCode = '47201';
                Test.setMock(HttpCalloutMock.class, new addressTestMock());
                OSM_SW_Addresses newCleanAddress = OSM_SW_AddressesCleanser.getCleanserAddress(objAddress,acc.Id);
                OSM_SW_Addresses newCleanAddress1 = OSM_SW_AddressesCleanser.getEDQCleansedAddress(objAddress,acc);

                system.debug(newCleanAddress);
                            
            Test.stopTest();
            
       } 
    }
    
    global class addressTestMock implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(200);
                resp.setBody('Status: OK,Status Code: 200,Response Body: {"Header":{"Sender":{"ServiceName":"AddressCleanse","SenderID":"IAM","MessageID":"0016C00000AUbWtQAL"}},"AddressCleanse":{"Location":{"GeographicalArea":{"StreetAddress":{"StreetAddressID":"","StateProvinceTypeind":"","AddressLine4txt":"","AddressLine3txt":"","AddressLine2txt":"","AddressLine1txt":"400 BROWN ST"},"StateId":"IN","Province":{"ProvinceID":""},"PostalCode":{"PostalCodeNum":"47201"},"GeographicalAreaSubtype":{"DoubleDependantLocality":"","DependantLocality":""},"County":{"CountyID":""},"Country":{"CountryID":"United States"},"City":{"CityID":"Scottsdale"},"AddressValidation":{"MinimumVerificationMatchScore":null,"MinimumVerificationLevel":null,"AllowedVerificationResultCodes":""}}}}}');
                return resp;
            }
    }
    

    
}