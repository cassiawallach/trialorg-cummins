@istest
private class OSM_WS_IP_CSWrapper_Test
{
    static TestMethod void testOAGWrapper() {
        OSM_WS_IP_CSWrapper ip = new OSM_WS_IP_CSWrapper();
        
        Test.startTest();
        ip.jsonReqBody = '{ "messageID": "MSG1234", "timeStamp": "2018-03-20T19:47:00.000Z", "initiator": "ECommerce", "customerID": "65885" }';
        //ip.methodType = '';
        //ip.timeOut = 1;
        ip.serviceName = 'Test';
        ip.AuthEnv = 'OAGOAuth';
        ip.AccesTokenRequired = true;
        ip.methodType = 'POST';
        ip.timeOut = 2343243;
        ip.cmsOrderId = 'TEST cmsOrderId';
        ip.MessageID = 'TEST MessageID';
        ip.Timestamp = 'TEST Timestamp';
        ip.ToolName = 'TEST ToolName';
        ip.ActivationKey = 'TEST ActivationKey';
        ip.CustomerName = 'TEST CustomerName';
        ip.CustomerCode = 'TEST CustomerCode';
        ip.DealerCode = 'TEST DealerCode';
        ip.LocationID = 'TEST LocationID';
        ip.TargetID = 'TEST TargetID';
        ip.SenderID = 'TEST SenderID';
        Test.stopTest();
    }
}