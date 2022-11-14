@Istest
Global class SMSWebServiceMockImpl implements WebServiceMock
{
    global void doInvoke(
    Object stub,
    Object request,
    Map<String, Object> response,
    String endpoint,
    String soapAction,
    String requestName,
    String responseNS,
    String responseName,
    String responseType) {
        siebelComAsi.SendSMS_Output_element responseElement=new siebelComAsi.SendSMS_Output_element();
        response.put('response_x', responseElement);
    }
}