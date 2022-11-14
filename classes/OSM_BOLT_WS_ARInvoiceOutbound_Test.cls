//Updated on 04/12/2022
@IsTest
public class OSM_BOLT_WS_ARInvoiceOutbound_Test {
    
    static testmethod void testCallARInvoice(){
         String json = '{'+
        '  \"DataArea\": {'+
        '    \"AR_INV_INBND_STG_ROW\": {'+
        '      \"AMOUNT\": \"1134.44\",'+
        '      \"SIGN\": null,'+
        '      \"INTERFACE_LINE_ATTRIBUTE2\": \"869640563\",'+
        '      \"SEGMENT4\": \"0020009\",'+
        '      \"SEGMENT5\": \"000\",'+
        '      \"CURRENCY_CODE\": \"USD\",'+
        '      \"CUST_TRX_TYPE_NAME\": \"869511d\",'+
        '      \"TRX_TYPE\": null,'+
        '      \"BILL_TO_CUSTOMER_NUM\": \"05037\",'+
        '      \"TRX_DATE\": \"09-FEB-2018\",'+
        '      \"TRX_NUMBER\": \"869640563\",'+
        '      \"ORIG_SYSTEM_BILL_ADDRESS_REF\": \"03933B\",'+
        '      \"CREATION_DATE\": null,'+
        '      \"BATCH_NUMBER\": \"839\",'+
        '      \"BATCH_DATE\": \"09-FEB-2018\",'+
        '      \"ORACLE_CUSTOMER_NUMBER\": \"327580\",'+
        '      \"TERM_NAME\": \"021\"'+
        '    }'+
        '  }'+
        '}';
        
         
        
        OSM_BOLT_WS_GeneralizedInputWrapper obj = OSM_BOLT_WS_GeneralizedInputWrapper.parse(json);
        System.assert(obj != null);
        
        OSM_BOLT_WS_ARInvoiceOutboundRes resWrapper = OSM_BOLT_WS_ARInvoiceOutbound.callARInvoice(obj);
        
        OSM_BOLT_WS_ARInvoiceOutboundReq reqJSONwrapper = new OSM_BOLT_WS_ARInvoiceOutboundReq(); 

        reqJSONwrapper  = OSM_BOLT_WS_ARInvoiceOutbound.prepareReqWrapper(obj);
        
        OSM_WS_IP_CSWrapper requestWrap = new OSM_WS_IP_CSWrapper();
        requestWrap.jsonReqBody = json;
        requestWrap.serviceName = 'getARInvoice'; //As in custom setting - Service Name
        requestWrap.AuthEnv  = 'OSMBolt'; //As in custom setting - Auth Env
        requestWrap.AccesTokenRequired = true;

         //Create Custom setting records
        CSS_Integration_Details__c cd = new CSS_Integration_Details__c();
        cd.name = 'getARInvoice';
        cd.ApplicationName__c = 'getAR';
        cd.AuthEnv__c = 'OSMBolt';
        cd.End_Point__c = 'https://services-dev.cummins.com/cso/arinvoice';
        cd.IsActive__c = true;
        cd.Key__c = 'appSubscription-api-key';
        cd.Logging__c = null;
        cd.Method_Type__c = 'POST';
        cd.Passcode__c = null;
        cd.Timeout__c = 120000; 
        cd.Username__c = null;
        insert cd;
        
        CSS_Integration_Details__c cd1 = new CSS_Integration_Details__c();
        cd1.name = 'OSMBolt';
        cd1.ApplicationName__c = 'OSMBolt';
        cd1.AuthEnv__c = null;
        cd1.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/cso';
        cd1.IsActive__c = true;
        cd1.Key__c = '604ffcd5-29fa-49ca-b284-c2250850d1f0';
        cd1.Logging__c = null;
        cd1.Method_Type__c = null;
        cd1.Passcode__c = '79a7327f-86d8-4c15-94fd-fa7a44ca1d41';
        cd1.Timeout__c = null;  
        cd1.Username__c = null;
        insert cd1;
        
        OSM_WS_OP_CSWrapper resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(requestWrap); 
    }
}