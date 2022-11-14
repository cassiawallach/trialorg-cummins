/***********************************************************************
History                                                            
-------                                                            
VERSION             AUTHOR                        DATE                  DETAIL                                 
1.0 -   		   Rupesh Pande      			9/20/2018           INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class CSS_J2ADSIDDetails_EDS_Test 
{
    static testmethod void M1()
    {
        String json = '{\"menu\": {'+
		'  \"id\": \"file\",'+
		'  \"value\": \"File\",'+
		'  \"popup\": {'+
		'    \"menuitem\": ['+
		'      {\"value\": \"New\", \"onclick\": \"CreateNewDoc()\"},'+
		'      {\"value\": \"Open\", \"onclick\": \"OpenDoc()\"},'+
		'      {\"value\": \"Close\", \"onclick\": \"CloseDoc()\"}'+
		'    ]'+
		'  }'+
		'}}';

        CSS_J2ADSIDDetails_EDS.parse(json);
    }
}