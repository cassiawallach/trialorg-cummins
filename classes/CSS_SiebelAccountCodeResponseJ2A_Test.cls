/**********************************************************************
Name: CSS_SiebelAccountCodeResponseJ2A_Test
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    Test class for CSS_SiebelAccountCodeResponseJ2A
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Vignesh S       08/25/2017       INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CSS_SiebelAccountCodeResponseJ2A_Test
{
    static testMethod void testParse() {
    String json = '{'+
    '                \"DataArea\": ['+
    '                {'+
    '                                \"COVERAGETYPE\": \"CAP\",'+
    '                                \"DESCRIPTION\": \"CONNECTED PRODUCTS\",'+
    '                                \"ACCOUNTCODE\": \"PC\",'+
    '   							 \"PAYCODES\": ['+
    '								 {'+
    '                                                  \"PAYCODE\": \"03\",'+
    '                                                  \"PAYCODEDESCRIPTION\": \"RECON DEALER NOW\"'+
    '                                }]'+
    '                }],'+
    ''+
    '                \"Header\": {'+
    '                                \"ReturnCodeDescription\":\"\",'+
    '                                \"Status\": \"Success\"'+
    '                }'+
    '}';
    CSS_SiebelAccountCodeResponseJ2A controller = CSS_SiebelAccountCodeResponseJ2A.parse(json);
    CSS_SiebelAccountCodeResponseJ2A.Header header = new CSS_SiebelAccountCodeResponseJ2A.Header();
    header.ReturnCodeDescription = '';
    header.Status = 'Success';
    CSS_SiebelAccountCodeResponseJ2A.DataArea dArea = new CSS_SiebelAccountCodeResponseJ2A.DataArea();
    dArea.COVERAGETYPE ='CAP';
    dArea.DESCRIPTION ='CONNECTED PRODUCTS';
    dArea.ACCOUNTCODE ='PC';
    CSS_SiebelAccountCodeResponseJ2A.PAYCODES payCodes = new CSS_SiebelAccountCodeResponseJ2A.PAYCODES();
    dArea.PAYCODES = new List<CSS_SiebelAccountCodeResponseJ2A.PAYCODES>();
    payCodes.PAYCODE = '03';
    payCodes.PAYCODEDESCRIPTION = 'RECON DEALER NOW';
    dArea.PAYCODES.add(payCodes);
    CSS_SiebelAccountCodeResponseJ2A controllerNew = new CSS_SiebelAccountCodeResponseJ2A();
    controllerNew.DataArea = new list<CSS_SiebelAccountCodeResponseJ2A.DataArea>();
    controllerNew.DataArea.add(dArea);
  }
}