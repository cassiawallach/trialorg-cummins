@isTest
public class CSS_WS_WebServicesExternalMock_Test {
    static testmethod void AccountCoverage() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxAccCov';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void EngineData() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxEngData';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void CampaignData() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxCampData';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void validateMultiESN() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxMultiESN';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void getSPData() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxSPData';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void getSRTData() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxSRTData';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void getSRTOverlap() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxSRTOver';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void getPartsData() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxPrtsData';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void createStatementMX() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxCreatStm';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void getStatementMX() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/getStatementMX';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void getCurrencyExchange() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/getCurrencyExchange';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void getCssAmount() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/getCssAmount';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void ODMValidationHeader() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxHeadVal';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void ODMValidationFailure() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxFailVal';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void ODMValidationParts() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxPrtsVal';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void ODMValidationTravel() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxTraVal';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void ODMValidationOtherClaimable() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxOCVal';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void ODMValidationSRT() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxSRTVal';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void ODMValidationPreSubmit() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxPreSub';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void claimSubmission() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/MxClaimSub';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
    static testmethod void withoutURI() {
        try {
            Test.startTest();
            System.RestContext.request = new RestRequest();
            System.RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/mock_webservice/';
            RestContext.request.httpMethod = 'POST';
            
            CSS_WS_WebServicesExternalMock.doPost();
        } catch (NullPointerException npe) {
            System.debug('Error: ' + npe.getMessage());
        }
    }
}