@isTest
public class FSL_CL_IA_GetServiceRequestAPI_Res_Test {
     //Rajashekar N ; 09/09/2020 ; CT2-146
    @isTest
    private static void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"Status\": \"Success\",'+
        '       \"ServiceName\": \"IASerRequestCreation\",'+
        '       \"ServiceVersion\": \"1.0\",'+
        '       \"ReturnCodeDescription\": \"IASerRequestCreation data as Response\",'+
        '       \"toolId\": \"Guidanz\",'+
        '       \"SenderId\": \"rf671\"'+
        '   },'+
        '   \"DataArea\": {'+
        '       \"CustomerName\": \"Customer-001\",'+
        '       \"ContactFirstName\": \"CustomerFirst\",'+
        '       \"ContactLastName\": \"CustomerLast\",'+
        '       \"WONumber\": \"123456\",'+
        '       \"PSN\": \"123456\",'+
        '       \"UnitNumber\": \"123456\",'+
        '       \"ComplaintText\": \"This is a complainText\",'+
         '      \"AvailableForService\": \"Yes\",'+
        '       \"WOEnabled\": \"Y\"'+
        '   }'+
        '}';
        //added for coverage
        FSL_CL_IA_GetServiceRequestAPI_ResJSON obj = FSL_CL_IA_GetServiceRequestAPI_ResJSON.parse(json);
        System.assert(obj != null); 
    }
}