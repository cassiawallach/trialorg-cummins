/**********************************************************************
Name: CSS_SRTComponentLookupRequestJ2A_Test
Copyright © 2017  Cummins
======================================================
======================================================
Purpose:    Test Class for CSS_SRTComponentLookupRequestJ2A
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION       AUTHOR                   DATE          DETAIL                                 
1.0           Vignesh S             08/01/2017    INITIAL dEVELOPMENT

***********************************************************************/

@isTest
public class CSS_SRTComponentLookupRequestJ2A_Test{

 static testMethod void testParse() {
  String json = '{' +
   '    \"Header\": ' +
   '    {' +
   '        \"Sender\": ' +
   '        {' +
   '            \"ServiceName\": \"GetFailureCodesSRT\",' +
   '            \"SenderID\": \"CSS\"' +
   '        },' +
   '        \"Target\": { \"TargetID\": \"SRT\" }' +
   '    },' +
   '    \"DataArea\": ' +
   '    {' +
   '        \"ServiceModelName\": \"ISC8.3 CM2250\",' +
   '        \"LanguageCode\": \"en\",' +
   '        \"EngineFamilyCode\": \"41\"' +
   '    }' +
   '}';
  CSS_SRTComponentLookupRequestJ2A controller = CSS_SRTComponentLookupRequestJ2A.parse(json);
  CSS_SRTComponentLookupRequestJ2A.DataArea dArea = new CSS_SRTComponentLookupRequestJ2A.DataArea();
  dArea.ServiceModelName = '409727';
  dArea.LanguageCode = 'en';
  dArea.EngineFamilyCode = '41';
 }
}