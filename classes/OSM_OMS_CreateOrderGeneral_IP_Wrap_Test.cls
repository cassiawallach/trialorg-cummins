@isTest
private class OSM_OMS_CreateOrderGeneral_IP_Wrap_Test {

    private static testMethod void test() {
        
        OSM_OMS_CreateOrderGeneral_IP_Wrapper objWarp = new OSM_OMS_CreateOrderGeneral_IP_Wrapper();
        OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails objOID = new OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails();
        
        OSM_BMS_WS_GeneralizedOutputWrapper objCOR = new OSM_BMS_WS_GeneralizedOutputWrapper();
        OSM_OMS_CreateOrderGeneral_OP_Wrapper opWrapper=new OSM_OMS_CreateOrderGeneral_OP_Wrapper();
        OSM_Integration_Log__c log=new OSM_Integration_Log__c();
        opWrapper.log=log;
        opWrapper.omsOrderId='test';
        
        
        OSM_BMS_WS_GeneralizedOutputWrapper.DataArea objDA = new OSM_BMS_WS_GeneralizedOutputWrapper.DataArea();
        objDA.CustomerCode = '12345';
        objDA.LocationAddressline3 = 'test';
        objDA.PhoneNumber = '12345';
        objDA.Country = 'test';
        objDA.CustomerName = 'test';
        objDA.City = 'test';
        objDA.LocationAddressline2 = 'test';
        objDA.LocationAddressline1 = 'test';
        objDA.AreaCode = '12345';
        objDA.PaymentType = 'cash';
        objDA.State = 'test';
        objDA.Postalcode2 = '12345';
        objDA.Postalcode1 = '12345';
        objDA.CreditLimit = 12345;
        objDA.QuoteCustomer = 'test';
        objDA.RequirePO = '12345';
        objDA.AmountDue = 12345;
        objDA.AvailableCredit = 12345;
        
        OSM_BMS_WS_GeneralizedOutputWrapper.Sender objSender = new OSM_BMS_WS_GeneralizedOutputWrapper.Sender();
        objSender.ServiceName = 'BMSCustomerLookupService';
        objSender.SenderID = 'Mrktplc';
        
        OSM_BMS_WS_GeneralizedOutputWrapper.Target objTarget = new OSM_BMS_WS_GeneralizedOutputWrapper.Target();
        objTarget.TargetID = 'OMS';
        
        OSM_BMS_WS_GeneralizedOutputWrapper.Location objLocation = new OSM_BMS_WS_GeneralizedOutputWrapper.Location();
        objLocation.LocationID = '6718021';
        
        OSM_BMS_WS_GeneralizedOutputWrapper.Header objHeader = new OSM_BMS_WS_GeneralizedOutputWrapper.Header();
        objHeader.Status = 'Success';
        objHeader.Sender = objSender;
        objHeader.Target = objTarget;
        objHeader.Location = objLocation;
        
        objCOR.DataArea = new List<OSM_BMS_WS_GeneralizedOutputWrapper.DataArea>{objDA};
        objCOR.Header = objHeader;

    }

}