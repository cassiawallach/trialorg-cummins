/********************************************************************************
Name:FSL_CL_AdminSRT_ResponseWrapper_Test
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:                                                            
-------  This is the class for Admin SRT Integrtion
======================================================
User story : CT2-345
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR             DATE               DETAIL                                
V.1.0 	 Rajashekar N		11/13/2020		   Send Admin SRTs to ERP
*********************************************************************************/
@isTest
public class FSL_CL_AdminSRT_ResponseWrapper_Test {
	/*public static testMethod void testParse() {
		String json = '{'+
		'   \"Header\":{'+
		'      \"Status\":\"SUCCESS\",'+
		'      \"ReturnCodeDescription\":\"Admin SRTs processed successfully\"'+
		'   },'+
		'   \"DataArea\":{'+
		'      \"GuidanzJobID\":\"00001234\",'+
		'      \"ShopWONumber\":\"175328\"'+
		'   }'+
		'}';
		FSL_CL_AdminSRT_ResponseWrapper obj = FSL_CL_AdminSRT_ResponseWrapper.parse(json);
		System.assert(obj != null);
	} */
    static testMethod void testActiveMethod(){
        FSL_CL_AdminSRT_ResponseWrapper.dummy();
	}
}