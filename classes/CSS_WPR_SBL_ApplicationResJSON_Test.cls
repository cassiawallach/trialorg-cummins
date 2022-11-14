/**********************************************************************
Name: CSS_WPR_SBL_ApplicationResJSON_Test
Copyright © 2017  Cummins
======================================================
======================================================
Purpose:    Test Class for CSS_WPR_SBL_ApplicationResJSON
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION       AUTHOR                   DATE          DETAIL                                 
1.0           Prabhakar                23/05/2017    INITIAL dEVELOPMENT

***********************************************************************/

@IsTest
public class CSS_WPR_SBL_ApplicationResJSON_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Details\": {'+
		'    \"ApplicationCode\": \"12345\",'+
		'    \"Description\": \"testing\",'+
		'    \"BusinessUnit\": \"GetAssessData\",'+
		'    \"AutomotiveFlag\": \"Fault Details Data sent successfully\",'+
        '    \"MarineFlag\": \"Fault Details Data sent successfully\",'+   
        '    \"ActiveFlag\": \"Fault Details Data sent successfully\",'+    
        '    \"DefaultUom\": \"Fault Details Data sent successfully\"'+     
		'  },'+
		'  \"Header\": {'+   
		'        \"ReturnCodeDescription\": \"Test\",'+
		'        \"Status\": \"completed\"'+
		'      }'+
            '}';
	
		CSS_WPR_SBL_ApplicationResJSON obj = CSS_WPR_SBL_ApplicationResJSON.parse(json);
		System.assert(obj != null);
	}
}