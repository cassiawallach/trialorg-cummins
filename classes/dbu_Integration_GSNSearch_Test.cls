@isTest
//2.0
public class dbu_Integration_GSNSearch_Test {
    
    static testmethod void method1(){
        
          CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
          conDetails.Name='dbu_GSNSearchCallout';
          conDetails.End_Point__c= 'https://api-ue-devnf4-aw-ex.cummins.com:443/pcc/v1/catalogs/partlists/gsnsearch?gsn=';
          conDetails.Method_Type__c= 'GET';
          conDetails.grant_type__c= 'application/json';
       insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name='dbu_GSNSearch_AccessToken';
        conDetails1.End_Point__c= 'https://api-ue-devnf4-aw-ex.cummins.com:443/api/core-security-api/v1/auth/token	';
        conDetails1.Method_Type__c= 'POST';
        conDetails1.grant_type__c= 'application/json';
        conDetails1.Key__c ='b7922fab-cacb-4e10-a9b2-15e1a7ff2641';
        conDetails1.Passcode__c='H4C3Ww1f~uRf5PIv6gi.fCdM4.f8l.u_YV';
        insert conDetails1;
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
     // response.setBody(JSON.serialize(edqResposeWrapper));
        response.setBody('{"Header": {"MessageIdentifier": "1-8124c200-3b7e-11eb-9c51-02bd531db0d8","ReturnCode": "PARTLIST001","ReturnCodeDescription": "PartsList retrievedsuccessfully","Status": "SUCCESS","MessageType": "S"},"DataArea": {"PartLists": [{"ESN": "79464646","Parts": [{"Number": "3687580", "Description": "Studded Flange Cap Screw","Systems": ["DRIVES AND MOUNTINGS"]},{ "Number": "3171713","Description": "Hexagon Flange Head Cap Screw","Systems": ["DRIVES AND MOUNTINGS"]},],"Kits": [{"Number": "2881766","Description": "KIT,LOWER ENGINE GASKET"},],"Gaskets": [{"Number": "2881766","Description": "KIT,LOWER ENGINE GASKET"},{"Number": "4376104","Description": "KIT,UPPER ENGINE GASKET"}]}]}}');
        //response.setBody('{"esn": 79929608,"vin": "3HTDTAPT7HN707018"}');
        
        test.starttest();
        Test.setMock(HttpCalloutMock.class, new dbu_Integration_GSNSearch_Mock()); 
        dbu_Integration_GSNSearch.getAccessToken();
        dbu_Integration_GSNSearch.getGSNResult('e160961329');
        dbu_Integration_GSNSearch.test();
        test.stopTest();
        
    }
}