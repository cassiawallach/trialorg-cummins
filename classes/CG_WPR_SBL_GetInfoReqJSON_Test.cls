@istest
public class CG_WPR_SBL_GetInfoReqJSON_Test {

    static  testmethod void voidtest123(){
        string sh='{"Header":{"Target":{"TargetID":"SIEBEL"},"Sender":{"ServiceName":"GetSPTechSMN","SenderID":"CSS"}},"DataArea":{"LastProcessedDate":"2018-06-06"}}';
       CG_WPR_SBL_GetInfoReqJSON req= CG_WPR_SBL_GetInfoReqJSON.parse(sh);
        system.assert(req!=null);
    }
}