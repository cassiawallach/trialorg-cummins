/**********************************************************************
Name: CSS_WS_TG_GetMakeModelAccessListTest
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is Test class for CSS_WS_TG_GetMakeModelAccessList 
            web service of Triage
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/21/2016     INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CSS_WS_TG_GetMakeModelAccessListTest {
    
    @isTest static void testGetMakeModelAccessListResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetMakeModelAccessListMockTest());
        
        String jSONRequestBody = '{"Header": {"ServiceName": "GetMakeModelAccessList","ServiceVersion": "1.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS"},"DataArea": {"PSN": "79484646"}  }';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetMakeModelAccessList/';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;

        CSS_WS_TG_GetMakeModelAccessList.getMakeModelAccessList(); 
        Test.stopTest();
    }
    
    
    @isTest static void testGetToolIDError(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetMakeModelAccessListMockTest());
        
        String jSONRequestBody = '{"Header": {"ServiceName": "GetMakeModelAccessList","ServiceVersion": "1.0","ToolID": "","SenderID": "oh559","TargetID": "CSS"},"DataArea": {"PSN": "79484646"}  }';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetMakeModelAccessList/';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
       
        CSS_WS_TG_GetMakeModelAccessList.getMakeModelAccessList(); 
        Test.stopTest();
    }
    
    @isTest static void testGetServiceNameError(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetMakeModelAccessListMockTest());
        
        String jSONRequestBody = '{"Header": {"ServiceName": "","ServiceVersion": "1.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS"},"DataArea": {"PSN": "79484646"}  }';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetMakeModelAccessList/';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
       
        CSS_WS_TG_GetMakeModelAccessList.getMakeModelAccessList(); 
        
        jSONRequestBody = '{"Header": {"ServiceName": "Test","ServiceVersion": "1.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS"},"DataArea": {"PSN": "79484646"}  }';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetMakeModelAccessList.getMakeModelAccessList(); 
        
        Test.stopTest();
    }
    
    @isTest static void testGetPSNError(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetMakeModelAccessListMockTest());
        
        String jSONRequestBody = '{"Header": {"ServiceName": "GetMakeModelAccessList","ServiceVersion": "1.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS"},"DataArea": {"PSN": ""}  }';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetMakeModelAccessList/';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
       
        CSS_WS_TG_GetMakeModelAccessList.getMakeModelAccessList(); 
        Test.stopTest();
    }
    
    @isTest static void testGetInputError(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetMakeModelAccessListMockTest());
        
        String jSONRequestBody = '';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetMakeModelAccessList/';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
       
        CSS_WS_TG_GetMakeModelAccessList.getMakeModelAccessList(); 
        Test.stopTest();
    }
    
    @isTest static void testGetInvalidJSONError(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetMakeModelAccessListMockTest());
        
        String jSONRequestBody = '{{"Header": {"ServiceName": "GetMakeModelAccessList","ServiceVersion": "1.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS"},"DataArea": {"PSN": "79634249"}  }}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetMakeModelAccessList/';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
       
        CSS_WS_TG_GetMakeModelAccessList.getMakeModelAccessList(); 
        Test.stopTest();
    }
    
    @isTest static void testGetMakeModelAccessListResponse1(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetMakeModelAccessListMockTest());
        
        String jSONRequestBody = '{"Header": {"ServiceName": "GetMakeModelAccessList","ServiceVersion": "1.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS"},"DataArea": {"PSN": "79484646"}  }';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetMakeModelAccessList/';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        
        String smn = CSS_WS_QSOL.getSMNFromQSOL('79484646', 'Assess');
        List<CSS_Make_Model_Access__c> makeModelAccessList = CSS_FN_Triage.getMakeModelAccessListOfSMN(smn);
        
        CSS_Make_Model_Access__c mmaObj = new CSS_Make_Model_Access__c(Make__c='PETERBILT', Model__c='388', Access__c='C', Service_Model_Name__c='ISX15 CM2250');
        insert mmaObj;
        makeModelAccessList = new List<CSS_Make_Model_Access__c>();
        makeModelAccessList.add(mmaObj);
        List<CSS_WPR_TG_MakeModlAcsResJSON2Apex.MAKEMODELACCESS> mmaList = CSS_FN_Triage.getMMAWrapperList(makeModelAccessList);
        
        CSS_WS_TG_GetMakeModelAccessList.getMakeModelAccessList();
        Test.stopTest();
    }
    
    @isTest static void testGetMakeModelAccessListErrorResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetMakeModelAccessListMockTest());
        
        String jSONRequestBody = '{"Header": {"ServiceName": "GetMakeModelAccessList","ServiceVersion": "1.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS"},"DataArea": {"PSN": "79484646"}  }';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetMakeModelAccessList/';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jSONRequestBody);
        //RestContext.request = null;
        //RestContext.response= null;

        CSS_WS_TG_GetMakeModelAccessList.getMakeModelAccessList(); 
        Test.stopTest();
    }
   
    @isTest static void testmethodcatchmethod(){
         CSS_WPR_TG_MakeModlAcsResJSON2Apex resJSON = null;
         CSS_FN_Triage tgFNObj = new CSS_FN_Triage();
        CSS_FN_Triage.WrapperInput wrapperObj = new CSS_FN_Triage.WrapperInput();
        wrapperObj.status = 'Error';
            wrapperObj.statusMsg = 'CSS03-Invalid JSON Format';
            resJSON = tgFNObj.prepareResponseWrapperForMakeModelAccess(wrapperObj);
           css_utility.prepareRESTResponse(resJSON, 400);
         //CSS_WS_TG_GetMakeModelAccessList.getMakeModelAccessList(); 
       // system.assertNotEquals(wrapperObj.status = 'Error', 'Error');
    }
}