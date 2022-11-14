/**********************************************************************
Name: CSS_BMSContactLookupRequestJ2A_Test
Copyright © 2017  Cummins
======================================================
======================================================
Purpose:    Test Class for CSS_BMSContactLookupRequestJ2A
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION       AUTHOR                   DATE          DETAIL                                 
1.0           Prabhakar                23/05/2017    INITIAL dEVELOPMENT

***********************************************************************/

/*@isTest
public class CSS_BMSContactLookupRequestJ2A_Test {
    static testMethod void testParse() {
        String json=		'{'+
		'"Header": {'+
		'"Sender": {'+
		'"ServiceName": "WOParts",'+
		'"SenderID": "CSS"'+
		'},'+
		'"Target": {'+
		'"TargetID": "BMS"'+
		'},'+
		'"Location": {'+
		'"LocationID": "03742-03750"'+
		'}'+
		'},'+
		'"DataArea": {'+
		'"CustomerCode": "CSS-00009"'+


		'}'+
		'}';
		
		CSS_BMSContactLookupRequestJ2A obj = CSS_BMSContactLookupRequestJ2A.parse(json);
		System.assert(obj != null);
        
        
    } 
    

}*/
@IsTest
public class CSS_BMSContactLookupRequestJ2A_Test {
     
     static testMethod void testParse() {
           String json = '{'+
           '    \"Header\": '+
           '    {'+
           '        \"Sender\": '+
           '        {'+
           '            \"ServiceName\": \"GetContactInfo\",'+
           '            \"SenderID\": \"CSS\"'+
           '        },'+
           '        \"Target\": { \"TargetID\": \"BMS\" },'+
           '        \"Location\": { \"LocationID\": \"56270-56255\" }'+
           '    },'+
           '    \"DataArea\": '+
           '    {'+
           '        \"CustomerCode\": \"409727\"'+
           '    }'+
           '}';
           CSS_BMSContactLookupRequestJ2A obj = CSS_BMSContactLookupRequestJ2A.parse(json);
           CSS_BMSContactLookupRequestJ2A.DataArea d = new CSS_BMSContactLookupRequestJ2A.DataArea();
           d.CustomerCode = '409727';
           System.assert(obj != null);
     }
}