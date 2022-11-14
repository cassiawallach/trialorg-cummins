@isTest
public class FSL_GETCampaignServiceswrapper_Test {
    static testMethod void testParse() 
    {
       // String Json = '{"status": "success"}';
        String Json = '{"DataArea":{"Details":[{"Status":"Approved","CampaignStartDate":"2018-02-02","FailCode":"WSNF","SrtList":[{"SrtCode":"00-901-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"},{"SrtCode":"00-902-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Road Repairs)"},{"SrtCode":"13-004-00","SrtDescription":"Starting Motor - Remove and Install, One (Common Rail Fuel System)"},{"SrtCode":"13-104-00","SrtDescription":"Starting Motor - Remove and Install, Each"},{"SrtCode":"99-902-00","SrtDescription":"Non SRT details- Campaign/TRP/ATC-0.1Hr"}],"MultipleTimes":"N","CampaignDesc":"ISB6.7 EURO5, QSB6.7 TIER3 TERBERG STARTER TRP","FailMode":"WN","InShopSrtLimitFlag":"N","CompleteIndicator":"N","CampaignNumber":1982,"BusinessUnit":"CMI","CampaignEndDate":"2020-02-28","PartList":[{"PartNumber":"499670900","PartDescription":"MOTOR,STARTING","PartQuantity":1}],"CampaignType":"TRP"}]},"Header":{"Status":"Success"}}';
        FSL_GETCampaignServiceswrapper obj = FSL_GETCampaignServiceswrapper.parse(Json);
        System.assert(obj != null);
    }

}