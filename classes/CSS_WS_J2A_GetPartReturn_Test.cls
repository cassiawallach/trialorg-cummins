@IsTest
public class CSS_WS_J2A_GetPartReturn_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '    \"DataArea\": ['+
        '        {'+
        '            \"LOCATION\": \"\",'+
        '            \"MESSAGE\": \"***ENHANCED PARTS RETURN REQUEST***PLEASE TAG THE PART AND PLACE IT IN THE BOX OF THE REPLACEMENT PART. LABEL THE PART WITH A MATERIAL RETURN TAG WHICH INCLUDES ESN, DISTRIBUTOR CODE, CLAIM NUMBER AND WORK ORDER NUMBER. THE PART SHOULD BE RETURNED TO: CUMMINS SSC EUROPE UNIT B DAVENTRY INTERCHANGE, SOPWITH WAY DRAYTON FIELDS INDUSTRIAL ESTATE, DAVENTRY, NORTHHAMPTONSHIRE, NN11, 8PB, UK. CONTACT SSC.EUROPE@CUMMINS.COM WITH QUESTIONS.\",'+
        '            \"ATTENTION\": \"\",'+
        '            \"RETURNMESSAGE\": \"\",'+
        '            \"EPRFLAG\": \"Y\",'+
        '            \"PARTNUMBER\": \"528408300\",'+
        '            \"COMPANY\": \"\"'+
        '        }'+
        '    ],'+
        '    \"Header\": {'+
        '        \"Status\": \"Success\",'+
        '        \"ReturnCodeDescription\": \"\"'+
        '    }'+
        '}';
        CSS_WS_J2A_GetPartReturn obj = CSS_WS_J2A_GetPartReturn.parse(json);
        System.assert(obj != null);
    }
}