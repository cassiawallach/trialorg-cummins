@isTest
public class CSS_getAllSRTReqJ2A_Test {

    static testmethod void CSSGetAllSRTReqmethod(){
            string Json =  '{\"Header\": {\"Sender\": {\"ServiceName\": \"GetAllSRT\",\"SenderID\": \"CSS\"},\"Target\":{\"TargetID\":\"SRT\"}},\"DataArea\": {\"Jobid\": \"CSS-000001234\",\"ClaimID\": \"C100002045\",\"Languagecode\": \"en\",\"EngineFamilyCode\": \"10\",\"ServiceModelName\": \"ISX15 CM2350 X101\",\"EquipmentID\": \"EQ1234\",\"SRTType\": \"Admin\",\"SRTCategory\": \"General\",\"DTTimestamp\": \"04-NOV-16 10:49:50 AM\",\"EffectiveDTTime\": \"04-NOV-16 10:49:50 AM\"}}';
                /*'{'+
        '\"Header\": {'+
        '\"Sender\": {'+
            '\"ServiceName\": \"GetAllSRT\",'+
            '\"SenderID\": \"CSS\"'+
        '},'+
        '  \"Target\":{\"TargetID\":\"SRT\"}'+          
    '},'+
    '\"DataArea\": {'+
        ' \"Jobid\": \"CSS-000001234\",'+
        ' \"ClaimID\": \"C100002045\",'+
        ' \"Languagecode\": \"en\",'+
        ' \"EngineFamilyCode\": \"10\",'+
        ' \"ServiceModelName\": \"ISX15 CM2350 X101\",'+
        ' \"EquipmentID\": \"EQ1234\",'+
        ' \"SRTType\": \"Admin\",'+
        ' \"SRTCategory\": \"General\",'+
        '\"DTTimestamp\": \"04-NOV-16 10:49:50 AM\",'+
        '\"EffectiveDTTime\": \"04-NOV-16 10:49:50 AM\",'+
    '}'+
'}';*/
        CSS_getAllSRTReqJ2A obj = CSS_getAllSRTReqJ2A.parse(Json);
        System.assert(obj != null);
    }
}