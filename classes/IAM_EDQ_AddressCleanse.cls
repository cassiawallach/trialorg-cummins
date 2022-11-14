/************************************************************
Name:  IAM_EDQ_AddressCleanse
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class calls EDQ Service for address validation and return its reponse.2
==================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2018        INITIAL DEVELOPMENT  
1.1 -    Karthik Raj Golakaram     11/16/2020      Made changes for Mule Integration        
*****************************************************/
/********************************************************************************
***********************************************************************************/
public without sharing class IAM_EDQ_AddressCleanse {

    public static IAM_EDQ_LocationResParser EDQAddress(Account accnt) {
        System.debug('Printing future login');
        Http h = new Http();
        HttpResponse res;
        HttpRequest req;
        IAM_EDQ_LocationResParser LocRes;
    String responseBody='';
        String accessToken;
        CSS_Integration_Details__c edqDetails= IAM_getConnnectionDetails.getConnection('IAM_EDQ_Mule_Address_Validation');
        System.debug('Printing EDQ Integration Details'+edqDetails);
        if(Test.isRunningTest()) {
            accessToken = 'lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz';
            System.debug('#### In Test.isRunningTest - accessToken - '+accessToken);
        } else {
          //accessToken = IAM_OAG_getoAuthToken.getAccessToken('IAM_EDQ_oAuth');
          accessToken=IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_EDQ_Mule_oAuth');
        }

        
        //calling EDQ  service
        try {
            //calling Location request parser class to get request body
            String ReqBody = IAM_EDQ_LocationReqParser.IAM_LocationEDQReqParser(accnt);
            System.debug('Priniting Request body from the parser class' + ReqBody);

            if (String.isNotBlank(ReqBody) && String.isNotBlank(accessToken)) {
                //need to set header parameters and then call the service.
                System.debug('Printing entered request body not equal to null');
                string url = System.Label.IAM_EDQ_Address_Cleanse_Url;
                req = new HttpRequest();
                req.setEndpoint(edqDetails.End_Point__c);
                req.setMethod(edqDetails.Method_Type__c);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Authorization', 'Bearer ' + accessToken);
                req.setHeader('resource',edqDetails.Resource__c);
                req.setBody(ReqBody);
                req.setTimeout(120000);
                if(!Test.isRunningTest()){
                 res = h.send(req);
                    if (res.getStatusCode() == 200) {
                        responseBody=res.getBody();
                        System.debug('http response code is ' + res.getStatusCode());
                    System.debug('Printing Response Body' + res.getBody());
                    }     
                }else{
                    responseBody='{"AddressCleanse":{"ResponseNotifications":{"Status":"Success","ReturnCodeDescription":""},"Location":[{"Locator":{"LongitudeMeas":"","LatitudeMeas":""},"GeographicalArea":{"GeographicalAreaName":"","StreetAddress":{"FullAddress":"340 WINT LN APT D,29&#124;COLUMBUS IN 47201-6690","AddressLine1txt":"340 WINT LN APT D,29","AddressLine4txt":"","StreetAddressID":"","AddressLine2txt":"","AddressLine3txt":"","StateProvinceTypeind":"S","AddressType":"R"},"AddressValidation":{"VerificationDescription":"Verified; 4 - Premise; Identified and parsed; Primary postal code verified, secondary added or changed; Score 100","VerificationCode":"V44-I55-P7-100","VerifiedFlag":"N","GeoAccuracyCodeDescription":"Unable to geocode; 0 - None","GeoAccuracyCode":"U0","GeoDistance":""},"AddressError":{"ErrorDescription":"","ErrorFlag":"N"},"GeographicalAreaSubName":"","Country":{"CountryID":"US","CountryName":"US","CountryNameDescription":"UNITED STATES"},"PostalCode":{"PostalCodeNum":"47201-6690"},"City":{"TerritoryID":"IN","CityID":"COLUMBUS"},"County":{"CountyID":"BARTHOLOMEW"},"CountryGroup":{"CountryGroupID":"AMERICAS","SubRegion":"NORTHERN AMERICA"}}},{"Locator":{"LongitudeMeas":"","LatitudeMeas":""},"GeographicalArea":{"GeographicalAreaName":"","StreetAddress":{"FullAddress":"340 WINT LN APT D,29&#124;&#124;&#124;&#124;&#124;&#124;COLUMBUS&#124;&#124;IN&#124;47201-6690","AddressLine1txt":"340 WINT LN APT D,29","AddressLine4txt":"","StreetAddressID":"","AddressLine2txt":"","AddressLine3txt":"","StateProvinceTypeind":"","AddressType":"S"},"AddressValidation":{"VerificationDescription":"","VerificationCode":"","VerifiedFlag":"","GeoAccuracyCodeDescription":"","GeoAccuracyCode":"","GeoDistance":""},"AddressError":{"ErrorDescription":"","ErrorFlag":"N"},"GeographicalAreaSubName":"","Country":{"CountryID":"US","CountryName":"US","CountryNameDescription":"UNITED STATES"},"PostalCode":{"PostalCodeNum":"47201-6690"},"City":{"TerritoryID":"IN","CityID":"COLUMBUS"},"County":{"CountyID":""},"CountryGroup":{"CountryGroupID":"","SubRegion":""}}}]}}';
                }
                LocRes = IAM_EDQ_LocationResParser.parse(responseBody);
                System.debug('Printing Idm location response Object' + LocRes);

                if (LocRes != null) {
                    String VerifiedFlag = LocRes.AddressCleanse.Location[0].GeographicalArea.AddressValidation.VerifiedFlag;
                    System.debug('Printing verified flag value' + VerifiedFlag);
                    if (verifiedflag == 'Y') {
                        //updating account fields
                        return LocRes;
                    } else {
                        //this part is to tell the IAM support Team that the address for the location has not got updated for the registered account.
                        String Accountdetails = 
                            'Account did not got updated because the response for EDQ is Not verified and account name is'
                            + accnt.Name;
                        IAM_ErrorHandling.IAMerrorCapture(responseBody, 
                          'EDQ Address cleanse Future Method', Accountdetails);
                        return LocRes;
                    }
                }
            }
        } catch(Exception e) {
            System.debug('Printing exception message' + e.getMessage());
            //Calling IDM Error handling class to inser the error in to the error Object.
            IAM_ErrorHandling.IAMerrorCapture('Error from EDQ Address Cleanse', 'EDQ Address cleanse Future Method', e.getMessage());
      return null;
        }
        return null;
    }
}