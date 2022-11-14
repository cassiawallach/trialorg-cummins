/**********************************************************************
Name: CSS_WPR_SRT_DiagnosticSRTReqJSON_Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Request JSON Wrapper Test class of 
            Diagnostic SRT webservice
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR           		 DATE                DETAIL                                 
1.0     Venkat Gantasala        11/16/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
@IsTest
public class CSS_WPR_SRT_DiagnosticSRTReqJSON_Test {
  
  
  static testMethod void testParse() {
      
     // String json = '{"Header":{"Sender":{"MessageID":"unique message ID at SF","SenderID":"SF","ServiceName":"Eg:GetStandardRepairTime"},"Target":{"TargetID":"SRT"}},{"DataArea":"Case_Z":{"CaseNumber":"K03070139","VerifyRepeatValue":"VER","SRTEventPerfDateTime":"2017-01-02T00:00:00","SRTType":"VER","SolutionType":"Summary","CSSJobID": "CSS-00003265","ClaimID":"null", "ServiceModelName":"ISX15 CM2250","LanguageID":"En","TimeStamp":"2017-01-02T00:00:00"}}}';*/
       
    String json = '{'+
    '  \"Header\": {'+
    '    \"Sender\": {'+
    '      \"MessageID\": \"unique message ID at SF\",'+
    '      \"SenderID\": \"SF\",'+
    '      \"ServiceName\": \"Eg:GetStandardRepairTime\"'+
    '    },'+
    '    \"Target\": {'+
    '      \"TargetID\": \"SRT\"'+
    '    }'+
    '  },'+
    '  \"DataArea\": {'+
    '    \"Case_Z\": ['+
    '      {'+
    '        \"CaseNumber\": \"K03070139\",'+
    '        \"VerifyRepeatValue\": \"VER\",'+
    '        \"SRTEventPerfDateTime\": \"2017-01-02T00:00:00\"'+
    '      },'+
    '      {'+
    '        \"CaseNumber\": \"K03070139\",'+
    '        \"VerifyRepeatValue\": \"VER\",'+
    '        \"SRTEventPerfDateTime\": \"2017-01-02T00:00:00\"'+
    '      }'+
    '    ],'+
    '    \"SRTType\": \"VER\",'+
    '    \"SolutionType\": \"Summary\",'+
    '    \"CSSJobID\": \"CSS-00003265\",'+
    '    \"ClaimID\": \"null\",'+
    '    \"ServiceModelName\": \"ISX15 CM2250\",'+
    '    \"LanguageID\": \"en\",'+
    '    \"TimeStamp\": \"2017-01-02T00:00:00\"'+
    '  }'+
    '}';
      
    CSS_WPR_SRT_DiagnosticSRTReqJSON r = CSS_WPR_SRT_DiagnosticSRTReqJSON.parse(json);
    System.assert(r != null);
      system.assert(r.Header!=null);
      system.assert(r.DataArea!=null);
      system.assert(r.DataArea.Case_Z!=null);
      system.assertEquals(r.DataArea.SRTType, 'VER');
       system.assertEquals(r.DataArea.SolutionType, 'Summary');
       system.assertEquals(r.DataArea.CSSJobID, 'CSS-00003265'); 
      system.assertEquals(r.DataArea.ClaimID, 'null');
      system.assertEquals(r.DataArea.ServiceModelName, 'ISX15 CM2250');
      system.assertEquals(r.DataArea.LanguageID, 'en');
      system.assertEquals(r.DataArea.TimeStamp, '2017-01-02T00:00:00');
      system.assert(r.Header.sender!=null);
      system.assertEquals(r.Header.sender.MessageID, 'unique message ID at SF');
      system.assertEquals(r.Header.sender.SenderID, 'SF');
      system.assertEquals(r.Header.sender.ServiceName, 'Eg:GetStandardRepairTime');
      system.assert(r.Header.target!=null);
      system.assertEquals(r.Header.target.TargetID, 'SRT');
      system.assertEquals(r.DataArea.Case_Z[0].CaseNumber,'K03070139');
      system.assertEquals(r.DataArea.Case_Z[0].VerifyRepeatValue,'VER');
      system.assertEquals(r.DataArea.Case_Z[0].SRTEventPerfDateTime,'2017-01-02T00:00:00');
      
      
      
   
  }
}