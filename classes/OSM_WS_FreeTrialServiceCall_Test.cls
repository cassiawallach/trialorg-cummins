@isTest
global class OSM_WS_FreeTrialServiceCall_Test{

    public static testMethod void freetrialTest(){
            
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'GetOrder';
        csInt.ApplicationName__c='GetOrder';
        csInt.End_Point__c='https://connectedsolutions-dev.cummins.com/appSubscriptionInternal/v1/subscription/orderUpdates ';
        csInt.AuthEnv__c='DA';
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'DA';
        conDetails.Key__c = 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails;
        
        String reqJson = '{'+
            '   \"timeStamp\": \"2018-09-09T22:10:20.000Z\",'+
            '   \"orderLineItems\": ['+
            '      {'+
            '         \"subscriptionType\": \"Renewal\",'+
            '         \"subscriptionQuantity\": \"10\",'+
            '         \"startDate\": \"2018-09-09T21:34:11.000Z\",'+
            '         \"productID\": \"5678901\",'+
            '         \"pricePerUnit\": null,'+
            '         \"freeTrial\": \"Yes\",'+
            '         \"expirationDate\": \"2018-10-08T22:10:00.000Z\",'+
            '         \"equipmentGroups\": null,'+
            '         \"currencyType\": null'+
            '      }'+
            '   ],'+
            '   \"orderId\": \"SB-0000000809399\",'+
            '   \"nextInvoiceDate\": \"2018-09-09T22:10:20.000Z\",'+
            '   \"messageID\": \"FT2018-09-09T22:10:20.000Z\",'+
            '   \"initiator\": \"OSM\",'+
            '   \"customerId\": \"390\",'+
            '   \"createdDate\": \"2018-09-09T22:10:20.000Z\"'+
            '}';

        OSM_WS_GeneralizedInputWrapper obj = OSM_WS_GeneralizedInputWrapper.parse(reqJson);
        
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductPass());
        OSM_WS_FreeTrialServiceCall.callFreeTrailService(obj);
        test.stoptest();
    }
    
    
    
    public static testMethod void freetrialTest2(){
        
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'GetOrder';
        csInt.ApplicationName__c='GetOrder';
        //csInt.End_Point__c='https://connectedsolutions-dev.cummins.com/appSubscriptionInternal/v1/subscription/orderUpdates   ';
        csInt.AuthEnv__c='DA';
        csInt.IsActive__c=true;
        insert csint;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'DA';
        conDetails.Key__c = 'appSubscription-api-key';
        conDetails.Passcode__c = 'OPJQg+I3X+t8OWbfMJexpQwIGiXRzXKROBieKx/jBlA=';
        insert conDetails;
    
        String reqJson = '{'+
            '   \"timeStamp\": \"2018-09-09T22:10:20.000Z\",'+
            '   \"orderLineItems\": ['+
            '      {'+
            '         \"subscriptionType\": \"Renewal\",'+
            '         \"subscriptionQuantity\": \"10\",'+
            '         \"startDate\": \"2018-09-09T21:34:11.000Z\",'+
            '         \"productID\": \"5678901\",'+
            '         \"pricePerUnit\": null,'+
            '         \"freeTrial\": \"Yes\",'+
            '         \"expirationDate\": \"2018-10-08T22:10:00.000Z\",'+
            '         \"equipmentGroups\": null,'+
            '         \"currencyType\": null'+
            '      }'+
            '   ],'+
            '   \"orderId\": \"SB-0000000809399\",'+
            '   \"nextInvoiceDate\": \"2018-09-09T22:10:20.000Z\",'+
            '   \"messageID\": \"FT2018-09-09T22:10:20.000Z\",'+
            '   \"initiator\": \"OSM\",'+
            '   \"customerId\": \"39000\",'+
            '   \"createdDate\": \"2018-09-09T22:10:20.000Z\"'+
            '}';

        OSM_WS_GeneralizedInputWrapper obj = OSM_WS_GeneralizedInputWrapper.parse(reqJson); 
        
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductFail());
        OSM_WS_FreeTrialServiceCall.callFreeTrailService(obj);
        test.stoptest();
    }
    
    global class SingleRequestMockProductPass implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(200);
                resp.setBody('{"timeStamp":"2018-09-09T10:56:31.000Z","orderLineItems":[{"subscriptionType":"New","subscriptionQuantity":10,"startDate":"2018-09-09T10:56:30.000Z","productID":"5678901","pricePerUnit":null,"freeTrial":"Yes","expirationDate":"2018-10-09T10:56:30.000Z","equipmentGroups":null,"currencyType":null}],"orderId":"SB-0000000804391","nextInvoiceDate":"2018-09-09T10:56:31.000Z","messageID":"FT2018-09-09T10:56:31.000Z","initiator":"OSM","customerId":"39000","createdDate":"2018-09-09T10:56:31.000Z"}');
                return resp;
            }
    }   
    
    global class SingleRequestMockProductFail implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(400);
                resp.setBody('{"errorCode":"VALERR-001","errorDescription":"Invalid CustomerID","errorLocation":"customerInformationData"}');
                return resp;
            }
    }

        
}