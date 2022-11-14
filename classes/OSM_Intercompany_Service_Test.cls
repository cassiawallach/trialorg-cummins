//Updated on 04/04/2022
@istest
public class OSM_Intercompany_Service_Test {
    static testMethod void testMethod1(){
        string json='{"R_PARTSLIST_SUBMIT": [{"UOM": "Each","SELLING_PRICE": 0,"QUANTITY": 5,"PRODUCT": "MRKTPLC","NONSTOCK_TYPE": "","LINE_TYPE": "","ITEM_NUMBER": "FLTCNT-12345-1","ITEM_COST": 50,"DESCRIPTION": "Fleet Count","CUSTOMER_PO_NUMBER": "","Attribute03": 0,"Attribute02": 0,"Attribute01": 0}],"Header": {"Target": {"TargetID": "BMS"},"Sender": {"ServiceName": "IntercompanyRequest","SenderID": "MRKTPLC"}},"DataArea": {"LocationID": "02850-02850","CustomerCode": "35565","Attribute03": "","Attribute02": "","Attribute01": 0},"CInvoice_Header": [{"PO_VENDOR": "","ORDER_SOURCE_TYPE": "OSM","INVOICE_TOTAL": 0,"ICInvoice_Number": "00012188","ICInvoice_Date": "2020-03-10","CREDIT_MEMO": "","BRANCH_LOCATION": "S1","BMS_PO_NUMBER": "S1S1016738","BMS_OE_REFERENCE": 222979,"BMS_INVOICE_NUMBER": 33788,"Attribute03": "","Attribute02": "","Attribute01": 0}],"ChargeList": [{"MISC_CHARGE_AMOUNT": 0,"MISC_CHARGE": "","Attribute02": 0,"Attribute01": 0}] }';
        OSM_Intercompany_Generalized_REQ req = OSM_Intercompany_Generalized_REQ.parse(json);
        OSM_Intercompany_Service.callIntercompanyService(req,true,true);
        OSM_Intercompany_Service.callIntercompanyService(req,false,true);
        OSM_Intercompany_Service.callIntercompanyService(req,true,false);
        OSM_Intercompany_Service.callIntercompanyService(req,false,false);
        OSM_Intercompany_Helper.populateRequestObjectData(req);
        
    }
    static testMethod void testMethod2(){
        string json='{"R_PARTSLIST_SUBMIT": [{"UOM": "Each","SELLING_PRICE": 0,"QUANTITY": 5,"PRODUCT": "MRKTPLC","NONSTOCK_TYPE": "","LINE_TYPE": "","ITEM_NUMBER": "FLTCNT-12345-1","ITEM_COST": 50,"DESCRIPTION": "Fleet Count","CUSTOMER_PO_NUMBER": "","Attribute03": 0,"Attribute02": 0,"Attribute01": 0}],"Header": {"Target": {"TargetID": "BMS"},"Sender": {"ServiceName": "IntercompanyRequest","SenderID": "MRKTPLC"}},"DataArea": {"LocationID": "02850-02850","CustomerCode": "35565","Attribute03": "","Attribute02": "","Attribute01": 0},"CInvoice_Header": [{"PO_VENDOR": "","ORDER_SOURCE_TYPE": "OSM","INVOICE_TOTAL": 0,"ICInvoice_Number": "00012188","ICInvoice_Date": "2020-03-10","CREDIT_MEMO": "","BRANCH_LOCATION": "S1","BMS_PO_NUMBER": "S1S1016738","BMS_OE_REFERENCE": 222979,"BMS_INVOICE_NUMBER": 33788,"Attribute03": "","Attribute02": "","Attribute01": 0}],"ChargeList": [{"MISC_CHARGE_AMOUNT": 0,"MISC_CHARGE": "","Attribute02": 0,"Attribute01": 0}] }';
        OSM_Intercompany_Generalized_REQ req = OSM_Intercompany_Generalized_REQ.parse(json);
        CSS_Integration_Details__c conDetails4 = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails4.name = 'OSM_InvoiceAuth';
        conDetails4.End_Point__c = 'http://example.com/example/test3';
        conDetails4.Resource__c = 'http://example.com/example/test2';
        conDetails4.Username__c= 'appSubscription-api-key';
        conDetails4.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails4;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'CSO_IntraCompanyInv';
        conDetails.End_Point__c = 'http://example.com/example/test';
        conDetails.Resource__c = 'http://example.com/example/test2';
        conDetails.Username__c= 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        conDetails.AuthEnv__c = 'OSM_InvoiceAuth';
        conDetails.Method_Type__c = 'POST';
        insert conDetails;
        
        Test.setMock(HttpCalloutMock.class, new Mock_OSM_MuleSoft_MW_Services(Label.CSO_IntraCompanyInv));
        Test.startTest();
        OSM_Intercompany_Service.callIntercompanyService(req,true,true);
        /*OSM_Intercompany_Service.callIntercompanyService(req,false,true);
        OSM_Intercompany_Service.callIntercompanyService(req,true,false);
        OSM_Intercompany_Service.callIntercompanyService(req,false,false);*/
        Test.stopTest();
        OSM_Intercompany_Helper.populateRequestObjectData(req);
    }
}