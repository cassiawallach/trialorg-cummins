@isTest
global class CSS_WWSPSMockResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res;
        if((req.getEndpoint()).contains('token')){
            // Create a fake response for access token 
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"YDrDcBwK3v5Z4knPMqw8LJuyk175erFKJxPdxN81nzfIrVKVO0prWS","token_type":"Bearer","expires_in":1200,"refresh_token":"1bdLXFA0rwhWAMWYMhyLPZrcidouGY7zeG6FXOelw2i4nX","scope":"CSSCloud"}');
            res.setStatusCode(200);  
        }
        else if((req.getEndpoint()).contains('getproductcertifications')){
            res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
        	res.setBody('{"DataArea":{"ProductCertifications":[{"DistributorCode":16042,"ProfileStatus":"ACTIVE","CertificationExpiryDate":"2016-03-27T00:00:00.000-04:00","DistributorFlag":"N","ProductDetails":[{"ServiceModel":"QSB6.7 M CM2250","ProductCertificationStatus":"G","TechIDs":{"TechID":["1468","DUMMY"]},"MarketingModel":"MARINE"},{"ServiceModel":"6C8.3","ProductCertificationStatus":"G","TechIDs":{"TechID":["1261","DUMMY"]},"MarketingModel":"MARINE"},{"ServiceModel":"QSM11 CM570","ProductCertificationStatus":"Y","TechIDs":{"TechID":["1273","DUMMY"]},"MarketingModel":"MARINE"},{"ServiceModel":"QSC8.3 CM850","ProductCertificationStatus":"G","TechIDs":{"TechID":["1264","DUMMY"]},"MarketingModel":"MARINE"},{"ServiceModel":"ZEUS 3500","ProductCertificationStatus":"","TechIDs":{"TechID":["DUMMY"]},"MarketingModel":"MARINE"},{"ServiceModel":"QSB5.9 CM850","ProductCertificationStatus":"G","TechIDs":{"TechID":["1264","DUMMY"]},"MarketingModel":"MARINE"},{"ServiceModel":"480 C-E","ProductCertificationStatus":"G","TechIDs":{"TechID":["1266","DUMMY"]},"MarketingModel":"MARINE"},{"ServiceModel":"4B3.9","ProductCertificationStatus":"G","TechIDs":{"TechID":["1261","DUMMY"]},"MarketingModel":"MARINE"},{"ServiceModel":"6B5.9","ProductCertificationStatus":"G","TechIDs":{"TechID":["1261","DUMMY"]},"MarketingModel":"MARINE"},{"ServiceModel":"QSL9 CM850","ProductCertificationStatus":"G","TechIDs":{"TechID":["1264","DUMMY"]},"MarketingModel":"MARINE"}]}]},"Header":{"ReturnCodeDescription":"SUCCESS","Status":"OK","ReturnCode":200,"MessageIdentifier":"2016-06-16T09:35:37.827-04:00"}}');
            res.setStatusCode(200);
        }
       
        return res;
    }
}