public class GOMS_Integration_BaseClass {
    public static void callIntegrationMethod(Set<Id> set_InvoiceId, boolean isCancelReq){
        for(Id invoiceId : set_InvoiceId){
            OSM_GOMS_InvoiveIdIntegration.callGOMSService(invoiceId, isCancelReq);
        }
    }
}