Public Class IAM_SOAP_Logout{
@TestVisible private static String sendLoginRequest(String un,String pw,String domain){
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://' + domain + '.salesforce.com/services/Soap/u/30.0');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', '""');
        request.setBody('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:enterprise.soap.sforce.com"><soapenv:Header><urn:SessionHeader><urn:sessionId>?</urn:sessionId></urn:SessionHeader></soapenv:Header><soapenv:Body><urn:logout/></soapenv:Body></soapenv:Envelope>');
        
        Http h = new Http();
        System.debug('Printing body'+request);
        HttpResponse res = h.send(request);
        System.debug('Printing response code'+res.getBody());
        return res.getBody();
       
    }
 }