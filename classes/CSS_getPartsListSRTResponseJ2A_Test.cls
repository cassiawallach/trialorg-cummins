/*
 * Class Name : CSS_getPartsListSRTRequestJ2A_Test
 * Purpose : Class to cover the unit test cases
 * Developer : Rakesh Kumar
 * Created Date : 11/02/2016
 * 
 */
@istest
public class CSS_getPartsListSRTResponseJ2A_Test {
    //Method to test the response wrapper class 
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"MessageIdentifier\": \"s\",'+
        '       \"ReturnCode\": \"<MessageCode from SRT>\",'+
        '       \"ReturnCodeDescription\": \"<Message from SRT>\",'+
        '       \"Status\": \"Success\",'+
        '       \"MessageType\": \"<Message Type From SRT>\"'+
        '   },'+
        '   \"DataArea\": ['+
        '       {'+
        '           \"FailureID\": \"F08000020\",'+
        '           \"FailureName\": \"Coolant Thermostat\",'+
        '           \"PartNumberSvc\": \"431894700\",'+
        '           \"PartNameSvc\": \"Thermostat\",'+
        '           \"PartNameIMS\": \"COVER\",'+
        '           \"OEM\": \"CECO\",'+
        '           \"Size\": \"M10 X 1.50 X 130\",'+
        '           \"Notes\": \"< includes location, kit part info, other important and relevant notes>\",'+
        '           \"Assignment\": \"Primary\",'+
        '           \"OptionNumber\": \"EC1726\",'+
        '           \"Quantity\": 4'+
        '       },'+
        '       {'+
        '           \"FailureID\": \"F08000020\",'+
        '           \"FailureName\": \"Coolant Thermostat\",'+
        '           \"PartNumberSvc\": \"011981000/11981\",'+
        '           \"PartNameSvc\": \"Thermostat\",'+
        '           \"PartNameIMS\": \"THERMOSTAT HOUSING\",'+
        '           \"OEM\": \"CECO\",'+
        '           \"Size\": \"M10 X 1.50 X 130\",'+
        '           \"Notes\": \"< includes location, kit part info, other important and relevant notes>\",'+
        '           \"Assignment\": \"Primary\",'+
        '           \"OptionNumber\": \"EC1726\",'+
        '           \"Quantity\": 4'+
        '       }'+
        '   ]'+
        '}';
        CSS_getPartsListSRTResponseJ2A obj = CSS_getPartsListSRTResponseJ2A.parse(json);
        System.assert(obj != null);
    }
}