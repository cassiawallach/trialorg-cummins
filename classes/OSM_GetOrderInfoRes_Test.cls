@isTest
private class OSM_GetOrderInfoRes_Test {

	private static testMethod void test() {
	    
	    Test.startTest();
	    
	    OSM_GetOrderInfoRes objGOIR = new OSM_GetOrderInfoRes();
	    
	    OSM_GetOrderInfoRes.Sender objSender = new OSM_GetOrderInfoRes.Sender();
	    objSender.ServiceName = 'test';
	    objSender.SenderID = '12345';
	    
	    OSM_GetOrderInfoRes.Target objTarget = new OSM_GetOrderInfoRes.Target();
	    objTarget.TargetID = '12345';
	    
	    OSM_GetOrderInfoRes.LicenseInfo objLI = new OSM_GetOrderInfoRes.LicenseInfo();
	    objLI.LicenseName = 'test';
	    objLI.ActivationKey = 'test';
	    
	    OSM_GetOrderInfoRes.Error objError = new OSM_GetOrderInfoRes.Error();
	    objError.ErrorCode = 'test';
	    objError.ErrorDescription = 'test';
	    
	    OSM_GetOrderInfoRes.Header objHeader = new OSM_GetOrderInfoRes.Header();
	    objHeader.Sender = objSender;
	    objHeader.Target = objTarget;
	    
	    OSM_GetOrderInfoRes.ItemInfo objII = new OSM_GetOrderInfoRes.ItemInfo();
	    objII.ItemId = '12345';
	    objII.LicenseInfo = objLI;
	    
	    OSM_GetOrderInfoRes.ItemInfoList objIIL = new OSM_GetOrderInfoRes.ItemInfoList();
	    objIIL.ItemInfo = new List<OSM_GetOrderInfoRes.ItemInfo>{objII};
	    
	    objGOIR.Header = objHeader;
	    objGOIR.Error = objError;
	    objGOIR.ItemInfoList = objIIL;
	    
	    OSM_GetOrderInfoRes.parse(JSON.serialize(objGOIR));
	    
	    Test.stopTest();
	}

}