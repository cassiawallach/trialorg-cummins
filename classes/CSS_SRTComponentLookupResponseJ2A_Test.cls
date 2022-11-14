/**********************************************************************
Name: CSS_SRTComponentLookupResponseJ2A_Test
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    Test class for CSS_SRTComponentLookupResponseJ2A
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Vignesh S       08/01/2017       INITIAL DEVELOPMENT                    
***********************************************************************/
@IsTest
public class CSS_SRTComponentLookupResponseJ2A_Test{
  
  static testMethod void testParse() {
    String json = '{'+
    '                \"DataArea\": ['+
    '                {'+
    '                                \"ComponentCode\": \"CG\",'+
    '                                \"FailureMode\": \"\",'+
    '                                \"FailureID\": \"F30000860\",'+
    '                                \"FailureName\": \"Accessory Plate Cover Gasket\",'+
    '                                \"SystemCode\": \"BG\"'+
    '                }],'+
    ''+
    '                \"Header\": {'+
    '                                \"ReturnCodeDescription\":\"Normal, Successful completion.\",'+
    '                                \"ReturnCode\": \"ORA-00000\",'+
    '                                \"MessageIdentifier\": \"S\"'+
    '                }'+
    '}';
    CSS_SRTComponentLookupResponseJ2A controller = CSS_SRTComponentLookupResponseJ2A.parse(json);
    CSS_SRTComponentLookupResponseJ2A.Header header = new CSS_SRTComponentLookupResponseJ2A.Header();
    header.ReturnCodeDescription = 'Normal, Successful completion.';
    header.ReturnCode = 'ORA-00000';
    header.MessageIdentifier = 'S';
    header.MessageType = 'Test';
    CSS_SRTComponentLookupResponseJ2A.DataArea dArea = new CSS_SRTComponentLookupResponseJ2A.DataArea();
    dArea.ComponentCode ='CG';
    dArea.FailureMode ='';
    dArea.FailureID ='F30000860';
    dArea.FailureName ='Accessory Plate Cover Gasket';
    dArea.SystemCode='BG';
    CSS_SRTComponentLookupResponseJ2A controllerNew = new CSS_SRTComponentLookupResponseJ2A();
    controllerNew.DataArea = new list<CSS_SRTComponentLookupResponseJ2A.DataArea>();
    controllerNew.DataArea.add(dArea);
  }
}