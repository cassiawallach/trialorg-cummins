@IsTest
public class FSL_CL_IA_LocationEnabledAPI_Res_Test {
    //Rajashekar N ; 09/09/2020 ; CT2-146
    @isTest
    private static void testParse() {
        String json = '{'+
            '	\"Header\": {'+
            '		\"Status\": \"Success\",'+
            '		\"ServiceName\": \"IALocationEnabled\",'+
            '		\"ServiceVersion\": \"1.0\",'+
            '		\"ReturnCodeDescription\": \"IALocationEnabled data as Response\"'+
            '	},'+
            '	\"DataArea\": {'+
            '		\"wOEnabled\": \"Y\"'+
            '	}'+
            '}';
        FSL_CL_IA_LocationEnabledAPI_ResDataWrp obj = FSL_CL_IA_LocationEnabledAPI_ResDataWrp.parse(json);
        System.assert(obj != null);	
    }
}