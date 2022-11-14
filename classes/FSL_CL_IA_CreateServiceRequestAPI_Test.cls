/************************************************************************************FSL_CL_IAUtility
Name: FSL_CL_IA_CreateServiceRequestAPI_Test
Copyright © 2019  Cummins

===============================================================================================
===============================================================================================
Purpose:    This class contains utility method to process IA logic 
===============================================================================================
===============================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Lochana Rajput    07/11/2022     Added test method to test ABRFLag and TransactionID fields
*************************************************************************************************** */
/*** Adding comment for deploying changes --- Sriprada */ 
@isTest
public class FSL_CL_IA_CreateServiceRequestAPI_Test {
    
     //Rajashekar N ; 09/09/2020 ; CT2-146
    @isTest
    public static void createServiceRequestTest() {
         Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        Case ca = new Case(Subject='Test Controller Acct Case');
        ca.IAS_Number__c = 'Test123';
        ca.Available_for_Service__c = System.now();
        insert ca;
        String workOrder = ca.CaseNumber;
          
        String jSONRequestBody = '{'+
            '   \"DataArea\":{'+
            '      \"iasNumber\":\"IAS-031820000123\",'+
            '      \"woNumber\":\"'+workOrder+'",'+
            '      \"woEnabled\":\"Y\",'+
            '      \"psn\":\"73806085\",'+
            '      \"ert\":\"1441238400\",'+
            '      \"serviceModelName\":\"ISX15 CM2350 X101\",'+
            '      \"make\":\"OISA / BUSSCAR\",'+
            '      \"model\":\"URBANUSS\",'+
            '      \"access\":\"B\",'+
            '      \"userLocation\":\"56153-39747\",'+
            '      \"customerName\":\"Rajesh Test\",'+
            '      \"complaintText\":\"Complaint1\",'+
            '      \"productType\":\"\",'+
            '      \"faultType\":1,'+
            '      \"FaultList\":['+
            '         {'+
            '            \"SPN\":\"612\",'+
            '            \"FMI\":\"2\",'+
            '            \"LanguageKey\":\"en\",'+
            '            \"count\":2,'+
            '            \"PCode\":\"P0008\",'+
            '            \"fc\":125,'+
            '            \"occurenceTime\":\"1441238400\",'+
            '            \"status\":\"Active\"'+
            '         },'+
            '         {'+
            '            \"SPN\":\"629\",'+
            '            \"FMI\":\"12\",'+
            '            \"LanguageKey\":\"en\",'+
            '            \"count\":4,'+
            '            \"PCode\":\"P0606\",'+
            '            \"fc\":336,'+
            '            \"occurenceTime\":\"1441237420\",'+
            '            \"status\":\"Active\"'+
            '         },'+
            '         {'+
            '            \"SPN\":\"102\",'+
            '            \"FMI\":\"4\",'+
            '            \"LanguageKey\":\"en\",'+
            '            \"count\":4,'+
            '            \"PCode\":\"P0107\",'+
            '            \"fc\":3382,'+
            '            \"occurenceTime\":\"1441237420\",'+
            '            \"status\":\"Active\"'+
            '         },'+
            '         {'+
            '            \"SPN\":\"723\",'+
            '            \"FMI\":\"7\",'+
            '            \"LanguageKey\":\"en\",'+
            '            \"count\":4,'+
            '            \"PCode\":\"P0016\",'+
            '            \"fc\":3383,'+
            '            \"occurenceTime\":1441237420,'+
            '            \"status\":\"Active\"'+
            '         },'+
            '         {'+
            '            \"SPN\":\"723\",'+
            '            \"FMI\":\"7\",'+
            '            \"LanguageKey\":\"en\",'+
            '            \"count\":4,'+
            '            \"PCode\":\"P0016\",'+
            '            \"fc\":195,'+
            '            \"occurenceTime\":1441237420,'+
            '            \"status\":\"Active\"'+
            '         }'+
            '      ],'+
            '      \"ecmCode\":\"\",'+
            '      \"psbuPlant\":\"\",'+
            '      \"psbuModel\":\"\",'+
            '      \"psbuSpec\":\"\",'+
            '      \"severity\":\"Service Soon\",'+
            '      \"languageKey\":\"en\",'+
            '      \"prioritizedData\":['+
            '         {'+
            '            \"relfc\":['+
            '               {'+
            '				'+
            '               }'+
            '            ],'+
            '            \"FMI\":7,'+
            '            \"rc3Likelihood\":\"21%\",'+
            '            \"rc4Likelihood\":\"\",'+
            '            \"count\":4,'+
            '            \"Severity\":\"Service Soon\",'+
            '            \"occurenceTime\":1441237420,'+
            '            \"SPN\":723,'+
            '            \"rootCause1\":\"Coolant Level Sensor\",'+
            '            \"rootCause2\":\"OEM Wiring Harness\",'+
            '            \"rootCause3\":\"Electrical Connector\",'+
            '            \"DerateValue1\":\"\",'+
            '            \"rootCause4\":\"\",'+
            '            \"DerateValue3\":\"\",'+
            '            \"DerateValue2\":\"\",'+
            '            \"rc1Likelihood\":\"39%\",'+
            '            \"PCode\":\"P0016\",'+
            '            \"prifc\":\"195\",'+
            '            \"PrimaryFaultCodeDescription\":\"Coolant Level Sensor 1 Circuit - Voltage Above Normal or Shorted to High Source\",'+
            '            \"rc2Likelihood\":\"24%\",'+
            '            \"ShutdownDescription\":\"\",'+
            '            \"lhrprob\":{'+
            '               \"lbrprob2\":\"34\",'+
            '               \"lbrprob1\":\"47\",'+
            '               \"lbrprob4\":\"10\",'+
            '               \"lbrprob3\":\"9\"'+
            '            },'+
            '            \"status\":\"Active\"'+
            '         },'+
            '         {'+
            '            \"relfc\":['+
            '               {'+
            '                  \"FMI\":4,'+
            '                  \"count\":4,'+
            '                  \"Severity\":\"Service Soon\",'+
            '                  \"occurenceTime\":1441237420,'+
            '                  \"rfc\":\"3382\",'+
            '                  \"SPN\":102,'+
            '                  \"DerateValue1\":\"\",'+
            '                  \"DerateValue3\":\"\",'+
            '                  \"DerateValue2\":\"\",'+
            '                  \"PCode\":\"P0107\",'+
            '                  \"RelatedFaultCodeDescription\":\"Engine Exhaust Gas Recirculation (EGR) System - Data Valid But Below Normal Operating Range - Moderately Severe Level\",'+
            '                  \"ShutdownDescription\":\"\",'+
            '                  \"status\":\"Active\"'+
            '               },'+
            '               {'+
            '                  \"FMI\":7,'+
            '                  \"count\":4,'+
            '                  \"Severity\":\"Service Soon\",'+
            '                  \"occurenceTime\":1441237420,'+
            '                  \"rfc\":\"3383\",'+
            '                  \"SPN\":723,'+
            '                  \"DerateValue1\":\"\",'+
            '                  \"DerateValue3\":\"\",'+
            '                  \"DerateValue2\":\"\",'+
            '                  \"PCode\":\"P0016\",'+
            '                  \"RelatedFaultCodeDescription\":\"Engine Exhaust Gas Recirculation (EGR) System - Data Valid But Above Normal Operating Range - Moderately Severe Level\",'+
            '                  \"ShutdownDescription\":\"\",'+
            '                  \"status\":\"Active\"'+
            '               }'+
            '            ],'+
            '            \"FMI\":2,'+
            '            \"rc3Likelihood\":\"15%\",'+
            '            \"rc4Likelihood\":\"13%\",'+
            '            \"count\":2,'+
            '            \"Severity\":\"Service Soon\",'+
            '            \"occurenceTime\":1441238400,'+
            '            \"SPN\":612,'+
            '            \"rootCause1\":\"Intake Manifold Pressure/Temperature Sensor\",'+
            '            \"rootCause2\":\"Air Filter\",'+
            '            \"rootCause3\":\"Turbocharger\",'+
            '            \"DerateValue1\":\"\",'+
            '            \"rootCause4\":\"OEM Component\",'+
            '            \"DerateValue3\":\"\",'+
            '            \"DerateValue2\":\"\",'+
            '            \"rc1Likelihood\":\"31%\",'+
            '            \"PCode\":\"P0008\",'+
            '            \"prifc\":\"125\",'+
            '            \"PrimaryFaultCodeDescription\":\"Intake Manifold 1 Pressure - Data Valid But Below Normal Operating Range - Moderately Severe Level\",'+
            '            \"rc2Likelihood\":\"16%\",'+
            '            \"ShutdownDescription\":\"\",'+
            '            \"lhrprob\":{'+
            '               \"lbrprob2\":\"36\",'+
            '               \"lbrprob1\":\"28\",'+
            '               \"lbrprob4\":\"22\",'+
            '               \"lbrprob3\":\"14\"'+
            '            },'+
            '            \"status\":\"Active\"'+
            '         }'+
            '      ],'+
            '      \"unPrioritizedData\":['+
            '         {'+
            '            \"SPN\":629,'+
            '            \"rc\":\"4\",'+
            '            \"FMI\":12,'+
            '            \"ReasonCodeDescription\":\"Fault code is not applicable to ESN/ SMN\",'+
            '            \"count\":4,'+
            '            \"PCode\":\"P0606\",'+
            '            \"occurenceTime\":1441237420,'+
            '            \"upfc\":\"336\",'+
            '            \"status\":\"Active\"'+
            '         }'+
            '      ],'+
            '      \"userName\":\"pv075\"'+
            '   },'+
            '   \"Header\":{'+
            '      \"serviceName\":\"IASerRequestCreation\",'+
            '      \"serviceVersion\":\"1.0\",'+
            '      \"toolID\":\"Guidanz-Mobile\",'+
            '      \"senderId\":\"pv075\",'+
            '      \"targetID\":\"AWS\"'+
            '   }'+
            '}';
      //  request.requestBody = Blob.valueOf(myJSON());
        RestContext.request = request;
        RestContext.response = response;
       //FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        
       request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
          
        //For convertStringToDecimal method in FSL_CL_IAUtility
        String stringToDecimal = '10.10';
        String stringToDecimalElse = 'TestString';
        FSL_CL_IAUtility.convertStringToDecimal(stringToDecimal);
        FSL_CL_IAUtility.convertStringToDecimal(stringToDecimalElse);
        
        //For isValidDateFormat method in FSL_CL_IAUtility
        String dateValueInput = '10/12/2017';
        String dateValueInputElse = 'NotDate';
        FSL_CL_IAUtility.isValidDateFormat(dateValueInput);
        FSL_CL_IAUtility.isValidDateFormat(dateValueInputElse);
        
        //For getServiceRequestList method in FSL_CL_IAUtility
        FSL_CL_IAUtility.getServiceRequestList('10/12/2017', '1', '05340-05351');
       // FSL_CL_IAUtility.getServiceRequestList('02/27/2020', '', '05340-05351');
        Test.stopTest();
    }
    
    static testMethod void testEditCorrection_method() {
        Test.startTest();
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(True);
        //WorkOrder wo = CSS_TestData.WorkOrder();
        Account a = FSLTestDataSetupCls.createAccountData();
        Asset ast=FSLTestDataSetupCls.createAssetRecord();
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        //Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st);
        Test.stopTest();
    }
    
    @isTest
    public static void validateServiceRequestServiceNameTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","IASNumber":"","WONumber":"","PSN":"123456"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    
    @isTest
    public static void validateServiceRequestServiceVersionTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","IASNumber":"","WONumber":"","PSN":"123456"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    
    @isTest
    public static void validateServiceRequestToolIDTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","IASNumber":"","WONumber":"","PSN":"123456"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    
    @isTest
    public static void validateServiceRequestBodynullTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
        //Request Null Validation
        String jSONRequestBody = '';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        
        //Request Header null Validation
        jSONRequestBody = '{}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    
    @isTest
    public static void validateServiceRequestBodyHeaderTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":"","DataArea":""}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    
    @isTest
    public static void validateServiceRequestUserLocationTest() {
        Test.startTest();
        Account Acc = createAccount();
        Acc.Name = 'Acc-001';
        acc.CSS_DistributorCode__c = '0569';
        acc.FSL_ERP_Customer_Code__c = '0987';
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        //Added:CT3-325
        String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"0569-0987","IASNumber":"IAS-001","WONumber":"","PSN":"123456","PrioritizedData":[{"prifc":"Pri-001"}],"relfc":[{"rfc":"relfc-001"}],"unPrioritizedData":[{"upfc":"Unpri-001"}]}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        
        //Wrong ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"testforwrong","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"0569-0987","IASNumber":"IAS-001","WONumber":"","PSN":"123456"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    
    @isTest
    public static void validateServiceRequestUserLocationTest1() {
        Test.startTest();
        Account Acc = createAccount();
        Acc.Name = 'Acc-001';
        acc.CSS_DistributorCode__c = '0569';
        acc.FSL_ERP_Customer_Code__c = '0987';
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        //Added: CT3-325- Test Coverage
        String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"","IASNumber":"IAS-001","WONumber":"","PSN":"123456","PrioritizedData":[{"prifc":"Pri-001"}],"relfc":[{"rfc":"relfc-001"}],"unPrioritizedData":[{"upfc":"Unpri-001"}]}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    
    @isTest
    public static void validateServiceRequestUserLocationTest2() {
        Test.startTest();
        Account Acc = createAccount();
        Acc.Name = 'Acc-001';
        acc.CSS_DistributorCode__c = '0569';
        acc.FSL_ERP_Customer_Code__c = '0987';
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"0569-098","IASNumber":"IAS-001","WONumber":"","PSN":"123456"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    
    @isTest
    public static void validateServiceRequestIASNumberTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","IASNumber":"","WONumber":"","PSN":"123456"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    
    @isTest
    public static void validateServiceRequestIASNumberTest1() {
        Test.startTest();
        RecordType iaRequestRecTypeId = [SELECT Id,Name
                                         FROM RecordType 
                                         WHERE sObjectType='Case' AND Name='IA Request' LIMIT 1];
        Case objCase = new Case();
        objCase.RecordTypeId = iaRequestRecTypeId.Id;
        objCase.IAS_Number__c = 'IAS00032452';
        insert objCase;
        
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS","SenderId":"rf671"},"DataArea":{"UserLocation":"05340-05351","IASNumber":\"'+objCase.IAS_Number__c+'\","WONumber":"","Username":"Rajashekar","PSN":"79788868","SERVICEMODELNAME":"ISB6.7 CM2350 B101","FaultType":"","ACCESS":"","MAKE":"AH&D","MODEL":"900","ECMCode":"","ProductType":"","PSBUPlant":"","PSBUModel":"","PSBUSpec":"","ERT":"","CustomerName":"Guidanz","ComplaintText":"We are testing","ProdMileage":"1000","ProdMileageUnit":"Miles","ProdHours":"200","WOEnabled":"","Severity":"","LanguageKey":"EN","FAULTLIST":[{"fc":"","SPN":"","FMI":"","PCode":"","occurenceTime":"","Status":"","count":"","LanguageKey":""}],"PrioritizedData":[{"prifc":"1118","SPN":"","FMI":"","PCode":"","PrimaryFaultCodeDescription":"","rootCause1":"black smoke","rc1Likelihood":"20","rootCause2":"fuel pump","rc2Likelihood":"45","rootCause3":"turbo charger","rc3Likelihood":"30","rootCause4":"exhaust leak","rc4Likelihood":"30","lbrprob1":"60","lbrprob2":"45","lbrprob3":"30","lbrprob4":"10","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"LEAK"},{"prifc":"1119","SPN":"","FMI":"","PCode":"","PrimaryFaultCodeDescription":"","rootCause1":"black smoke","rc1Likelihood":"20","rootCause2":"fuel pump","rc2Likelihood":"45","rootCause3":"turbo charger","rc3Likelihood":"30","rootCause4":"exhaust leak","rc4Likelihood":"30","lbrprob1":"60","lbrprob2":"45","lbrprob3":"30","lbrprob4":"10","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"smoke"}],"relfc":[{"rfc":"1118","SPN":"","FMI":"","PCode":"","RelatedFaultCodeDescription":"","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"leak"}],"unPrioritizedData":[{"upfc":"1117","SPN":"","FMI":"","PCode":"","rc":"","ReasonCodeDescription":""}]}}';
        //String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS","SenderId":"rf671"},"DataArea":{"UserLocation":"05340-05351","IASNumber":\"'+objCase.IAS_Number__c+'\","WONumber":"","Username":"Rajashekar","PSN":"79788868","SERVICEMODELNAME":"ISB6.7 CM2350 B101","FaultType":"","ACCESS":"","MAKE":"AH&D","MODEL":"900","ECMCode":"","ProductType":"","PSBUPlant":"","PSBUModel":"","PSBUSpec":"","ERT":"","CustomerName":"Guidanz","ComplaintText":"We are testing","ProdMileage":"1000","ProdMileageUnit":"Miles","ProdHours":"200","WOEnabled":"","Severity":"","LanguageKey":"EN","FAULTLIST":[{"fc":"","SPN":"","FMI":"","PCode":"","occurenceTime":"","Status":"","count":"","LanguageKey":""}],"PrioritizedData":[{"prifc":"1118","SPN":"","FMI":"","PCode":"","PrimaryFaultCodeDescription":"","rootCause1":"black smoke","rc1Likelihood":"20","rootCause2":"fuel pump","rc2Likelihood":"45","rootCause3":"turbo charger","rc3Likelihood":"30","rootCause4":"exhaust leak","rc4Likelihood":"30","lbrprob1":"60","lbrprob2":"45","lbrprob3":"30","lbrprob4":"10","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"LEAK"},{"prifc":"1119","SPN":"","FMI":"","PCode":"","PrimaryFaultCodeDescription":"","rootCause1":"black smoke","rc1Likelihood":"20","rootCause2":"fuel pump","rc2Likelihood":"45","rootCause3":"turbo charger","rc3Likelihood":"30","rootCause4":"exhaust leak","rc4Likelihood":"30","lbrprob1":"60","lbrprob2":"45","lbrprob3":"30","lbrprob4":"10","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"smoke"}],"relfc":[{"rfc":"1118","SPN":"","FMI":"","PCode":"","RelatedFaultCodeDescription":"","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"leak"}],"unPrioritizedData":[{"upfc":"1117","SPN":"","FMI":"","PCode":"","rc":"","ReasonCodeDescription":""}]},"PrioritizedData":{"prifc":"1118","SPN":"","FMI":"","PCode":"","PrimaryFaultCodeDescription":"","rootCause1":"black smoke","rc1Likelihood":"20","rootCause2":"fuel pump","rc2Likelihood":"45","rootCause3":"turbo charger","rc3Likelihood":"30","rootCause4":"exhaust leak","rc4Likelihood":"30","lbrprob1":"60","lbrprob2":"45","lbrprob3":"30","lbrprob4":"10","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"LEAK"}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        
        //Check for isIASNumberExistInGuidanz
        jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","IASNumber":\"'+objCase.IAS_Number__c+'\","WONumber":\"'+objCase.CaseNumber+'\","PSN":"","PrioritizedData":[{"prifc":"Pri-001"}],"relfc":[{"rfc":"relfc-001"}],"unPrioritizedData":[{"upfc":"Unpri-001"}]}}';
        system.debug('jSONRequestBody::::::' + jSONRequestBody);
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        
        //Check for isExistingCase
        jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","IASNumber":"IAS12345","WONumber":\"'+objCase.CaseNumber+'\","PSN":"","PrioritizedData":[{"prifc":"Pri-001"}],"relfc":[{"rfc":"relfc-001"}],"unPrioritizedData":[{"upfc":"Unpri-001"}]}}';
        system.debug('jSONRequestBody::::::' + jSONRequestBody);
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        
        //Check for Asset
        Asset asst = new Asset();
        asst = FSL_TestDataUtility.createAsset();
        jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","IASNumber":\"'+objCase.IAS_Number__c+'\","WONumber":\"'+objCase.CaseNumber+'\","PSN":\"'+asst.Name+'\","PrioritizedData":[{"prifc":"Pri-001"}],"relfc":[{"rfc":"relfc-001"}],"unPrioritizedData":[{"upfc":"Unpri-001"}]}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    
    @isTest
    public static void validateServiceRequestPSNTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","IASNumber":"IAS-001","WONumber":"","PSN":"","PrioritizedData":[{"prifc":"Pri-001"}],"relfc":[{"rfc":"relfc-001"}],"unPrioritizedData":[{"upfc":"Unpri-001"}]},"PrioritizedData":{"prifc":"Pri-001"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        
        FSL_CL_IAUtility.WrapperInput wrapinput = new FSL_CL_IAUtility.WrapperInput();
        wrapinput.Status = 'Test';
        wrapinput.serviceName = 'Test';
        wrapinput.serviceVersion = 'Test';
        wrapinput.returnCodeDescription = 'Test';
        wrapinput.wOEnabled = 'Test';
        wrapinput.IASNumber = 'Test';
        wrapinput.toolID = 'Test';
        wrapinput.senderId = 'Test';
        wrapinput.serviceRequestNumber = 'Test';
        String userIdAdvancedRole = 'test';
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea da = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea();
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.Header   hd = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.Header();
        hd.returnCodeDescription = 'Test';
        hd.senderId = 'Test';
        hd.serviceName = 'Test';
        hd.serviceVersion = 'Test';
        hd.status = 'Test';
        // hd.status = 'Test';
        hd.toolID = 'Test';
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea dd = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea();
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments iaap = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments();
        // List <IAAppointments> iaap = new <IAAppointments>();
        // List<IAAppointments> iaaps = new List<IAAppointments>();
        // IAAppointments iaap = new IAAppointments();
        iaap.availableForService = 'test';
        iaap.complaintText = 'Test';
        iaap.contactFirstName = 'Test';
        iaap.contactLastName = 'Test';
        iaap.customerName = 'Test';
        iaap.psn = '79788868';
        iaap.unitNumber = '110';
        dd.woEnabled = 'Test';
        iaap.woNumber = '00000001';
        List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> imps = new List <FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments>();
       //  FSL_CL_IAUtility.validateCreateServiceRequestAPI('Test');
        List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> validateCreateServiceRequet = new List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments>();
        // iaap.add(iaam);
        Test.stopTest();
    }
    @isTest
    public static void createServiceRequestTest1() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
		
		Operatinghours oh=new operatinghours(name='test');
        insert oh;
        ServiceTerritory st = new ServiceTerritory();
        st.City='Test City Mobile';
        //st.Country='United States';
        st.CountryCode='US';
        st.PostalCode='12345';
        st.State='Alabama';
        st.Name='Test Territory1 Mobile';
        st.Location_Code__c='05340-05351';
        st.OperatingHoursId=oh.id;
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='ABCX';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        Case ca = new Case(Subject='Test Controller Acct Case');
        //ca.RecordTypeId = iaRequestRecTypeId.Id;
        //ca.IAS_Number__c = '';
        ca.Status = 'Intake';
		ca.Customer_Name__c = 'test';
		ca.Available_for_Service__c = System.now();
		ca.Service_Territory__c = st.Id;
		insert ca;  
        
        Account acc = createAccount();
        acc.Name = 'IA Account1';
		//acc.IsPartner = TRUE;
        acc.CSS_DistributorCode__c = '50000';
        acc.CSS_DBCode__c = '05340';
        acc.IAM_Service_Provider_Code__c ='05351';
        acc.FSL_ERP_Customer_Code__c = '09874';
        acc.IA_CSSEnabled__c = TRUE;
        //acc.Location__c = '05694-09874';
        insert acc;
        
        String caseNumber = ca.CaseNumber;        
        String json = '{'+
            '   \"DataArea\":{'+
            '      \"iasNumber\":\"Test123\",'+
            '      \"woNumber\":\"caseNumber\",'+
            '      \"woEnabled\":\"Y\",'+
            '      \"psn\":\"73806085\",'+
            '      \"ert\":\"1441238400\",'+
            '      \"serviceModelName\":\"ISX15 CM2350 X101\",'+
            '      \"make\":\"OISA / BUSSCAR\",'+
            '      \"model\":\"URBANUSS\",'+
            '      \"access\":\"B\",'+
            '      \"userLocation\":\"56153-39747\",'+
            '      \"customerName\":\"Rajesh Test\",'+
            '      \"complaintText\":\"Complaint1\",'+
            '      \"productType\":\"\",'+
            '      \"faultType\":1,'+
            '      \"FaultList\":,'+
            '      \"ecmCode\":\"\",'+
            '      \"psbuPlant\":\"\",'+
            '      \"psbuModel\":\"\",'+
            '      \"psbuSpec\":\"\",'+
            '      \"severity\":\"Service Soon\",'+
            '      \"languageKey\":\"en\",'+
            '      \"prioritizedData\":,'+
            '      \"unPrioritizedData\":,'+
            '      \"userName\":\"pv075\"'+
            '   },'+
            '   \"Header\":{'+
            '      \"serviceName\":\"IASerRequestCreation\",'+
            '      \"serviceVersion\":\"1.0\",'+
            '      \"toolID\":\"Guidanz-Mobile\",'+
            '      \"senderId\":\"pv075\",'+
            '      \"targetID\":\"AWS\"'+
            '   }'+
            '}';
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        //For getServiceRequestList method in FSL_CL_IAUtility
        FSL_CL_IAUtility.getServiceRequestList('10/12/2017', '1', '05340-05351');
       
        FSL_CL_IAUtility.getServiceRequestList('10/12/2017', '', '05340-05351');
        FSL_CL_IAUtility.getServiceRequestList('02/12/2021', '1', '05340-05351');
         FSL_CL_IAUtility.getServiceRequestList('02/12/2021', '', '05340-05351');
        
        Test.stopTest();
    }
    @isTest
    public static void TestIsUserLocationEnabled() {
	Test.startTest();
	 //Check for location where IA_CSSEnabled__c is true
        Account acc = createAccount();
        acc.Name = 'IA Account1';
        acc.CSS_DistributorCode__c = '50000';
        acc.CSS_DBCode__c = '05694';
        acc.IAM_Service_Provider_Code__c ='09874';
        acc.FSL_ERP_Customer_Code__c = '09874';
        acc.IA_CSSEnabled__c = TRUE;
        //acc.Location__c = '05694-09874';
        insert acc;
		
        FSL_CL_IAUtility ia1 = new FSL_CL_IAUtility();
        ia1.isUserLocationEnabled('05694-09874');
        
	//Check for user location where location is null
		FSL_CL_IAUtility ia2 = new FSL_CL_IAUtility();
        ia2.isUserLocationEnabled('');
        
	//Check for user location where IA_CSSEnabled__c is false & location is null
		Account acc1 = createAccount();
        acc1.Name = 'Acc-001';
        acc1.CSS_DistributorCode__c = '50000';
        acc1.CSS_DBCode__c = '56153';
        acc1.IAM_Service_Provider_Code__c ='39747';
        acc1.FSL_ERP_Customer_Code__c = '39747';
        acc1.IA_CSSEnabled__c = FALSE;
        //acc1.Location__c = '56153-39747';
        insert acc1;
		
        FSL_CL_IAUtility ia3 = new FSL_CL_IAUtility();
        ia3.isUserLocationEnabled('56153-39747');
		Test.stopTest();
    }
    @isTest
    private static void testGetSuccessResponse() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_LocationEnabledAPI_MockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/IALocationEnabled/';  //Request URL
        req.httpMethod = 'POST';
        
        //Success
        String jSONRequestBody = '{"Header":{"ServiceName":"IALocationEnabled","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"12/04/2019"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        Test.stopTest();
    }
    
    //Validations Response
    @isTest static void testGetVAlidationsResponse() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_LocationEnabledAPI_MockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/IALocationEnabled/';  //Request URL
        req.httpMethod = 'POST';
        
        //Request Null Validation
        String jSONRequestBody = '';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //Request Header null Validation
        jSONRequestBody = '{}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //Invalid JSON Validation
        jSONRequestBody = '{{"Header":{"ServiceName":"IALocationEnabled","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"12/04/2019"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //Wrong ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"testforwrong","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"12/04/2019"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //ToolID Validation
        // {"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS","SenderId":"rf671"},"DataArea":{"UserLocation":"05340-05351","IASNumber":"+objCase.IAS_Number__c","WONumber":"","Username":"Rajashekar","PSN":"79788868","SERVICEMODELNAME":"ISB6.7 CM2350 B101","FaultType":"","ACCESS":"","MAKE":"AH&D","MODEL":"900","ECMCode":"","ProductType":"","PSBUPlant":"","PSBUModel":"","PSBUSpec":"","ERT":"","CustomerName":"Guidanz","ComplaintText":"We are testing","ProdMileage":"1000","ProdMileageUnit":"Miles","ProdHours":"200","WOEnabled":"","Severity":"","LanguageKey":"EN","FAULTLIST":[{"fc":"","SPN":"","FMI":"","PCode":"","occurenceTime":"","Status":"","count":"","LanguageKey":""}],"PrioritizedData":[{"prifc":"1118","SPN":"","FMI":"","PCode":"","PrimaryFaultCodeDescription":"","rootCause1":"black smoke","rc1Likelihood":"20","rootCause2":"fuel pump","rc2Likelihood":"45","rootCause3":"turbo charger","rc3Likelihood":"30","rootCause4":"exhaust leak","rc4Likelihood":"30","lbrprob1":"60","lbrprob2":"45","lbrprob3":"30","lbrprob4":"10","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"LEAK"},{"prifc":"1119","SPN":"","FMI":"","PCode":"","PrimaryFaultCodeDescription":"","rootCause1":"black smoke","rc1Likelihood":"20","rootCause2":"fuel pump","rc2Likelihood":"45","rootCause3":"turbo charger","rc3Likelihood":"30","rootCause4":"exhaust leak","rc4Likelihood":"30","lbrprob1":"60","lbrprob2":"45","lbrprob3":"30","lbrprob4":"10","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"smoke"}],"relfc":[{"rfc":"1118","SPN":"","FMI":"","PCode":"","RelatedFaultCodeDescription":"","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"leak"}],"unPrioritizedData":[{"upfc":"1117","SPN":"","FMI":"","PCode":"","rc":"","ReasonCodeDescription":""}]}}
        jSONRequestBody = '{"Header":{"ServiceName":"IALocationEnabled","ServiceVersion":"1.0","ToolID":"","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"12/04/2019","unPrioritizedData": [{"upfc": "1117","spn": "","fmi": "","pCode": "","occurenceTime": "","status": "","count": "","rc": "","ReasonCodeDescription": ""}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //CSSJobNumber Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IALocationEnabled","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":""}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //Check for wOEnabled
        Account Acc = createAccount();
        Acc.Name = 'IA Account';
        acc.CSS_DistributorCode__c = '05694';
        acc.FSL_ERP_Customer_Code__c = '09874';
        acc.IA_CSSEnabled__c = TRUE;
        insert acc;
        jSONRequestBody = '{"Header":{"ServiceName":"IALocationEnabled","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"05694-09874"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> validateCreateServiceRequet = new List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments>();
        Test.stopTest();
    }
    
    @isTest
    public static void getServiceRequestTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_GetServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/GetServiceRequestAPI/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"GetServiceRequestAPI","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"01/09/2020","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For null jSONRequestBody
        jSONRequestBody = '';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();       
        
        //For null Header
        jSONRequestBody = '{}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For ServiceName blank in FSL_CL_IAUtility
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"1.0","ToolID":"","TargetID":"CSS"},"DataArea":{"UserLocation":"","CurrentDate":"","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For wrong ServiceName in FSL_CL_IAUtility
        jSONRequestBody = '{"Header":{"ServiceName":"testWrongServiceName","ServiceVersion":"1.0","ToolID":"","TargetID":"CSS"},"DataArea":{"UserLocation":"","CurrentDate":"","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For ToolID blank in FSL_CL_IAUtility
        jSONRequestBody = '{"Header":{"ServiceName":"GetServiceRequestAPI","ServiceVersion":"1.0","ToolID":"","TargetID":"CSS"},"DataArea":{"UserLocation":"","CurrentDate":"","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For UserLocation blank in FSL_CL_IAUtility
        jSONRequestBody = '{"Header":{"ServiceName":"GetServiceRequestAPI","ServiceVersion":"1.0","ToolID":"Guidanz","TargetID":"CSS"},"DataArea":{"UserLocation":"","CurrentDate":"","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For CurrentDate blank in FSL_CL_IAUtility
        jSONRequestBody = '{"Header":{"ServiceName":"GetServiceRequestAPI","ServiceVersion":"1.0","ToolID":"Guidanz","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        FSL_CL_IAUtility.WrapperInput wrapinput = new FSL_CL_IAUtility.WrapperInput();
        wrapinput.Status = 'Test';
        wrapinput.serviceName = 'Test';
        wrapinput.serviceVersion = 'Test';
        wrapinput.returnCodeDescription = 'Test';
        wrapinput.wOEnabled = 'Test';
        wrapinput.IASNumber = 'Test';
        wrapinput.toolID = 'Test';
        wrapinput.senderId = 'Test';
        wrapinput.serviceRequestNumber = 'Test';
        String userIdAdvancedRole = 'test';
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea da = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea();
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.Header   hd = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.Header();
        hd.returnCodeDescription = 'Test';
        hd.senderId = 'Test';
        hd.serviceName = 'Test';
        hd.serviceVersion = 'Test';
        hd.status = 'Test';
        hd.toolID = 'Test';
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea dd = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea();
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments iaap = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments();
        List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> validateCreateServiceRequet = new List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments>();
        
        // List <IAAppointments> iaap = new <IAAppointments>();
        // List<IAAppointments> iaaps = new List<IAAppointments>();
        // IAAppointments iaap = new IAAppointments();
        iaap.availableForService = 'test';
        iaap.complaintText = 'Test';
        iaap.contactFirstName = 'Test';
        iaap.contactLastName = 'Test';
        iaap.customerName = 'Test';
        iaap.psn = '79788868';
        iaap.unitNumber = '110';
        dd.woEnabled = 'Test';
        iaap.woNumber = '00000001';
        List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> imps = new List <FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments>();
        Test.stopTest();
    }
    @isTest
    public static void validateCreateServiceRequestAPITest() {
        Test.startTest();
        Account Acc = createAccount();
        Acc.Name = 'Acc-001';
        acc.CSS_DistributorCode__c = '0569';
        acc.FSL_ERP_Customer_Code__c = '0987';
        insert acc;
        
       RecordType iaRequestRecTypeId = [SELECT Id,Name
                                         FROM RecordType 
                                         WHERE sObjectType='Case' AND Name='IA Request' LIMIT 1];
        Case caseObj = new Case();
        caseObj.RecordTypeId = iaRequestRecTypeId.Id;
        caseObj.IAS_Number__c = 'IAS00032452';
        insert caseObj;
        Case objCase = [SELECT ID,IAS_Number__c,CaseNumber,Status FROM Case WHERE Id =: caseObj.Id];
        
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"0569-098","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    @isTest
    public static void validateCreateServiceRequestAPITest2() {
        Test.startTest();
        asset ast=new asset();
        ast.name='123456';
        ast.Type__c='Engines';
        ast.Make__c='Test1';
        ast.Model__c='test2';
        ast.Service_Model__c='test3';
        insert ast;
        Account Acc = createAccount();
        Acc.Name = 'Acc-001';
        acc.CSS_DistributorCode__c = '0569';
        acc.IAM_Service_Provider_Code__c = '0987';
        insert acc;
   OperatingHours operatingHours = new OperatingHours();
        operatingHours.Name = 'Test OperatingHours';
        operatingHours.Description = 'Test OperatingHours';
        insert operatingHours;
        
        ServiceTerritory serviceTerritory = new ServiceTerritory();
        serviceTerritory.Name = 'Test ServiceTerritory Mobile';
        serviceTerritory.IsActive = true; 
        serviceTerritory.Location_Code__c = '01234-01234';
        serviceTerritory.FSL_Service_Territory_Code__c = '01234';
        serviceTerritory.OperatingHoursId = operatingHours.Id;
        serviceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serviceTerritory.Territory__c = 'AUSTRALIA';
        insert serviceTerritory;      
       
      
        
       RecordType iaRequestRecTypeId = [SELECT Id,Name
                                         FROM RecordType 
                                         WHERE sObjectType='Case' AND Name='IA Request' LIMIT 1];
         Case caseObj = new Case();
        caseObj.RecordTypeId = iaRequestRecTypeId.Id;
        caseObj.IAS_Number__c = 'IAS00032452';
        caseObj.Status = 'Intake';
        caseObj.Make__c='Honda';
        caseObj.Model__c='Civic';
        caseObj.Service_Model__c='isb219351';
        caseObj.AssetId=ast.id;
          insert caseObj;
        
         WorkOrder wo1 = new WorkOrder();
        wo1.ServiceTerritoryId=serviceTerritory.id;
        wo1.AssetId=ast.id;
        wo1.CaseId=caseObj.id;        
        wo1.Status = 'Intake';
         insert wo1;
        
        caseObj.ServiceJob__c=wo1.id;
        update caseObj;
        
        
        Case objCase = [SELECT ID,IAS_Number__c,CaseNumber,Status FROM Case WHERE Id =: caseObj.Id];
        
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
       // String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"0569-098","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456"}}';
     String jSONRequestBody =  '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"0569-098","serviceModelName": "isb219351",    "make": "Honda",   "model": "Civic","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456",}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
     @isTest
    public static void validateCreateServiceRequestAPITest3() {
        Test.startTest();
        Account Acc = createAccount();
        Acc.Name = 'Acc-001';
        acc.CSS_DistributorCode__c = '0569';
        acc.FSL_ERP_Customer_Code__c = '0987';
        insert acc;
         asset ast=new asset();
        ast.name='123456';
        ast.Type__c='Engines';
        ast.Make__c='Test1';
        ast.Model__c='test2';
        ast.Service_Model__c='test3';
        insert ast;
        OperatingHours operatingHours = new OperatingHours();
        operatingHours.Name = 'Test OperatingHours';
        operatingHours.Description = 'Test OperatingHours';
        insert operatingHours;
        
        ServiceTerritory serviceTerritory = new ServiceTerritory();
        serviceTerritory.Name = 'Test ServiceTerritory Mobile';
        serviceTerritory.IsActive = true; 
        serviceTerritory.Location_Code__c = '01234-01234';
        serviceTerritory.FSL_Service_Territory_Code__c = '01234';
        serviceTerritory.OperatingHoursId = operatingHours.Id;
        serviceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serviceTerritory.Territory__c = 'AUSTRALIA';
        insert serviceTerritory; 
        
       RecordType iaRequestRecTypeId = [SELECT Id,Name
                                         FROM RecordType 
                                         WHERE sObjectType='Case' AND Name='IA Request' LIMIT 1];
        Case caseObj = new Case();
        caseObj.RecordTypeId = iaRequestRecTypeId.Id;
        //caseObj.IAS_Number__c = 'IAS00032452';
        caseObj.Status = 'Intake';
        caseObj.AssetId=ast.id;
        insert caseObj;
        Case objCase = [SELECT ID,IAS_Number__c,CaseNumber,Status FROM Case WHERE Id =: caseObj.Id];
        
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"0569-098","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        Test.stopTest();
    }
    @isTest
    public static void validateCreateServiceRequestAPITest4() {
                
          asset ast=new asset();
        ast.name='123456';
        ast.Type__c='Engines';
        ast.Make__c='Test1';
        ast.Model__c='test2';
        ast.Service_Model__c='test3';
        insert ast;
        
       // Account Acc = createAccount();
        Account Acc = new Account();

        Acc.Name = 'Acc-001';
        
        acc.CSS_DistributorCode__c = '0569';
        acc.IAM_Service_Provider_Code__c = '0987';
        //acc.FSL_ERP_Customer_Code__c = '0569';
        insert acc;
       Account accountObj = [SELECT ID,Location__c FROM Account WHERE Id =: acc.Id];
       system.debug('accountObj++++'+accountObj);

        //Create Parent Group
		Group grp = new Group();
		grp.name = accountObj.Location__c;
		grp.Type = 'queue';
		Insert grp; 
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            QueueSobject queueObj = new QueueSobject();
            queueObj.QueueId = grp.Id;
            queueObj.SobjectType = 'Case';
            insert queueObj;
        }
        
       RecordType iaRequestRecTypeId = [SELECT Id,Name
                                         FROM RecordType 
                                         WHERE sObjectType='Case' AND Name='IA Request' LIMIT 1];
        Case caseObj = new Case();
        caseObj.RecordTypeId = iaRequestRecTypeId.Id;
        //caseObj.IAS_Number__c = 'IAS00032452';
        caseObj.Status = 'Intake';
        caseObj.Make__c='Honda';
        caseObj.Model__c='Civic';
        caseObj.Service_Model__c='isb219351';
        caseObj.AssetId=ast.id;
        insert caseObj;
        Case objCase = [SELECT ID,IAS_Number__c,CaseNumber,Status FROM Case WHERE Id =: caseObj.Id];       
        //create work order
        Test.startTest();
        Asset asset = FSLTestDataSetupCls.createAssetRecord();
        ServiceTerritory serviceTerritory = FSLTestDataSetupCls.createServiceTerritory();
       Workorder workOrder = FSLTestDataSetupCls.createWorkOrder(asset, accountObj, serviceTerritory);
        workOrder.CaseId = objCase.Id;
        update workOrder;
        
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
       // String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":\"'+accountObj.Location__c+'\","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456","PrioritizedData":[{"prifc":"Pri-001","lhrprob":{"lbrprob2":"34"}}]}}';
         String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","serviceModelName": "isb219351",    "make": "Honda",    "model": "Civic","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":\"'+accountObj.Location__c+'\","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456","unPrioritizedData": [{"upfc": "1117","spn": "","fmi": "","pCode": "","occurenceTime": "","status": "","count": "","rc": "","ReasonCodeDescription": ""}],"PrioritizedData":[{"prifc":"Pri-001","lhrprob":{"lbrprob2":"34"}}]}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        Test.stopTest();
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        
    } 
	
	//Create Account - sinlge record
    private static Account createAccount() {
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account';
		acc.phone = '6884382997';   
        acc.BillingStreet = 'Test Street';
        acc.BillingCountry = 'United States';
        acc.BillingCity = 'NewYork';
        acc.BillingState = 'Florida';
        acc.BillingPostalCode = '99999';
        return acc;
    }
    public static string myJSON(){
         String jSONRequestBody = '{'+
            '   \"DataArea\":{'+
            '      \"iasNumber\":\"IAS-031820000123\",'+
            '      \"woNumber\":\"\",'+
            '      \"woEnabled\":\"Y\",'+
            '      \"psn\":\"73806085\",'+
            '      \"ert\":\"1441238400\",'+
            '      \"serviceModelName\":\"ISX15 CM2350 X101\",'+
            '      \"make\":\"OISA / BUSSCAR\",'+
            '      \"model\":\"URBANUSS\",'+
            '      \"access\":\"B\",'+
            '      \"userLocation\":\"56153-39747\",'+
            '      \"customerName\":\"Rajesh Test\",'+
            '      \"complaintText\":\"Complaint1\",'+
            '      \"productType\":\"\",'+
            '      \"faultType\":1,'+
            '      \"FaultList\":['+
            '         {'+
            '            \"SPN\":\"612\",'+
            '            \"FMI\":\"2\",'+
            '            \"LanguageKey\":\"en\",'+
            '            \"count\":2,'+
            '            \"PCode\":\"P0008\",'+
            '            \"fc\":125,'+
            '            \"occurenceTime\":\"1441238400\",'+
            '            \"status\":\"Active\"'+
            '         },'+
            '         {'+
            '            \"SPN\":\"629\",'+
            '            \"FMI\":\"12\",'+
            '            \"LanguageKey\":\"en\",'+
            '            \"count\":4,'+
            '            \"PCode\":\"P0606\",'+
            '            \"fc\":336,'+
            '            \"occurenceTime\":\"1441237420\",'+
            '            \"status\":\"Active\"'+
            '         },'+
            '         {'+
            '            \"SPN\":\"102\",'+
            '            \"FMI\":\"4\",'+
            '            \"LanguageKey\":\"en\",'+
            '            \"count\":4,'+
            '            \"PCode\":\"P0107\",'+
            '            \"fc\":3382,'+
            '            \"occurenceTime\":\"1441237420\",'+
            '            \"status\":\"Active\"'+
            '         },'+
            '         {'+
            '            \"SPN\":\"723\",'+
            '            \"FMI\":\"7\",'+
            '            \"LanguageKey\":\"en\",'+
            '            \"count\":4,'+
            '            \"PCode\":\"P0016\",'+
            '            \"fc\":3383,'+
            '            \"occurenceTime\":1441237420,'+
            '            \"status\":\"Active\"'+
            '         },'+
            '         {'+
            '            \"SPN\":\"723\",'+
            '            \"FMI\":\"7\",'+
            '            \"LanguageKey\":\"en\",'+
            '            \"count\":4,'+
            '            \"PCode\":\"P0016\",'+
            '            \"fc\":195,'+
            '            \"occurenceTime\":1441237420,'+
            '            \"status\":\"Active\"'+
            '         }'+
            '      ],'+
            '      \"ecmCode\":\"\",'+
            '      \"psbuPlant\":\"\",'+
            '      \"psbuModel\":\"\",'+
            '      \"psbuSpec\":\"\",'+
            '      \"severity\":\"Service Soon\",'+
            '      \"languageKey\":\"en\",'+
            '      \"prioritizedData\":['+
            '         {'+
            '            \"relfc\":['+
            '               {'+
            '				'+
            '               }'+
            '            ],'+
            '            \"FMI\":7,'+
            '            \"rc3Likelihood\":\"21%\",'+
            '            \"rc4Likelihood\":\"\",'+
            '            \"count\":4,'+
            '            \"Severity\":\"Service Soon\",'+
            '            \"occurenceTime\":1441237420,'+
            '            \"SPN\":723,'+
            '            \"rootCause1\":\"Coolant Level Sensor\",'+
            '            \"rootCause2\":\"OEM Wiring Harness\",'+
            '            \"rootCause3\":\"Electrical Connector\",'+
            '            \"DerateValue1\":\"\",'+
            '            \"rootCause4\":\"\",'+
            '            \"DerateValue3\":\"\",'+
            '            \"DerateValue2\":\"\",'+
            '            \"rc1Likelihood\":\"39%\",'+
            '            \"PCode\":\"P0016\",'+
            '            \"prifc\":\"195\",'+
            '            \"PrimaryFaultCodeDescription\":\"Coolant Level Sensor 1 Circuit - Voltage Above Normal or Shorted to High Source\",'+
            '            \"rc2Likelihood\":\"24%\",'+
            '            \"ShutdownDescription\":\"\",'+
            '            \"lhrprob\":{'+
            '               \"lbrprob2\":\"34\",'+
            '               \"lbrprob1\":\"47\",'+
            '               \"lbrprob4\":\"10\",'+
            '               \"lbrprob3\":\"9\"'+
            '            },'+
            '            \"status\":\"Active\"'+
            '         },'+
            '         {'+
            '            \"relfc\":['+
            '               {'+
            '                  \"FMI\":4,'+
            '                  \"count\":4,'+
            '                  \"Severity\":\"Service Soon\",'+
            '                  \"occurenceTime\":1441237420,'+
            '                  \"rfc\":\"3382\",'+
            '                  \"SPN\":102,'+
            '                  \"DerateValue1\":\"\",'+
            '                  \"DerateValue3\":\"\",'+
            '                  \"DerateValue2\":\"\",'+
            '                  \"PCode\":\"P0107\",'+
            '                  \"RelatedFaultCodeDescription\":\"Engine Exhaust Gas Recirculation (EGR) System - Data Valid But Below Normal Operating Range - Moderately Severe Level\",'+
            '                  \"ShutdownDescription\":\"\",'+
            '                  \"status\":\"Active\"'+
            '               },'+
            '               {'+
            '                  \"FMI\":7,'+
            '                  \"count\":4,'+
            '                  \"Severity\":\"Service Soon\",'+
            '                  \"occurenceTime\":1441237420,'+
            '                  \"rfc\":\"3383\",'+
            '                  \"SPN\":723,'+
            '                  \"DerateValue1\":\"\",'+
            '                  \"DerateValue3\":\"\",'+
            '                  \"DerateValue2\":\"\",'+
            '                  \"PCode\":\"P0016\",'+
            '                  \"RelatedFaultCodeDescription\":\"Engine Exhaust Gas Recirculation (EGR) System - Data Valid But Above Normal Operating Range - Moderately Severe Level\",'+
            '                  \"ShutdownDescription\":\"\",'+
            '                  \"status\":\"Active\"'+
            '               }'+
            '            ],'+
            '            \"FMI\":2,'+
            '            \"rc3Likelihood\":\"15%\",'+
            '            \"rc4Likelihood\":\"13%\",'+
            '            \"count\":2,'+
            '            \"Severity\":\"Service Soon\",'+
            '            \"occurenceTime\":1441238400,'+
            '            \"SPN\":612,'+
            '            \"rootCause1\":\"Intake Manifold Pressure/Temperature Sensor\",'+
            '            \"rootCause2\":\"Air Filter\",'+
            '            \"rootCause3\":\"Turbocharger\",'+
            '            \"DerateValue1\":\"\",'+
            '            \"rootCause4\":\"OEM Component\",'+
            '            \"DerateValue3\":\"\",'+
            '            \"DerateValue2\":\"\",'+
            '            \"rc1Likelihood\":\"31%\",'+
            '            \"PCode\":\"P0008\",'+
            '            \"prifc\":\"125\",'+
            '            \"PrimaryFaultCodeDescription\":\"Intake Manifold 1 Pressure - Data Valid But Below Normal Operating Range - Moderately Severe Level\",'+
            '            \"rc2Likelihood\":\"16%\",'+
            '            \"ShutdownDescription\":\"\",'+
            '            \"lhrprob\":{'+
            '               \"lbrprob2\":\"36\",'+
            '               \"lbrprob1\":\"28\",'+
            '               \"lbrprob4\":\"22\",'+
            '               \"lbrprob3\":\"14\"'+
            '            },'+
            '            \"status\":\"Active\"'+
            '         }'+
            '      ],'+
            '      \"unPrioritizedData\":['+
            '         {'+
            '            \"SPN\":629,'+
            '            \"rc\":\"4\",'+
            '            \"FMI\":12,'+
            '            \"ReasonCodeDescription\":\"Fault code is not applicable to ESN/ SMN\",'+
            '            \"count\":4,'+
            '            \"PCode\":\"P0606\",'+
            '            \"occurenceTime\":1441237420,'+
            '            \"upfc\":\"336\",'+
            '            \"status\":\"Active\"'+
            '         }'+
            '      ],'+
            '      \"userName\":\"pv075\"'+
            '   },'+
            '   \"Header\":{'+
            '      \"serviceName\":\"IASerRequestCreation\",'+
            '      \"serviceVersion\":\"1.0\",'+
            '      \"toolID\":\"Guidanz-Mobile\",'+
            '      \"senderId\":\"pv075\",'+
            '      \"targetID\":\"AWS\"'+
            '   }'+
            '}';
        return jSONRequestBody ;
    }
    @isTest
    public static void createServiceRequestTest2() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
        Operatinghours oh=new operatinghours(name='test');
        insert oh;
        ServiceTerritory st = new ServiceTerritory();
        st.City='Test City Mobile';
        //st.Country='United States';
        st.CountryCode='US';
        st.PostalCode='12345';
        st.State='Alabama';
        st.Name='Test Territory1 Mobile';
        st.Location_Code__c='05340-05351';
        st.OperatingHoursId=oh.id;
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='ABCX';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
		Case ca = new Case(Subject='Test Controller Acct Case');
        //ca.RecordTypeId = iaRequestRecTypeId.Id;
        ca.IAS_Number__c = '';
        ca.Status = 'Intake';
		ca.Customer_Name__c = 'test';
		//ca.Available_for_Service__c = '';
		ca.CreatedDate = System.now();
		ca.Service_Territory__c = st.Id;
		insert ca;        
        
		Account acc = createAccount();
        acc.Name = 'IA Account1';
		//acc.IsPartner = TRUE;
        acc.CSS_DistributorCode__c = '50000';
        acc.CSS_DBCode__c = '05340';
        acc.IAM_Service_Provider_Code__c ='05351';
        acc.FSL_ERP_Customer_Code__c = '09874';
        acc.IA_CSSEnabled__c = TRUE;
        //acc.Location__c = '05694-09874'; '05340-05351'
        insert acc;
		
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact c = New Contact(LastName = 'Test',FirstName = 'Con1', AccountID = acc.id, RecordTypeId=conRecId);
		insert c;
        
        User newUser = createPartnerUser(c.id);
        
        
        String caseNumber = ca.CaseNumber;        
        String json = '{'+
            '   \"DataArea\":{'+
            '      \"iasNumber\":\"Test123\",'+
            '      \"woNumber\":\"caseNumber\",'+
            '      \"woEnabled\":\"Y\",'+
            '      \"psn\":\"73806085\",'+
            '      \"ert\":\"1441238400\",'+
            '      \"serviceModelName\":\"ISX15 CM2350 X101\",'+
            '      \"make\":\"OISA / BUSSCAR\",'+
            '      \"model\":\"URBANUSS\",'+
            '      \"access\":\"B\",'+
            '      \"userLocation\":\"56153-39747\",'+
            '      \"customerName\":\"Rajesh Test\",'+
            '      \"complaintText\":\"Complaint1\",'+
            '      \"productType\":\"\",'+
            '      \"faultType\":1,'+
            '      \"FaultList\":,'+
            '      \"ecmCode\":\"\",'+
            '      \"psbuPlant\":\"\",'+
            '      \"psbuModel\":\"\",'+
            '      \"psbuSpec\":\"\",'+
            '      \"severity\":\"Service Soon\",'+
            '      \"languageKey\":\"en\",'+
            '      \"prioritizedData\":,'+
            '      \"unPrioritizedData\":,'+
            '      \"userName\":\"pv075\"'+
            '   },'+
            '   \"Header\":{'+
            '      \"serviceName\":\"IASerRequestCreation\",'+
            '      \"serviceVersion\":\"1.0\",'+
            '      \"toolID\":\"Guidanz-Mobile\",'+
            '      \"senderId\":\"pv075\",'+
            '      \"targetID\":\"AWS\"'+
            '   }'+
            '}';
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        //For getServiceRequestList method in FSL_CL_IAUtility
        FSL_CL_IAUtility.getServiceRequestList('02/12/2021', '1', '05340-05351');
       
        FSL_CL_IAUtility.getServiceRequestList('02/12/2021', '', '05340-05351');
        
        Test.stopTest();
    }
    private static user createPartnerUser(ID cId){
    Profile p = [Select ID, Name from Profile Where Name = 'EVL_Dealer_Readonly'];
    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    user u = New User(
        UserName = 'test_' + math.random() + '@test.com',
        FirstName = 'Test-First',
        LastName = 'Test-Last',
        Alias = 'test',
        email = 'test' + math.random() + '@test.com',
        CommunityNickName = string.valueOf(math.random()).substring(0,6),
        ProfileID = p.id,
        TimeZoneSidKey = 'America/New_York', 
        LocaleSidKey = 'en_US', 
        EmailEncodingKey = 'UTF-8', 
        LanguageLocaleKey = 'en_US',
        ContactID = cId,
        UserRoleId = portalRole.Id
        );

    // insert u;

    return u;
    }

    @isTest
    public static void validateCreateServiceRequestAPITest44() {
                
          asset ast=new asset();
        ast.name='123456';
        ast.Type__c='FIREPUMP';
        ast.Make__c='Test1';
        ast.Model__c='test2';
        ast.Service_Model__c='test3';
        insert ast;
        
       // Account Acc = createAccount();
        Account Acc = new Account();

        Acc.Name = 'Acc-001';
        
        acc.CSS_DistributorCode__c = '0569';
        acc.IAM_Service_Provider_Code__c = '0987';
        //acc.FSL_ERP_Customer_Code__c = '0569';
        insert acc;
       Account accountObj = [SELECT ID,Location__c FROM Account WHERE Id =: acc.Id];
       system.debug('accountObj++++'+accountObj);

        //Create Parent Group
		Group grp = new Group();
		grp.name = accountObj.Location__c;
		grp.Type = 'queue';
		Insert grp; 
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            QueueSobject queueObj = new QueueSobject();
            queueObj.QueueId = grp.Id;
            queueObj.SobjectType = 'Case';
            insert queueObj;
        }
        
       RecordType iaRequestRecTypeId = [SELECT Id,Name
                                         FROM RecordType 
                                         WHERE sObjectType='Case' AND Name='IA Request' LIMIT 1];
        Case caseObj = new Case();
        caseObj.RecordTypeId = iaRequestRecTypeId.Id;
        //caseObj.IAS_Number__c = 'IAS00032452';
        caseObj.Status = 'Intake';
        caseObj.Make__c='Honda';
        caseObj.Model__c='Civic';
        caseObj.Service_Model__c='isb219351';
        caseObj.AssetId=ast.id;
        insert caseObj;
        Case objCase = [SELECT ID,IAS_Number__c,CaseNumber,Status FROM Case WHERE Id =: caseObj.Id];       
        //create work order
        Test.startTest();
        Asset asset = FSLTestDataSetupCls.createAssetRecord();
        ServiceTerritory serviceTerritory = FSLTestDataSetupCls.createServiceTerritory();
       Workorder workOrder = FSLTestDataSetupCls.createWorkOrder(asset, accountObj, serviceTerritory);
        workOrder.CaseId = objCase.Id;
        update workOrder;
        
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
        request.httpMethod = 'POST';
        
       // String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":\"'+accountObj.Location__c+'\","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456","PrioritizedData":[{"prifc":"Pri-001","lhrprob":{"lbrprob2":"34"}}]}}';
         String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","serviceModelName": "isb219351",    "make": "Honda",    "model": "Civic","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":\"'+accountObj.Location__c+'\","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456","PrioritizedData":[{"prifc":"Pri-001","lhrprob":{"lbrprob2":"34"}}],"unPrioritizedData": [{"upfc": "1117","spn": "","fmi": "","pCode": "","occurenceTime": "","status": "","count": "","rc": "","ReasonCodeDescription": ""}]}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        Test.stopTest();
        FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
        
    }
    @isTest
    public static void testAssets() {
       
                    
              asset ast=new asset();
            ast.name='123456';
            ast.Type__c='Engines';
            ast.Make__c='Test1';
            ast.Model__c='test2';
            ast.Type_PSN__c = 'Engines-123456';
            ast.Service_Model__c='test3';
            insert ast;
            
           // Account Acc = createAccount();
            Account Acc = new Account();
    
            Acc.Name = 'Acc-001';
            
            acc.CSS_DistributorCode__c = '0569';
            acc.IAM_Service_Provider_Code__c = '0987';
            //acc.FSL_ERP_Customer_Code__c = '0569';
            insert acc;
           Account accountObj = [SELECT ID,Location__c FROM Account WHERE Id =: acc.Id];
           system.debug('accountObj++++'+accountObj);
    
            //Create Parent Group
            Group grp = new Group();
            grp.name = accountObj.Location__c;
            grp.Type = 'queue';
            Insert grp; 
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            System.runAs ( thisUser ) {
                QueueSobject queueObj = new QueueSobject();
                queueObj.QueueId = grp.Id;
                queueObj.SobjectType = 'Case';
                insert queueObj;
            }
            
           RecordType iaRequestRecTypeId = [SELECT Id,Name
                                             FROM RecordType 
                                             WHERE sObjectType='Case' AND Name='IA Request' LIMIT 1];
            Case caseObj = new Case();
            caseObj.RecordTypeId = iaRequestRecTypeId.Id;
            //caseObj.IAS_Number__c = 'IAS00032452';
            caseObj.Status = 'Intake';
            caseObj.Make__c='Honda';
            caseObj.Model__c='Civic';
            caseObj.Service_Model__c='isb219351';
            caseObj.AssetId=ast.id;
            insert caseObj;
            Case objCase = [SELECT ID,IAS_Number__c,CaseNumber,Status FROM Case WHERE Id =: caseObj.Id];       
            //create work order
            Test.startTest();
            Asset asset = FSLTestDataSetupCls.createAssetRecord();
            ServiceTerritory serviceTerritory = FSLTestDataSetupCls.createServiceTerritory();
           Workorder workOrder = FSLTestDataSetupCls.createWorkOrder(asset, accountObj, serviceTerritory);
            workOrder.CaseId = objCase.Id;
            update workOrder;
            
            Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
            RestRequest request = new RestRequest();
            RestResponse response = new RestResponse();
            
            request.addHeader('Content-Type', 'application/json');
            request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
            request.httpMethod = 'POST';
            
           // String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":\"'+accountObj.Location__c+'\","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456","PrioritizedData":[{"prifc":"Pri-001","lhrprob":{"lbrprob2":"34"}}]}}';
             String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","serviceModelName": "isb219351",    "make": "Honda",    "model": "Civic","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"model": "Other Model","make": "Other Manufacturer","UserLocation":\"'+accountObj.Location__c+'\","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456","PrioritizedData":[{"prifc":"Pri-001","lhrprob":{"lbrprob2":"34"}}],"unPrioritizedData": [{"upfc": "1117","spn": "","fmi": "","pCode": "","occurenceTime": "","status": "","count": "","rc": "","ReasonCodeDescription": ""}]}}';
            request.requestBody = Blob.valueOf(jSONRequestBody);
            RestContext.request = request;
            RestContext.response = response;
            Test.stopTest();
            FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
            
        }

        @isTest
    public static void testAssets_other() {
       
                    
              asset ast=new asset();
            ast.name='123456';
            ast.Type__c='Engines';
            ast.Make__c='Test1';
            ast.Model__c='test2';
            ast.Type_PSN__c = 'Engines-123456';
            ast.Service_Model__c='test3';
            insert ast;
            
           // Account Acc = createAccount();
            Account Acc = new Account();
    
            Acc.Name = 'Acc-001';
            
            acc.CSS_DistributorCode__c = '0569';
            acc.IAM_Service_Provider_Code__c = '0987';
            //acc.FSL_ERP_Customer_Code__c = '0569';
            insert acc;
           Account accountObj = [SELECT ID,Location__c FROM Account WHERE Id =: acc.Id];
           system.debug('accountObj++++'+accountObj);
    
            //Create Parent Group
            Group grp = new Group();
            grp.name = accountObj.Location__c;
            grp.Type = 'queue';
            Insert grp; 
            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            System.runAs ( thisUser ) {
                QueueSobject queueObj = new QueueSobject();
                queueObj.QueueId = grp.Id;
                queueObj.SobjectType = 'Case';
                insert queueObj;
            }
            
           RecordType iaRequestRecTypeId = [SELECT Id,Name
                                             FROM RecordType 
                                             WHERE sObjectType='Case' AND Name='IA Request' LIMIT 1];
            Case caseObj = new Case();
            caseObj.RecordTypeId = iaRequestRecTypeId.Id;
            //caseObj.IAS_Number__c = 'IAS00032452';
            caseObj.Status = 'Intake';
            caseObj.Make__c='Honda';
            caseObj.Model__c='Civic';
            caseObj.Service_Model__c='isb219351';
            caseObj.AssetId=ast.id;
            insert caseObj;
            Case objCase = [SELECT ID,IAS_Number__c,CaseNumber,Status FROM Case WHERE Id =: caseObj.Id];       
            //create work order
            
            Asset asset = FSLTestDataSetupCls.createAssetRecord();
            ServiceTerritory serviceTerritory = FSLTestDataSetupCls.createServiceTerritory();
           Workorder workOrder = FSLTestDataSetupCls.createWorkOrder(asset, accountObj, serviceTerritory);
            workOrder.CaseId = objCase.Id;
            update workOrder;
            
            Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_CreateServiceRequestAPI_MoTest());
            RestRequest request = new RestRequest();
            RestResponse response = new RestResponse();
            
            request.addHeader('Content-Type', 'application/json');
            request.requestURI = '/services/apexrest/IASerRequestCreation/';  //Request URL
            request.httpMethod = 'POST';
            
           // String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":\"'+accountObj.Location__c+'\","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456","PrioritizedData":[{"prifc":"Pri-001","lhrprob":{"lbrprob2":"34"}}]}}';
             String jSONRequestBody = '{"Header":{"ServiceName":"IASerRequestCreation","serviceModelName": "isb219351",    "make": "Honda",    "model": "Civic","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"model": "T660","make": "KENWORTH","UserLocation":\"'+accountObj.Location__c+'\","IASNumber":"IAS-001","WONumber":\"'+objCase.CaseNumber+'\","PSN":"123456","unPrioritizedData": [{"upfc": "1117","spn": "","fmi": "","pCode": "","occurenceTime": "","status": "","count": "","rc": "","ReasonCodeDescription": ""}],"PrioritizedData":[{"relfc": [{"rfc": "3574","spn": "","fmi": "","pCode": "", "occurenceTime": "15255","status": "active","count": "1", "relatedFaultCodeDescription": "","derateValue1": "","derateValue2": "","derateValue3": "","severity": "","shutdownDescription": ""},{"rfc": "3574","spn": "","fmi": "", "pCode": "","occurenceTime": "15255","status": "active","count": "1","relatedFaultCodeDescription": "","derateValue1": "", "derateValue2": "","derateValue3": "","severity": "","shutdownDescription": "" }]},{"prifc":"Pri-001","lhrprob":{"lbrprob2":"34"}}]}}';
            request.requestBody = Blob.valueOf(jSONRequestBody);
            RestContext.request = request;
            RestContext.response = response;

            FSL_Switch__c FSlSwitch = FSL_TestDataUtility.createFSLSwitchRecord('Enable_FTR_Switch', true);
            insert FSlSwitch;

            Test.startTest();
            FSL_CL_IA_CreateServiceRequestAPI.createIAServiceRequest();
            Test.stopTest();
            
            
        }

    }