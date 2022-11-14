@isTest
public class dbu_Integration_ESNSearch_Test {
    
    static testmethod void method1(){
        //added by saikomal  
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='dbu_ESNSearchCallout';
        conDetails.End_Point__c= 'https://api-ue-stgnf4-aw-ex.cummins.com/pcc/v1/catalogs/partlists?esn=';
        conDetails.Method_Type__c= 'GET';
        conDetails.grant_type__c= 'application/json';
        insert conDetails;
        system.debug('sleepy hollow');
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name='dbu_ESNSearch_AccessToken';
        conDetails1.End_Point__c= 'https://api-ue-stgnf4-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        conDetails1.Method_Type__c= 'POST';
        conDetails1.grant_type__c= 'application/json';
        conDetails1.Key__c ='122c334d-a6a9-4d7f-bfae-78b78902b04d';
        conDetails1.Passcode__c='69veMf-iaMv-CiDIpkM-X_9-84te5X.-l_';
        insert conDetails1;
        
         HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
       // response.setBody(JSON.serialize(edqResposeWrapper));
        response.setBody('{"Header": {"MessageIdentifier": "1-8124c200-3b7e-11eb-9c51-02bd531db0d8","ReturnCode": "PARTLIST001","ReturnCodeDescription": "PartsList retrievedsuccessfully","Status": "SUCCESS","MessageType": "S"},"DataArea": {"PartLists": [{"ESN": "79464646","Parts": [{"Number": "3687580", "Description": "Studded Flange Cap Screw","Systems": ["DRIVES AND MOUNTINGS"]},{ "Number": "3171713","Description": "Hexagon Flange Head Cap Screw","Systems": ["DRIVES AND MOUNTINGS"]},],"Kits": [{"Number": "2881766","Description": "KIT,LOWER ENGINE GASKET"},],"Gaskets": [{"Number": "2881766","Description": "KIT,LOWER ENGINE GASKET"},{"Number": "4376104","Description": "KIT,UPPER ENGINE GASKET"}]}]}}');
       
        
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new dbu_Integration_ESNSearch_Mock()); 
        dbu_Integration_ESNSearch.getAccessToken();
        
        
        dbu_Integration_ESNSearch.getEsnResult('79464646');
        dbu_Integration_ESNSearch.test();
        test.stopTest();
    }
}