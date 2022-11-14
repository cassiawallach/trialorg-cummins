/**********************************************************************
Name: CSS_BMSContactLookupResponseJ2A_Test
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    Test class
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rakesh Kumar   23/05/2017       INITIAL DEVELOPMENT                    
***********************************************************************/
@IsTest
public class CSS_BMSContactLookupResponseJ2A_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'                \"DataArea\": ['+
		'                {'+
		'                                \"CustomerNumber\": \"5723046\",'+
		'                                \"FirstName\": \"\",'+
		'                                \"MI\": \"5723046\",'+
		'                                \"LastName\": \"CA\",'+
		'                                \"Salutation\": \"BRITESTONE COLONY\",'+
		'                                \"Position\": \"CARBON\",'+
		'                                \"LocationAddressline1\": \"BOX 129\",'+
		'                                \"LocationAddressline2\": \"CARBON COLONY\",'+
		'                                \"LocationAddressline3\": \"CARBON COLONY\",'+
		'                                \"City\": \"403\",'+
		'                                \"State\": \"CASH\",'+
		'                                \"PostalCode\": \"AB\",'+
		'                                \"PostalCodeSuffix\": \"\",'+
		'                                \"Country\": \"US\",'+
		'                                \"PhoneAreaCode\": \"667\",'+
		'                                \"PhoneNumber\": \"278-6789\",'+
		'                                \"Ext\": \"11\",'+
		'                                \"FaxAreacode\": \"813\",'+
		'                                \"FaxNumber\": \"213-0897\",'+
		'                                \"Email\": \"Example@gmail.com\",'+
		'                                \"Comments\": \"Testing\",'+
		'                                \"ContactID\": \"213897\"'+
		'                }],'+
		''+
		'                \"Header\": {'+
		'                                \"ReturnCodeDescription\":\"retTest\",'+
		'                                \"Status\": \"SUCCESS\",'+
		'                                \"Sender\": {'+
		'                                                \"ServiceName\": \"GetCustomer\",'+
		'                                                \"MessageID\":\"1234\", '+
		'                                                \"SenderID\": \"BMS\"'+
		'                                },'+
		'                                \"Target\": {'+
		'                                                \"TargetID\": \"CSS\"'+
		'                                },'+
		'                                \"Location\": {'+
		'                                                \"LocationID\": \"56270-56255\"'+
		'                                }'+
		'                }'+
		'}';
		CSS_BMSContactLookupResponseJ2A obj = CSS_BMSContactLookupResponseJ2A.parse(json);
        system.debug('obj--->'+obj);
        CSS_BMSContactLookupResponseJ2A.Header h = new CSS_BMSContactLookupResponseJ2A.Header();
        h.ReturnCodeDescription = '';
        h.Status = '';
        CSS_BMSContactLookupResponseJ2A.Location l = new CSS_BMSContactLookupResponseJ2A.Location();
        l.LocationID = '';
        CSS_BMSContactLookupResponseJ2A.DataArea d = new CSS_BMSContactLookupResponseJ2A.DataArea();
        d.CustomerNumber='test';
         d.FirstName='test';
         d.MI='test';
         d.LastName='test';
         d.Salutation='test';
         d.Position='test';
         d.LocationAddressline1='test';
         d.LocationAddressline2='test';
         d.LocationAddressline3='test';
         d.City='test';
         d.State='test';
         d.PostalCode='test';
         d.PostalCodeSuffix='test';
         d.Country='test';
         d.PhoneAreaCode='test';
         d.PhoneNumber='test';
         d.Ext='test';
         d.FaxAreacode='test';
         d.FaxNumber='test';
         d.Email='test';
         d.Comments='test';
         d.ContactID='test';
        CSS_BMSContactLookupResponseJ2A obj1 = new CSS_BMSContactLookupResponseJ2A();
        obj1.DataArea = new list<CSS_BMSContactLookupResponseJ2A.DataArea>();
        obj1.DataArea.add(d);
		System.assert(obj != null);
	}
}