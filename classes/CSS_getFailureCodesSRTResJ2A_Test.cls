/*
 * Class Name : CSS_getFailureCodesSRTResJ2A_Test
 * Purpose : Class to cover the unit test cases
 * Developer : Rajesh Pasupuleti
 * Created Date : 11/02/2016
 * 
 */
@isTest
public class CSS_getFailureCodesSRTResJ2A_Test {
      static testmethod void testparse(){
          
        string json = '{'+
              '\"Header\": {'+
                      '\"Status\": \"Success\",'+
                      '\"MessageIdentifier\": \"MessageIdentifierl\",'+
                      '\"ReturnCode\": \"ReturnCodeT\",'+
                      '\"ReturnCodeDescription\": \"ReturnCodeDescriptionT\",'+
                      '\"MessageType\": \"MessageTypeT\"'+
               '},'+  
              ' \"DataArea\": [{'+
                      '\"FailureID\": \"FailureID1\",'+
                      '\"FailureName\": \"MessageIFailureNamel\",'+
                      '\"SystemCode\": \"SystemCodeq\",'+
                      '\"ComponentCode\": \"ReturnCComponentCodeT\",'+
                      '\"FailureMode\": \"FailureMode\"'+
                
              '}]'+
            '}';
        CSS_getFailureCodesSRTResJ2A obj = CSS_getFailureCodesSRTResJ2A.parse(json);
        system.assert(obj != null);

      }
}