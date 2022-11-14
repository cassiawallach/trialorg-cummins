@istest
public class CG_SL_Siebel_Test {
static testmethod void testmethod1()
{          Test.startTest();
    CG_SL_Siebel.callgetMarketingApplicationCodes(string.valueOf(system.today()));
    CG_SL_Siebel.callGetInfoService(string.valueOf(system.today()),'serviceName');
    CG_SL_Siebel.prepareReqJSONForInfoService(string.valueOf(system.today()),'serviceName');
    CG_SL_Siebel.prepareReqJSONForMarkappcodes(string.valueOf(system.today()),'serviceName');
          Test.stopTest();
}
}