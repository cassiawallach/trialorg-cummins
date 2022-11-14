/*
* Test Class for Apex Controller - FSL_CL_HelpfulResource
* Author - Piyush Rani 
Sriprada -- adding comment to deploy test class for code coverage
*/ 
@isTest
Public class FSL_CL_HelpfulResource_Test {
    
    //Adding test class for the test coverage 
    @isTest
    static void startRequest_Test() {
        Test.startTest();
        
        Asset aset = FSL_TestDataUtility.createAsset();
        
        FSL_CL_HelpfulResource.startRequest(aset.Name);
        
        Test.stopTest();
    }
    
    @isTest
    static void startRequestInValidPSN_Test() {
        Test.startTest();
        FSL_CL_HelpfulResource helpfulResource = new FSL_CL_HelpfulResource();
        Asset aset = FSL_TestDataUtility.createAsset();
        
        FSL_CL_HelpfulResource.startRequest(aset.Id);
        FSL_CL_HelpfulResource.isdealerProfile(); //Added by Piyush for VGRS2-231
        
        Test.stopTest();
    }
}