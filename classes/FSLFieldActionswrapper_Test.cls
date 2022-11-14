@isTest
public class FSLFieldActionswrapper_Test {  

    static testMethod void testParse() 
    {
        String Json = '{"DataArea":{"FieldAction":[{"FieldActionNumber":"2037","FieldActionType":"TRP","FieldActionSRTTime":[{"S7TIME":0,"SRTDetails":"00-901-00","SRTAccessCode":"B","S6DESCRIPTION":"","S9DESCRIPTION":"","BTIME":0.4,"S2TIME":0,"CTIME":0,"S2DESCRIPTION":"","S8TIME":0,"Assignment":"PRIMARY","S5DESCRIPTION":"","S6TIME":0,"S3TIME":0,"S8DESCRIPTION":"","SRTTime":0.4,"S1DESCRIPTION":"","StepDescription":"Noted","S4DESCRIPTION":"","SRTQuantity":1,"QuoteID":304730,"S4TIME":0,"SRTTitle":"Administrative Time - Open and Close Repair Order (Shop Repairs)","SRTMessage":"","StepID":2987,"DTIME":0,"S3DESCRIPTION":"","RTIME":0.4,"ATIME":0,"S7DESCRIPTION":"","S1TIME":0,"S5TIME":0,"S9TIME":0}]}]},"Header":{"Status":"Success","ReturnCode":"ORA-00000","ReturnCodeDescription":"Normal, Successful completion.","MessageIdentifier":"S"}}';
        FSLFieldActionswrapper obj = FSLFieldActionswrapper.parse(Json);
        System.assert(obj != null);
    }
}