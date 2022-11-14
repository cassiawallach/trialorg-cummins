@isTest
public class CSS_getOverlapSRTResponseJ2A_Test {
    static testmethod void testparse(){
        string json = '{'+
'\"Header\": {'+
  '\"MessageIdentifier\": \"From SRT\",'+
  '\"ReturnCode\": \"From SRT\",'+
  '\"ReturnCodeDescription\": \"Service Successful\",'+
  '\"Status\": \"Success\",'+
  '\"MessageType\": \"From SRT\"'+
'},'+
' \"DataArea\": {'+
' \"TotalOverlapHours\": 5.5,'+
' \"TotalAdjustedHours\": 0.5,'+
            '       \"Steps\": [{'+
'                    \"StepId\": 1234,'+
'                     \"AccessCode\": \"R\",'+
'                     \"Qty\": 2,'+
'                     \"SRTHours\": 2.5,'+
'                     \"SRTAdjustedHours\": 0.5,'+
'                     \"TotalOverlapHours\": ['+
'                     {'+
'                           \"SRTNumber\": \"11-111-11\",'+
'                           \"OverlapHrs\": 1.5'+
'                     }]'+
'              }]'+
 '}'+
'}';
        CSS_getOverlapSRTResponseJ2A obj = CSS_getOverlapSRTResponseJ2A.parse(json);
        system.assert(obj != null);

}

}