@istest
public class OSM_InvokeInterCompanyProcess_Test {
@isTest static void testValidEvent() {
        list<string>  orderIdToProcess = new list<string>();
        orderIdToProcess.add('a2V1F000003CbMO');
        OSM_IntercompanyProcess__e orderevent = new OSM_IntercompanyProcess__e();
        orderevent.Event_Publisher__c='OSM_InterCompanyInvoice_RetryBatch';
        orderevent.SalesOrder_ID__c=string.join(orderIdToProcess,',');
        orderevent.Event_Info__c='';
        orderevent.Valid_Event__c=true;
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(orderevent);
        Test.stopTest();
        System.assertEquals(true, sr.isSuccess());
        
    }
}