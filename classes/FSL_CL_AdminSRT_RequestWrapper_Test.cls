/********************************************************************************
Name:FSL_CL_AdminSRT_RequestWrapper_Test
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
public class FSL_CL_AdminSRT_RequestWrapper_Test {
  /*@isTest
    public static void testParse() {
        String json = '{'+
            '   \"Header\":{'+
            '      \"Sender\":{'+
            '         \"ServiceName\":\"SRTData\",'+
            '         \"SenderID\":\"Guidanz\"'+
            '      },'+
            '      \"Target\":{'+
            '         \"TargetID\":\"BMS\"'+
            '      },'+
            '      \"Location\":{'+
            '         \"LocationID\":\"56270-56255\"'+
            '      }'+
            '   },'+
            '   \"DataArea\":{'+
            '      \"GuidanzJobID\":\"00001234\",'+
            '      \"ShopWONumber\":\"175328\",'+
            '      \"Make\":\"UNLISTED\",'+
            '      \"Model\":\"ALL\",'+
            '      \"EngineFamilyCode\":\"10\",'+
            '      \"SRTs\":['+
            '         {'+
            '            \"AccessCode\":\"B\",'+
            '            \"SRTgroupnum\":\"00\",'+
            '            \"Procedureno\":\"901\",'+
            '            \"Stepnumber\":\"\",'+
            '            \"SRTTime\":\"8\",'+
            '            \"ActualSRTTime\":\"9\",'+
            '            \"SRTquantity\":\"1\"'+
            '         },'+
            '         {'+
            '            \"AccessCode\":\"R\",'+
            '            \"SRTgroupnum\":\"00\",'+
            '            \"Procedureno\":\"902\",'+
            '            \"Stepnumber\":\"\",'+
            '            \"SRTTime\":\"4\",'+
            '            \"ActualSRTTime\":\"5\",'+
            '            \"SRTquantity\":\"1\"'+
            '         }'+
            '      ]'+
            '   }'+
            '}';
        FSL_CL_AdminSRT_RequestWrapper obj = FSL_CL_AdminSRT_RequestWrapper.parse(json);
        System.assert(obj != null);
    } */
    static testMethod void testActiveMethod(){
        FSL_CL_AdminSRT_RequestWrapper.dummy();
	}
}